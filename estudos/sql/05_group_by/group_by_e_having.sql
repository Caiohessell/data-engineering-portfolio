/*Aqui vou responder algumas perguntas de negócios utilizando alguns conceitos aplicados anteriormente (ordenação, filtragem, seleção, etc)
e mesclando com agrupamento buscando responder as questões da melhor forma*/


-- O time de produto quer entender quantos produtos existem por categoria.
SELECT categoria_id, 
        COUNT(categoria_id) AS total_produtos
FROM produtos
GROUP BY categoria_id
ORDER BY categoria_id;

-- O time de pricing quer calcular a média de preço por categoria.
SELECT categoria_id, 
        ROUND(AVG(preco), 2) AS preco_medio
FROM produtos
GROUP BY categoria_id
ORDER BY categoria_id;

-- A diretoria quer identificar categorias cujo preço médio seja superior a 1000.
SELECT categoria_id, 
        ROUND(AVG(preco), 2) AS preco_medio
FROM produtos
GROUP BY categoria_id
HAVING AVG(preco) > 1000
ORDER BY categoria_id;

-- O time de supply chain quer analisar quantos produtos cada fornecedor fornece.
SELECT fornecedor_id, 
        COUNT(nome) AS quantidade_total
FROM produtos
GROUP BY fornecedor_id
ORDER BY fornecedor_id;

-- O time de operações quer agrupar pedidos por status para análise de fluxo.
SELECT status, 
        COUNT(status) AS quantidade_por_status
FROM pedidos
GROUP BY status
ORDER BY quantidade_por_status DESC;

-- O CRM quer saber quantos pedidos cada cliente realizou.
SELECT cliente_id, 
        COUNT(data_pedido) AS quantidade_pedidos
FROM pedidos
GROUP BY cliente_id
ORDER BY cliente_id;

-- O time de retenção quer identificar clientes com mais de 10 pedidos.
SELECT cliente_id, 
        COUNT(data_pedido) AS quantidade_pedidos
FROM pedidos
GROUP BY cliente_id
HAVING COUNT(data_pedido) > 10
ORDER BY cliente_id;

-- O financeiro quer analisar formas de pagamento e o total movimentado por cada uma.
SELECT forma_pagamento, 
        ROUND(SUM(valor), 2) AS total_por_forma
FROM pagamentos
GROUP BY forma_pagamento
ORDER BY forma_pagamento DESC;

-- A diretoria quer ver quais formas de pagamento ultrapassaram 30 milhões em volume.
SELECT forma_pagamento, 
        ROUND(SUM(valor), 2) AS maior_volume
FROM pagamentos
GROUP BY forma_pagamento
HAVING SUM(valor) > 30000000;

-- O time de qualidade quer saber quas produtos tem a média de avaliação maior que 4.
SELECT produto_id, 
        ROUND(AVG(nota), 2) AS media
FROM avaliacoes
GROUP BY produto_id
HAVING AVG(nota) > 4
ORDER BY produto_id;

-- O time de produto quer identificar quais produtos foram avaliados com nota 5 e a quantidade de notas em cada um.
SELECT produto_id, COUNT(nota) AS quantidade_de_avaliacoes
FROM avaliacoes
WHERE nota = '5'
GROUP BY produto_id
ORDER BY produto_id;

-- O time estratégico quer identificar estados com mais de 150 clientes cadastrados.
SELECT estado,
        COUNT(nome) AS total_estado 
FROM clientes
GROUP BY estado
HAVING COUNT(nome) >150
ORDER BY total_estado DESC;