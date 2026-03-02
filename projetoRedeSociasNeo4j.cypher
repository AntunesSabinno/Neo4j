

// 1. Criar índice para performance (Obrigatório para evitar DB Hits excessivos)
CREATE CONSTRAINT IF NOT EXISTS FOR (u:Usuario) REQUIRE u.userid IS UNIQUE;

// 2. Carregar o CSV e mapear todas as colunas
LOAD CSV WITH HEADERS FROM 'file:///pseudo_facebook.csv' AS row
MERGE (u:Usuario {userid: row.userid})
SET 
    u.age = toInteger(row.age),
    u.dob_day = toInteger(row.dob_day),
    u.dob_year = toInteger(row.dob_year),
    u.dob_month = toInteger(row.dob_month),
    u.gender = row.gender,
    u.tenure = toInteger(row.tenure),
    u.friend_count = toInteger(row.friend_count),
    u.friendships_initiated = toInteger(row.friendships_initiated),
    u.likes = toInteger(row.likes),
    u.likes_received = toInteger(row.likes_received),
    u.mobile_likes = toInteger(row.mobile_likes),
    u.mobile_likes_received = toInteger(row.mobile_likes_received),
    u.www_likes = toInteger(row.www_likes),
    u.www_likes_received = toInteger(row.www_likes_received);

    // retorna genero,quantidade e media de idade

match t= (u:Usuario) return t
match (u:Usuario)
return u.gender as Genero,
count(u) as quantidade,
avg(u.age) As  Media_Idade

// mostra como a query esta performando
EXPLAIN
 MATCH T=(U:Usuario)
 return T


 PROFILE
MATCH (u:Usuario)
RETURN u.gender AS Genero, 
       count(u) AS Total, 
       avg(u.age) AS MediaIdade




// cria nós e relacionamentos das gerações Y e Z

// Criar nós de Geração 

MERGE (g1:Geracao {nome: "Gen Z", descricao: "Nascidos após 1997"})
MERGE (g2:Geracao {nome: "Millennials", descricao: "Nascidos entre 1981 e 1996"})

// Conectar usuários às gerações baseadas no ano de nascimento
MATCH (u:Usuario)
WHERE u.dob_year >= 1996
MATCH (g:Geracao {nome: "Gen Z"})
MERGE (u)-[:PERTENCE_A]->(g);

MATCH (u:Usuario)
WHERE u.dob_year >= 1981 AND u.dob_year <= 1995
MATCH (g:Geracao {nome: "Millennials"})
MERGE (u)-[:PERTENCE_A]->(g);


// retorna as gerações dos users
MATCH (U:Usuario)-[:PERTENCE_A]->(G:Geracao) return U