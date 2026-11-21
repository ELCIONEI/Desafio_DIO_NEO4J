// ============================================================================
// SCRIPT DE CARGA DE DADOS - SISTEMA DE RECOMENDAÇÃO DE MÚSICAS (NEO4J)
// ============================================================================

// 1. Carregar Usuários
LOAD CSV WITH HEADERS FROM 'file:///usuarios.csv' AS row
MERGE (u:Usuario {id: toInteger(row.id)})
SET u.nome = row.nome;

// 2. Carregar Músicas, Artistas, Gêneros e seus Relacionamentos
LOAD CSV WITH HEADERS FROM 'file:///musicas.csv' AS row
MERGE (m:Musica {id: toInteger(row.id)})
SET m.titulo = row.titulo,
    m.ano = toInteger(row.ano)
MERGE (a:Artista {nome: row.artista})
MERGE (g:Genero {nome: row.genero})
MERGE (m)-[:CANTADA_POR]->(a)
MERGE (m)-[:PERTENCE_A]->(g);

// 3. Carregar Interações (ESCUTOU e CURTIU)
LOAD CSV WITH HEADERS FROM 'file:///interacoes.csv' AS row
MATCH (u:Usuario {id: toInteger(row.usuario_id)})
MATCH (m:Musica {id: toInteger(row.musica_id)})
MERGE (u)-[e:ESCUTOU]->(m)
SET e.vezes = toInteger(row.vezes)
FOREACH (_ IN CASE WHEN row.curtiu = 'true' THEN [1] ELSE [] END |
  MERGE (u)-[:CURTIU]->(m)
);
