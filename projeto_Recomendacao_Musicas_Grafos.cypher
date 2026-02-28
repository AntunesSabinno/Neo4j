// CRIAÇÃO DAS CONSTRAINTS 

CREATE CONSTRAINT FOR  (u:User) REQUIRE u.id IS UNIQUE;
CREATE CONSTRAINT FOR (s:Song) REQUIRE s.id IS UNIQUE;
CREATE CONSTRAINT FOR (a:Artist) REQUIRE a.id IS UNIQUE;
CREATE CONSTRAINT FOR (g:Genre) REQUIRE g.id IS UNIQUE; 

// CRIAÇÃO DOS NÓS

CREATE (:User{id:'u1',name:'Ana Luiza'})
CREATE (:Artist{id:'a1',name:"The Beatles"})
CREATE(:Genre{id:"g1",name:"Rock"})
CREATE (:Song{id:"s1",title:'Hey Jude',year:1968})
CREATE (:Song{id:"s2",title:'Let it Be',year:1970})



// Criando relacionamentos
MATCH (s:Song {id:'s1'}),(a:Artist {id:'a1'})
CREATE (s)-[:BY]->(a)
MATCH (s:Song {id: 's1'}), (g:Genre {id: 'g1'})
CREATE (s)-[:BELONGS_TO]->(g)
MATCH (u:User {id: 'u1'}), (s:Song {id: 's1'})
CREATE (u)-[:LISTENED {count: 10, rating: 5}]->(s)



// QUERY 1 
MATCH (me:User {id: 'u1'})-[:LISTENED]->(s:Song)<-[:LISTENED]-(similar:User)
MATCH (similar)-[:LISTENED]->(rec:Song)
WHERE NOT (me)-[:LISTENED]->(rec)
RETURN rec.title AS recommendation, COUNT(similar) AS score
ORDER BY score DESC
LIMIT 10


// QUERY 2
MATCH (me:User {id: 'u1'})-[:LISTENED]->(s:Song)-[:BY]->(a:Artist)
MATCH (a)-[:SIMILAR_TO*1..2]->(similar:Artist)<-[:BY]-(rec:Song)
WHERE NOT (me)-[:LISTENED]->(rec)
RETURN rec.title, similar.name AS via_artist
LIMIT 10

//QUERY 3
MATCH (me:User {id: 'u1'})-[l:LISTENED]->(s:Song)-[:BELONGS_TO]->(g:Genre)
MATCH (rec:Song)-[:BELONGS_TO]->(g)
WHERE NOT (me)-[:LISTENED]->(rec)
WITH rec, 
     COUNT(g) * 1.0 AS genreScore,
     AVG(l.rating) AS avgRating
RETURN rec.title, (genreScore * avgRating) AS hybridScore
ORDER BY hybridScore DESC
LIMIT 10