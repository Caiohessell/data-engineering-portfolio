/*O objetivo dessa sessão é praticar o uso de subqueries em SQL utilizando o banco de dados e-commerce para responder 
algumas perguntas de negócio*/

--Quais clientes gastaram mais do que a média de todos os clientes?

SELECT nome_cliente, total_cliente
FROM (
        SELECT c.nome AS nome_cliente,
        SUM(ip.quantidade * ip.valor_unitario) AS total_cliente
        FROM clientes AS c
        INNER JOIN pedidos AS p
                ON c.id = p.cliente_id
        INNER JOIN itens_pedido AS ip
                ON p.id = ip.pedido_id
        WHERE p.status LIKE '%PAGO%'
        GROUP BY c.id, c.nome
) AS total_gasto
WHERE total_cliente > (
        SELECT AVG(total_cliente)
        FROM (
                SELECT SUM(ip.quantidade * ip.valor_unitario) AS total_cliente
                FROM clientes AS c
                INNER JOIN pedidos AS p
                        ON c.id = p.cliente_id
                INNER JOIN itens_pedido AS ip
                        ON p.id = ip.pedido_id
                WHERE p.status LIKE '%PAGO%'
                GROUP BY c.id
        ) AS media_clientes 
); 

-- Existem produtos que nunca foram vendidos?

SELECT id, nome 
FROM produtos AS p 
WHERE p.id NOT IN (SELECT produto_id 
                        FROM itens_pedido);


-- Quais fornecedores possuem pelo menos um produto que nunca foi vendido?

SELECT id, nome
FROM fornecedores AS f
WHERE f.id IN (
                SELECT p.fornecedor_id
                        FROM produtos AS p
                WHERE p.id NOT IN (
                SELECT produto_id
                        FROM itens_pedido
    )
);


-- Quais clientes realizaram pedidos cujo valor foi superior ao maior pedido da cidade de Sorocaba?

SELECT ip.pedido_id AS pedido, c.nome AS nome, SUM(ip.quantidade * ip.valor_unitario) total_geral
FROM itens_pedido AS ip
INNER JOIN pedidos AS p
        ON ip.pedido_id = p.id
INNER JOIN clientes AS c
        ON c.id = p.cliente_id
WHERE p.status = 'PAGO'
GROUP BY c.id, ip.pedido_id
HAVING SUM(ip.quantidade * ip.valor_unitario) > (
                                                SELECT SUM(ip.quantidade * ip.valor_unitario) AS maior
                                                FROM itens_pedido AS ip
                                                INNER JOIN pedidos AS p
                                                        ON p.id = ip. pedido_id
                                                INNER JOIN clientes AS c
                                                        ON c.id = p.cliente_id
                                                WHERE c.cidade = 'Sorocaba' AND P.status = 'PAGO'
                                                GROUP BY ip.pedido_id
                                                ORDER BY maior DESC
                                                LIMIT 1
                                                )
ORDER BY total_geral DESC;


-- Quais produtos possuem preço acima da média da própria categoria?

SELECT p.nome AS produto, p.preco AS preco, ct.nome AS categoria
FROM produtos AS p
INNER JOIN categorias AS ct
ON ct.id = p.categoria_id
GROUP BY p.nome, p.preco, p.categoria_id, ct.nome
HAVING p.preco > (
                 SELECT AVG(preco)
                 FROM produtos AS p2
                 INNER JOIN categorias AS ct2
                        ON ct2.id = p2.categoria_id
                 WHERE p2.categoria_id = p.categoria_id
)
ORDER BY p.preco DESC;


--Quais funcionários venderam pelo menos um pedido acima da média dos pedidos?

SELECT DISTINCT(fn.nome) AS nome, fn.cargo AS cargo
FROM funcionarios AS fn
INNER JOIN pedidos AS p
    ON fn.id = p.funcionario_id
INNER JOIN (
        SELECT ip.pedido_id, SUM(ip.quantidade * ip.valor_unitario) AS total_pedido
        FROM itens_pedido AS ip
        GROUP BY ip.pedido_id
) AS total
    ON p.id = total.pedido_id
WHERE total.total_pedido > (
        SELECT AVG(total_pedido)
        FROM (
                SELECT ip2.pedido_id, SUM(ip2.quantidade * ip2.valor_unitario) AS total_pedido
                FROM itens_pedido AS ip2
                GROUP BY ip2.pedido_id
        ) AS media_pedidos
);
 
-- Quais clientes nunca avaliaram nenhum produto?

SELECT c.nome AS cliente
FROM clientes AS c
WHERE c.id NOT IN (
        SELECT cliente_id
        FROM avaliacoes
);

-- Quais produtos possuem avaliação inferior à média geral das avaliações?

SELECT p.nome, ROUND(AVG(av.nota), 2) AS media
FROM produtos AS p
INNER JOIN avaliacoes AS av
        ON p.id = av.produto_id
GROUP BY p.nome
HAVING (SELECT AVG(nota)
        FROM avaliacoes
) > AVG(av.nota)


-- Quais categorias possuem mais produtos do que a média de produtos por categoria?

SELECT ct.nome, COUNT(p.nome) AS contagem_total
FROM produtos AS p
INNER JOIN categorias AS ct
        ON ct.id = p.categoria_id
GROUP BY ct.nome
HAVING COUNT(p.nome) > (
        SELECT AVG(tbl_contagem.contagem)
        FROM (
                SELECT COUNT(*) AS contagem
                FROM produtos
                GROUP BY produtos.categoria_id
        ) AS tbl_contagem
)
ORDER BY contagem_total DESC;


-- Quais pedidos possuem valor superior ao valor médio dos pedidos pagos via PIX?

SELECT p.id AS pedido, SUM(ip.quantidade * ip.valor_unitario) AS total_pedido
FROM pedidos AS p
INNER JOIN itens_pedido AS ip
        ON p.id = ip.pedido_id
GROUP BY p.id
HAVING SUM(ip.quantidade * ip.valor_unitario) > (
        SELECT AVG(tbl_soma.soma_pedido)
        FROM (
                SELECT SUM(ip1.quantidade * ip1.valor_unitario) AS soma_pedido
                FROM itens_pedido AS ip1
                INNER JOIN pagamentos AS pg1
                        ON ip1.pedido_id = pg1.pedido_id
                WHERE pg1.forma_pagamento = 'PIX'
                GROUP BY ip1.pedido_id
        ) AS tbl_soma
)
ORDER BY total_pedido DESC;


-- Existem clientes que compraram produtos de todas as categorias?

SELECT cl.nome AS cliente, COUNT(DISTINCT(ct.id)) AS contagem
FROM clientes AS cl
INNER JOIN pedidos AS p
        ON cl.id = p.cliente_id
INNER JOIN itens_pedido AS ip
        ON ip.pedido_id = p.id
INNER JOIN produtos AS pr
        ON pr.id = ip.produto_id
INNER JOIN categorias AS ct
        ON ct.id = pr.categoria_id
GROUP BY cl.nome
HAVING COUNT(DISTINCT(ct.id)) = (
        SELECT COUNT(id)
        FROM categorias
)


-- Quais cidades possuem clientes cujo gasto total é maior que o gasto médio das demais cidades?

SELECT cl.cidade AS cidade
FROM clientes AS cl
INNER JOIN pedidos AS pd
ON pd.cliente_id = cl.id
INNER JOIN itens_pedido AS ip
ON ip.pedido_id = pd.id
GROUP BY cl.cidade
HAVING SUM(ip.quantidade * ip.valor_unitario) > (
        SELECT AVG(tbl_soma.soma_pedido)
        FROM (
                SELECT SUM(ip1.quantidade * ip1.valor_unitario) AS soma_pedido
                FROM itens_pedido AS ip1
                INNER JOIN pedidos AS pd1
                        ON pd1.id = ip1.pedido_id
                INNER JOIN clientes AS cl1
                        ON cl1.id = pd1.cliente_id
                GROUP BY cl1.cidade                                
        ) AS tbl_soma
)
