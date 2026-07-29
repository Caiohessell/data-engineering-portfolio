-- Quantos registros existem na tabela?

SELECT COUNT(*) 
FROM students;


-- Quais colunas existem?

SELECT *
FROM students
LIMIT 5;


-- Existem valores nulos nas colunas utilizadas na análise?

SELECT
    COUNT(*) AS total_registros,
    COUNT(todep) AS total_reg_depressao,
    COUNT(age) AS total_reg_idade,
    COUNT(gender) AS total_reg_genero,
    COUNT(inter_dom) AS total_reg_tipo
FROM students;


-- Existem categorias escritas de maneiras diferentes?

SELECT DISTINCT gender
FROM students;

SELECT DISTINCT inter_dom
FROM students;

SELECT DISTINCT academic
FROM students;

SELECT DISTINCT todep
FROM students;


-- Qual a idade mínima e a máxima no conjunto?

SELECT MIN(age) AS  idade_minima, MAX(age) AS idade_maxima
FROM students;


-- Como estão distribuídas as idades?

SELECT age AS idade, COUNT(age) AS total_idade
FROM students
WHERE age IS NOT NULL
GROUP BY age
ORDER BY age;


-- Qual a pontuação mínima e máxima dos níveis de depressão?

SELECT MIN(todep) AS min_pts, MAX(TODEP) AS max_pts
FROM students
WHERE todep IS NOT NULL;

