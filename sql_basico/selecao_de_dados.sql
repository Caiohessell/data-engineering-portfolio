/*Neste arquivo aplicarei os conceitos básicos de SQL no que diz respeito a seleção de dados, abaixo criarei querys buscando responder algumas 
perguntas de negócio*/

-- Você precisa de uma visão geral dos clientes cadastrados no sistema com seus dados de nome, cidade, estado.
SELECT nome, cidade, estado
FROM clientes;

-- O time de produto quer uma lista básica de todos os produtos disponíveis com nome e preço.
SELECT nome, preco
FROM produtos;

-- O time de operações precisa visualizar todos os pedidos registrados com seu status e data de criação.
SELECT status, data_pedido
FROM pedidos; 

-- O financeiro quer um relatório simples com os nomes de todos os fornecedores ativos.
SELECT nome 
FROM fornecedores;

-- Para análise de mercado, liste todas as cidades diferentes onde existem clientes cadastrados.
SELECT DISTINCT(cidade)
FROM clientes;

-- O time financeiro quer entender quais formas de pagamento já foram utilizadas na plataforma.
SELECT DISTINCT(forma_pagamento) AS formas_utilizadas
FROM pagamentos;

-- O RH precisa de uma lista dos funcionários com seus respectivos cargos.
SELECT nome, cargo
FROM funcionarios;

-- O time de catálogo precisa revisar os produtos com seus nomes e categorias associadas.
SELECT nome, categoria_id
FROM produtos;

--Para auditoria, liste apenas os IDs de todos os pedidos realizados.
SELECT id AS id_pedidos
FROM pedidos;

-- O marketing quer identificar desde quando os clientes estão na base (data de cadastro).
SELECT nome, data_cadastro 
FROM clientes;

-- O time comercial quer revisar rapidamente os produtos com seus respectivos preços.
SELECT nome, preco 
FROM produtos;

-- A logística precisa de uma lista de todas as transportadoras já utilizadas nas entregas.
SELECT DISTINCT(transportadora) 
FROM entregas;