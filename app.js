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
        var translated = ['TEST'];
        wordsList.forEach( (word) => {
            connection.query( 'SELECT b.bare, t.tl FROM bares b JOIN translations t ON (b.id = t.word_id) WHERE b.bare = ? AND t.lang = "en"',
            [word], function (error, results, fields) {
                if (error) throw error;
                try {
                    console.log(word, results[0].tl);
                    translated.push({"word": word, "tl": results[0].tl});
                }
                catch (err) {
                    console.log(word, results[0]);
                    translated.push({"word": word, "tl": "none"});
                }
            });
        })
        callback(translated)
    }

    getTranslation (function(translated) {
        console.log(translated);
        res.render("translate", {translated: translated})
    });

});

app.listen(port, function() {
    console.log(`Server running on localhost:${port}`)
})
