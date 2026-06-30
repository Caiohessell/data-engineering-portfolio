
/*Abaixo utilizei conceitos de agregação, filtragem e ordenação para realizar e organizar consultas diversas buscando responder algumas perguntas de negócio*/

-- O time de gestão quer saber quantos clientes existem na base atualmente.
SELECT COUNT(*) AS total_clientes
FROM clientes;

-- O catálogo quer saber quantos produtos estão cadastrados no sistema.
SELECT COUNT(*) AS total_produtos
FROM produtos;

-- O financeiro quer a soma total dos preços de todos os produtos.
SELECT ROUND(SUM(preco), 2) AS total_preco
FROM produtos;

-- O time de pricing quer calcular o preço médio dos produtos.
SELECT ROUND(AVG(preco), 2) AS preco_medio_produtos
FROM produtos;

-- A diretoria quer identificar qual é o produto mais caro da base.
SELECT nome, preco 
FROM produtos
WHERE preco = (SELECT MAX(preco) FROM produtos);

-- O time de catálogo quer identificar o valor do produto mais barato disponível.
SELECT nome, preco
FROM produtos
WHERE preco = (SELECT MIN(preco) FROM produtos);

-- O time de operações quer saber o total de pedidos realizados.
SELECT COUNT(data_pedido)
FROM pedidos;

-- O financeiro quer calcular o total dos pagamentos feitos em pix.
SELECT forma_pagamento, ROUND(SUM(valor), 2) AS valor_total
FROM pagamentos
WHERE forma_pagamento = 'BOLETO'
GROUP BY forma_pagamento;

-- O financeiro quer saber o valor médio gasto por pedido.
SELECT ROUND(AVG(valor_unitario), 2) AS valor_medio_gasto 
FROM itens_pedido;

-- O time de qualidade quer identificar a quantidade de notas por categoria de avaliação mais altas.
SELECT nota, COUNT(nota) AS quantidade_de_notas 
FROM avaliacoes
WHERE nota IN (4, 5)
GROUP BY nota
ORDER BY nota DESC;

-- O time de qualidade quer identificar a quantidade total de avaliações medianas.
SELECT nota, COUNT(nota) AS quantiadade_de_notas_medianas
FROM avaliacoes
WHERE nota IN (3)
GROUP BY nota;

-- O financeiro quer saber qual a média de valor gerado por cada forma de pagamento.
SELECT forma_pagamento, ROUND(AVG(valor), 2) AS valor_medio_por_forma
FROM pagamentos
GROUP BY forma_pagamento
ORDER BY valor_medio_por_forma DESC;