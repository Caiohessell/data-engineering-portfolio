/*Neste arquivo apliquei conceitos de filtragem buscando responder algumas perguntas de negócio*/


-- O time comercial quer todos os clientes que estão no estado de São Paulo (SP).
SELECT nome, estado 
FROM clientes
WHERE estado = 'SP'

--O marketing quer identificar produtos com preço acima de 1000 para campanhas premium.
SELECT nome, preco
FROM produtos
WHERE preco > 1000;

-- O suporte precisa analisar apenas pedidos que foram entregues.
SELECT *
FROM pedidos
WHERE status = 'ENTREGUE';

-- A equipe regional quer clientes que moram na cidade de São Paulo.
SELECT nome, cidade
FROM clientes
WHERE cidade = 'São Paulo';

-- O time de pricing quer analisar produtos com preço entre 500 e 2000.
SELECT nome, preco
FROM produtos
WHERE preco BETWEEN 500 AND 2000;

-- A logística quer pedidos feitos nos últimos 30 dias para análise de entrega recente.
SELECT data_pedido, status
FROM pedidos
WHERE data_pedido BETWEEN '2026-05-27' AND '2026-06-27';

-- O marketing quer clientes dos estados SP ou RJ para campanhas regionais.
SELECT *
FROM clientes
WHERE estado = 'SP' OR estado = 'RJ';

-- O time de catálogo quer produtos das categorias 1 ou 2 para revisão de portfólio.
SELECT nome, preco, categoria_id
FROM produtos
WHERE categoria_id = '1' OR categoria_id = '2';

-- O time de qualidade quer avaliar apenas produtos com nota máxima (5 estrelas).
SELECT produto_id, comentario, nota
FROM avaliacoes
WHERE nota = '5';

-- O time de busca quer produtos que contenham “Smart” no nome para análise de demanda.
SELECT nome, categoria_id
FROM produtos
WHERE nome LIKE '%Smart%';

-- O time de operações quer excluir pedidos que falharam.
SELECT id, data_pedido, status 
FROM pedidos
WHERE status = 'FALHADO';

-- O CRM quer clientes que foram cadastrados nos últimos 365 dias para ativação.
SELECT nome, data_cadastro
FROM clientes
WHERE data_cadastro BETWEEN '2025-06-27' AND '2026-06-27';