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




 

