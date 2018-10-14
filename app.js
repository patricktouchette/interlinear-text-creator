const express = require("express");
const mysql = require("mysql");
const bodyParser = require("body-parser");
const app = express();
const port = 3000

app.set("view engine", "ejs");
app.use(bodyParser.urlencoded({extended: true}));
app.use(express.static(__dirname + "/public"));

var wordsList = [
    'Раннее', 'детство', 'Антона', 'протекало',  'в', 'бесконечных', 'церковных' , 'праздниках', 'и',  'именинах'
]

let connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'admin',
    database: 'openrussian'
});

connection.connect();

app.get("/", (req, res) => {
    var q = "SELECT COUNT(*) as count FROM bares";
    connection.query(q, function(err, results){
        if (err) throw err;
        console.log(results[0].count)
        res.render("home");
    })
});

app.get("/translate", (req, res) => {

    const getTranslation = function (callback) {
        var translated = [];
        connection.query( 'SELECT b.bare, group_concat(t.tl) AS tl FROM ru_en b JOIN translations t ON (b.id = t.word_id) WHERE b.bare IN (?) AND t.lang = "en" group by b.bare',
        [wordsList], function (error, results, fields) {
            if (error) throw error;
            console.log(results);
            try {
                translated = results.map(result => ({"word" : result.bare, "tl" : result.tl}))
            }
            catch (err) {
                console.log(err);
            }
            callback(translated)
        });
    }

    getTranslation (function(translated) {
        console.log("This is the list of translated words" , translated);
        res.render("translate", {translated: translated})
    });

});

app.listen(port, function() {
    console.log(`Server running on localhost:${port}`)
})
