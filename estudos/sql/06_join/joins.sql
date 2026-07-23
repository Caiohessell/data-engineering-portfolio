/*Nesta sessão aplicarei os conceitos de junção de tabelas usando JOINS e outros conceitos que serão necessários para responder as perguntas que estão listadas aqui*/


-- Quais clientes realizaram mais pedidos nos últimos 12 meses?

SELECT c.nome AS nome_cliente, COUNT(p.data_pedido) AS total_pedido
FROM clientes AS c
INNER JOIN pedidos AS p
    ON c.id = p.cliente_id
WHERE data_pedido BETWEEN '01/07/2025' AND '01/07/2026'
GROUP BY nome
ORDER BY total_pedido DESC;


-- Qual foi o faturamento total gerado por cada cliente?

SELECT p.cliente_id ,
        c.nome, 
            ROUND(SUM(i.quantidade * i.valor_unitario), 2) AS total_cliente
FROM clientes AS c
INNER JOIN pedidos AS p
    ON c.id = p.cliente_id
INNER JOIN itens_pedido AS i
    ON i.pedido_id = p.id
GROUP BY c.nome, p.cliente_id
ORDER BY total_cliente DESC;


-- Quais produtos tiveram maior volume de vendas?

SELECT p.nome AS produto, 
    SUM(i.quantidade) AS maior_volume
FROM produtos AS p
INNER JOIN itens_pedido AS i
ON p.id = i.produto_id
GROUP BY p.nome
ORDER BY maior_volume DESC;


-- Qual categoria de produto gerou maior faturamento?

SELECT c.nome AS categoria,
    ROUND(SUM(i.valor_unitario * i.quantidade),2) AS maior_faturamento
FROM categorias AS c
INNER JOIN produtos AS p
ON c.id = p.categoria_id
INNER JOIN itens_pedido AS i
ON p.id = i.produto_id
GROUP BY c.nome
ORDER BY maior_faturamento DESC;


--Qual fornecedor gerou maior receita para a empresa?

SELECT f.nome AS fornecedor,
        SUM(ip.valor_unitario * ip.quantidade) AS total_fornecedor
FROM fornecedores AS f
INNER JOIN produtos AS p
ON f.id = p.fornecedor_id
INNER JOIN itens_pedido AS ip
ON p.id = ip.produto_id
GROUP BY f.nome
ORDER BY total_fornecedor DESC
LIMIT 1;


--Quais funcionários processaram mais pedidos?

SELECT f.nome AS nome_funcionario,
        COUNT(status) AS total_processado
FROM funcionarios AS f
INNER JOIN pedidos AS p
ON f.id = p.funcionario_id
GROUP BY f.nome
ORDER BY total_processado DESC;


--Qual funcionário gerou maior faturamento em vendas?

SELECT f.nome AS nome_funcionario,
        SUM(ip.quantidade * ip.valor_unitario) AS total_vendido
FROM funcionarios AS f
INNER JOIN pedidos AS p
ON f.id = p.funcionario_id
INNER JOIN itens_pedido AS ip
ON p.id = ip.pedido_id
GROUP BY f.nome
ORDER BY total_vendido DESC;


--Qual forma de pagamento movimentou mais dinheiro?

SELECT p.forma_pagamento AS forma_utilizada,
        SUM(p.valor) AS total_forma
FROM pagamentos AS p
INNER JOIN pedidos AS pe
ON p.pedido_id = pe.id
WHERE pe.status = 'PAGO'
GROUP BY forma_utilizada
ORDER BY total_forma DESC;


-- Quais transportadoras apresentaram menor tempo médio de entrega?

SELECT e.transportadora AS nome_transportadora,
        AVG(e.data_entrega - e.data_envio) AS tempo_medio_dias
FROM entregas AS e
INNER JOIN pedidos AS p
ON e.pedido_id = p.id
WHERE p.status = 'ENTREGUE'
GROUP BY nome_transportadora
ORDER BY tempo_medio_dias;


-- Quais produtos possuem as melhores avaliações dos clientes?

SELECT p.nome AS nome_produto,
        p.preco AS valor_produto,
         AVG(a.nota) AS nota_media         
FROM produtos AS p
INNER JOIN avaliacoes AS a
ON p.id = a.produto_id 
GROUP BY nome_produto, valor_produto
HAVING AVG(a.nota) > 4
ORDER BY nota_media DESC;


-- Quais cidades geraram maior faturamento para a empresa?

SELECT c.cidade AS ranking_cidades,
        SUM(ip.quantidade * ip.valor_unitario) AS total_cidade
FROM clientes AS c
INNER JOIN pedidos AS p
ON c.id = p.cliente_id
INNER JOIN itens_pedido AS ip
ON p.id = ip.pedido_id
WHERE p.status = 'PAGO'
GROUP BY c.cidade
ORDER BY total_cidade DESC;


-- Existem produtos cadastrados que nunca foram vendidos?

SELECT  p.nome AS nome_produto
FROM produtos AS p
LEFT JOIN itens_pedido AS ip
ON p.id = ip.produto_id
WHERE produto_id IS NULL;








