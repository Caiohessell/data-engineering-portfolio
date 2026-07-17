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

SELECT 
    fn.nome, fn.cargo
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

 


