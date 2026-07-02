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