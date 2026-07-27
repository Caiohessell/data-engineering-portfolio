-- Como os estudantes estão distribuídos entre locais e internacionais?

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


-- Qual é a distribuição por gênero?

SELECT gender AS genero, 
       COUNT(*) AS total_genero,
       ROUND(
        COUNT(*) * 100.0 / (
            SELECT COUNT(*)
            FROM students
            WHERE gender IS NOT NULL
        ),
        2
    ) AS percentual
FROM students
WHERE gender IS NOT NULL
GROUP BY gender;

-- Qual é a distribuição por faixa etária?

SELECT
    CASE
    WHEN age BETWEEN 17 AND 19 THEN '17-19'
    WHEN age BETWEEN 20 AND 22 THEN '20-22'
    WHEN age BETWEEN 23 AND 25 THEN '23-25'
    ELSE 'Acima de 26'
END AS faixa_etaria, 
    COUNT(*) AS total,
    ROUND(
        COUNT(*) * 100.0 / (
            SELECT COUNT(*)
            FROM students
            WHERE age IS NOT NULL
        ),
        2
    ) AS percentual
FROM students
WHERE age IS NOT NULL
GROUP BY faixa_etaria
ORDER BY faixa_etaria;


-- Como está distribuído o domínio da língua japonesa?

SELECT japanese_cate AS nivel_lingua, 
        COUNT(*) AS total,
        ROUND(
        COUNT(*) * 100.0 / (
            SELECT COUNT(*)
            FROM students
            WHERE japanese_cate IS NOT NULL
        ),
        2
    ) AS percentual
FROM students
WHERE japanese_cate IS NOT NULL
GROUP BY japanese_cate
ORDER BY japanese_cate;


-- Como está distribuído o domínio da língua inglesa?

SELECT english_cate AS nivel_lingua, 
        COUNT(*) AS total,
        ROUND(
        COUNT(*) * 100.0 / (
            SELECT COUNT(*)
            FROM students
            WHERE english_cate IS NOT NULL
        ),
        2
    ) AS percentual
FROM students
WHERE english_cate IS NOT NULL
GROUP BY english_cate
ORDER BY english_cate;


-- Como está distribuída a conexão social?

SELECT tosc AS nivel_conexao, 
        COUNT(*) AS total,
        ROUND(
        COUNT(*) * 100.0 / (
            SELECT COUNT(*)
            FROM students
            WHERE tosc IS NOT NULL
        ),
        2
    ) AS percentual
FROM students
WHERE tosc IS NOT NULL
GROUP BY tosc
ORDER BY tosc DESC;
