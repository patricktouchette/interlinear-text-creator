use openrussian;

-- Get a list of RU-EN translations
SELECT b.bare, group_concat(tl) as tl 
FROM bares b 
JOIN translations t ON (b.id = t.word_id) 
WHERE b.bare IN ('Раннее', 'детство', 'Антона', 'протекало',  'в', 'бесконечных', 'церковных' , 'праздниках', 'и',  'именинах') 
AND t.lang = "en"
group by b.bare;


select * from adjectives;

select * from words;
select * from sentences;
select * from sentences_words;

select * from bares 
where bare = "протекать";


select b.bare, group_concat(t.tl) 
from bares b 
JOIN translations t ON (b.id = t.word_id)
where b.bare = "протекать"
and lang='en'
group by b.bare ;

-- GETTING ALL THE ADJECTIVES
select *
from bares b
JOIN adjectives a ON (b.id = a.word_id)
JOIN declensions d ON (b.id = d.word_id)
where type = 'adjective';

select * from adjectives;

CREATE OR REPLACE VIEW RU_EN AS
-- ==================
-- 0. BARES
-- ==================
select b.id AS word_id, b.bare, b.bare AS word
from bares b
UNION ALL
-- ==================
-- 1. Adjectives
-- ==================
-- 1.1 comparative
SELECT 
	b.id AS word_id, 
	b.bare, 
	a.comparative AS word
FROM bares b
JOIN adjectives a ON (b.id = a.word_id)
WHERE a.comparative IS NOT NULL
UNION ALL
-- 1.2 Superlative
SELECT 
	b.id AS word_id, 
	b.bare, 
	a.superlative AS word
FROM bares b
JOIN adjectives a ON (b.id = a.word_id)
WHERE a.superlative IS NOT NULL
UNION ALL
-- 1.3 short_m
SELECT 
	b.id AS word_id, 
	b.bare, 
	a.short_m AS word
FROM bares b
JOIN adjectives a ON (b.id = a.word_id)
WHERE a.short_m IS NOT NULL
UNION ALL
-- 1.4 short_f
SELECT 
	b.id AS word_id, 
	b.bare, 
	a.short_f AS word
FROM bares b
JOIN adjectives a ON (b.id = a.word_id)
WHERE a.short_f IS NOT NULL
UNION ALL
-- 1.5 short_n
SELECT 
	b.id AS word_id, 
	b.bare, 
	a.short_n AS word
FROM bares b
JOIN adjectives a ON (b.id = a.word_id)
WHERE a.short_n IS NOT NULL
UNION ALL
-- 1.6 short_pl
SELECT 
	b.id AS word_id, 
	b.bare, 
	a.short_pl AS word
FROM bares b
JOIN adjectives a ON (b.id = a.word_id)
WHERE a.short_pl IS NOT NULL

;
UNION ALL
-- ==================
-- 2. Declensions
-- ==================
-- 2.1 Nominative
SELECT 
	b.id AS word_id, 
	b.bare, 
	d.nom AS word
FROM bares b
JOIN declensions d ON (b.id = d.word_id)
WHERE d.nom IS NOT NULL
UNION ALL
-- 2.2 Genitive
SELECT 
	b.id AS word_id, 
	b.bare, 
	d.gen AS word
FROM bares b
JOIN declensions d ON (b.id = d.word_id)
WHERE d.gen IS NOT NULL
UNION ALL
-- 2.3 Dative
SELECT 
	b.id AS word_id, 
	b.bare, 
	d.dat AS word
FROM bares b
JOIN declensions d ON (b.id = d.word_id)
WHERE d.dat IS NOT NULL
UNION ALL
-- 2.4 Accusative
SELECT 
	b.id AS word_id, 
	b.bare, 
	d.acc AS word
FROM bares b
JOIN declensions d ON (b.id = d.word_id)
WHERE d.acc IS NOT NULL
UNION ALL
-- 2.5 inst
SELECT 
	b.id AS word_id, 
	b.bare, 
	d.inst AS word
FROM bares b
JOIN declensions d ON (b.id = d.word_id)
WHERE d.inst IS NOT NULL
UNION ALL
-- 2.6 Prepositional
SELECT 
	b.id AS word_id, 
	b.bare, 
	d.prep AS word
FROM bares b
JOIN declensions d ON (b.id = d.word_id)
WHERE d.prep IS NOT NULL
-- UNION ALL
GROUP BY word
;


select count(*) from ru_en;
SELECT ru_en.word AS bare, group_concat(t.tl) AS tl 
FROM ru_en 
JOIN translations t ON (ru_en.id = t.word_id) 
WHERE ru_en.word IN ('Раннее', 'детство', 'Антона', 'протекало',  'в', 'бесконечных', 'церковных' , 'праздниках', 'и',  'именинах') 
AND t.lang = "en" 
group by ru_en.word;

-- ==================
-- 3. Nouns ...NOT needed, since they are all in the declensions
-- ==================

select * from verbs where word_id = 18155;
select * from conjugations;
select * from verbs
JOIN conjugations
where verbs.word_id = 18155
and conjugations.word_id = 18155;


-- ==================
-- Creating a RU_EN view
-- ==================
CREATE TABLE RU_EN (id int(11), bare varchar(100), word varchar(100));

CREATE OR REPLACE VIEW RU_EN AS
select id, bare, bare AS word
from bares;
