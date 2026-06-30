-- O CRM quer a lista de clientes organizada em ordem alfabética e estado onde reside.
SELECT nome, estado
FROM clientes
ORDER BY nome;

-- O time de pricing quer produtos organizados do mais caro para o mais barato.
SELECT nome, preco
FROM produtos
ORDER BY preco DESC;

-- O time de operações quer pedidos organizados do mais recente para o mais antigo.
SELECT *
FROM pedidos
ORDER BY data_pedido DESC;

-- O suporte precisa analisar clientes organizados por cidade e estado.
SELECT nome, cidade, estado
FROM clientes
ORDER BY cidade, estado;

-- O time de catálogo quer produtos organizados por categoria e depois por preço.
SELECT nome, preco, categoria_id
FROM produtos
ORDER BY categoria_id, preco;

-- O time de qualidade quer avaliações organizadas da maior nota para a menor.
SELECT cliente_id, nota, comentario
from avaliacoes
ORDER BY nota DESC;
-- O RH quer funcionários organizados alfabeticamente por nome.
SELECT nome
FROM funcionarios
ORDER BY nome;

-- O time de operações quer pedidos organizados por pedidos entregues para análise operacional.
SELECT id, data_pedido, status
FROM pedidos
WHERE status = 'ENTREGUE'
ORDER BY status;

-- O time de catálogo quer produtos organizados por nome para revisão geral.
SELECT nome
FROM produtos
ORDER BY nome;

-- O CRM quer clientes organizados por data de cadastro (mais antigos primeiro).
SELECT nome, data_cadastro
FROM clientes
ORDER BY data_cadastro;

-- O financeiro quer pagamentos organizados do maior valor para o menor.
SELECT pedido_id, valor
FROM pagamentos
ORDER BY valor DESC;

-- A logística quer entregas organizadas pela data de envio mais recente.
SELECT data_envio, data_entrega 
FROM entregas
ORDER BY data_envio DESC;