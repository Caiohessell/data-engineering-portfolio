/*
Nesta sessão, irei responder algumas perguntas de negócio relacionadas a base de dados usando SQL para fazer cruzamento de informações 
que possam ser relevantes na criação de insights. Abaixo estarão dispostas 8 perguntas que serão respondidas em sequência e
comentadas ao final. 
*/



/* Como os estudantes estão distribuídos entre locais e internacionais?

Objetivo

Verificar onde se ma maior parte dos estudantes é local ou internacional.
*/

SELECT 
    inter_dom AS tipo_estudante,
    COUNT(inter_dom) AS total_tipo,
    ROUND(
        COUNT(inter_dom) * 100.0 / (
            SELECT COUNT(inter_dom)
            FROM students
            WHERE inter_dom IS NOT NULL
        ),
        2
    ) AS percentual
FROM students
WHERE inter_dom IS NOT NULL
GROUP BY inter_dom;

-- Na saída do cógido verificou-se que do total de 268 estudantes temos 75% internacionais e 25% locais.


/*
Estudantes internacionais apresentam maior média de depressão?

Objetivo

Comparar os dois grupos.
*/

SELECT inter_dom AS tipo_estudante, 
        COUNT(*) AS qtd_estudantes,
        ROUND(AVG(todep), 2) AS media_depressao
FROM students
WHERE todep IS NOT NULL
GROUP BY inter_dom
ORDER BY media_depressao DESC;

/*
Apesar de apresentar uma média maior no grupo doméstico, deve-se levar em consideração a quantidade de amostras por grupo,
pois no grupo doméstico temos uma quantidade menor de amostras comparadas ao grupo internacional e isso faz com que a 
média se comporte de maneira mais sensível em grupos de tamanho reduzido. Por fim isso não quer dizer que essa diferença
seja substancial entre os grupos
*/


/*
O tempo de permanência influencia os níveis de depressão?

Objetivo

Verificar se estudantes recém-chegados apresentam índices diferentes daqueles que já vivem há mais tempo no país.
*/

SELECT
    CASE
        WHEN stay <= 1 THEN 'Até 1 ano'
        WHEN stay BETWEEN 2 AND 3 THEN '2-3 anos'
        WHEN stay BETWEEN 4 AND 5 THEN '4-5 anos'
        ELSE 'Mais de 5 anos'
    END AS faixa_permanencia,
    ROUND(AVG(todep), 2) AS media_depressao,
    COUNT(*) AS total_estudantes
FROM students
WHERE inter_dom = 'Inter'
  AND todep IS NOT NULL
GROUP BY faixa_permanencia
ORDER BY media_depressao DESC;

/*
Observando a saída concluo que o maior índice de depressão ocorre entre os 2-3 anos de permanência, isso pode envolver
várias questões como nível de conexão com a cultura, dificuldade com a língua falada dentre outros fatores. Portanto
devido a densidade de amostras estar parecida, podemos concluir que o primeiro ano não possuí o maior nível de posntuação
nos testes de depressão.
*/



