// ============================================================================
// QUERIES DE NEGÓCIO E RECOMENDAÇÃO
// ============================================================================

// 1. Visualização do Esquema do Grafo
CALL db.schema.visualization();

// 2. Filtragem Colaborativa (Tabela)
MATCH (ana:Usuario {nome: 'Ana'})-[:CURTIU]->(m:Musica)<-[:CURTIU]-(outro:Usuario)-[:CURTIU]->(rec:Musica)
WHERE NOT (ana)-[:ESCUTOU]->(rec)
RETURN rec.titulo AS Musica_Recomendada, 
       count(DISTINCT outro) AS Usuarios_Em_Comum, 
       collect(DISTINCT outro.nome) AS Recomendado_Por
ORDER BY Usuarios_Em_Comum DESC;

// 3. Filtragem Colaborativa (Visualização em Grafo)
MATCH p = (ana:Usuario {nome: 'Ana'})-[:CURTIU]->(m:Musica)<-[:CURTIU]-(outro:Usuario)-[:CURTIU]->(rec:Musica)
WHERE NOT (ana)-[:ESCUTOU]->(rec)
RETURN p;

// 4. Recomendação por Gênero Favorito
MATCH (ana:Usuario {nome: 'Ana'})-[:CURTIU]->(:Musica)-[:PERTENCE_A]->(g:Genero)<-[:PERTENCE_A]-(rec:Musica)-[:CANTADA_POR]->(a:Artista)
WHERE NOT (ana)-[:ESCUTOU]->(rec)
RETURN DISTINCT rec.titulo AS Musica_Recomendada, 
       a.nome AS Artista, 
       g.nome AS Genero;

// 5. Ranking das Músicas Mais Ouvidas na Plataforma
MATCH (u:Usuario)-[e:ESCUTOU]->(m:Musica)-[:CANTADA_POR]->(a:Artista)
RETURN m.titulo AS Musica, 
       a.nome AS Artista, 
       sum(e.vezes) AS Total_Reproducoes
ORDER BY Total_Reproducoes DESC
LIMIT 5;
