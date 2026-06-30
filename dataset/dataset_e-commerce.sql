-- ecommerce_profissional_v2.sql
-- PostgreSQL - Dataset Brasileiro para Portfólio de Engenharia de Dados

DROP TABLE IF EXISTS avaliacoes CASCADE;
DROP TABLE IF EXISTS entregas CASCADE;
DROP TABLE IF EXISTS pagamentos CASCADE;
DROP TABLE IF EXISTS itens_pedido CASCADE;
DROP TABLE IF EXISTS pedidos CASCADE;
DROP TABLE IF EXISTS produtos CASCADE;
DROP TABLE IF EXISTS fornecedores CASCADE;
DROP TABLE IF EXISTS funcionarios CASCADE;
DROP TABLE IF EXISTS categorias CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;

CREATE TABLE clientes (
 id SERIAL PRIMARY KEY,
 nome VARCHAR(100),
 cidade VARCHAR(80),
 estado VARCHAR(2),
 data_cadastro DATE
);

CREATE TABLE categorias (
 id SERIAL PRIMARY KEY,
 nome VARCHAR(50)
);

CREATE TABLE fornecedores (
 id SERIAL PRIMARY KEY,
 nome VARCHAR(100),
 cidade VARCHAR(80)
);

CREATE TABLE funcionarios (
 id SERIAL PRIMARY KEY,
 nome VARCHAR(100),
 cargo VARCHAR(50)
);

CREATE TABLE produtos (
 id SERIAL PRIMARY KEY,
 nome VARCHAR(100),
 preco NUMERIC(10,2),
 categoria_id INT REFERENCES categorias(id),
 fornecedor_id INT REFERENCES fornecedores(id)
);

CREATE TABLE pedidos (
 id SERIAL PRIMARY KEY,
 cliente_id INT REFERENCES clientes(id),
 funcionario_id INT REFERENCES funcionarios(id),
 data_pedido DATE,
 status VARCHAR(20)
);

CREATE TABLE itens_pedido (
 id SERIAL PRIMARY KEY,
 pedido_id INT REFERENCES pedidos(id),
 produto_id INT REFERENCES produtos(id),
 quantidade INT,
 valor_unitario NUMERIC(10,2),
 UNIQUE(pedido_id,produto_id)
);

CREATE TABLE pagamentos (
 id SERIAL PRIMARY KEY,
 pedido_id INT REFERENCES pedidos(id),
 forma_pagamento VARCHAR(30),
 valor NUMERIC(10,2)
);

CREATE TABLE entregas (
 id SERIAL PRIMARY KEY,
 pedido_id INT REFERENCES pedidos(id),
 transportadora VARCHAR(50),
 data_envio DATE,
 data_entrega DATE
);

CREATE TABLE avaliacoes (
 id SERIAL PRIMARY KEY,
 cliente_id INT REFERENCES clientes(id),
 produto_id INT REFERENCES produtos(id),
 nota INT,
 comentario TEXT
);

INSERT INTO categorias(nome) VALUES
('Eletrônicos'),('Informática'),('Celulares'),
('Moda'),('Beleza'),('Casa'),
('Livros'),('Esportes'),('Games'),('Brinquedos');

INSERT INTO fornecedores(nome,cidade)
SELECT
empresa||' '||g,
cidade
FROM (
SELECT unnest(ARRAY[
'Tech Brasil','Mega Distribuição','Alpha Tech','Nexus Supply',
'Digital Center','Atacado Prime','Brasil Componentes',
'Sul Importadora','Smart Commerce','Global Varejo']) empresa,
unnest(ARRAY[
'São Paulo','Campinas','Rio de Janeiro','Belo Horizonte',
'Curitiba','Porto Alegre','Recife','Salvador',
'Goiânia','Manaus']) cidade
) t
CROSS JOIN generate_series(1,5) g;

INSERT INTO funcionarios(nome,cargo)
SELECT DISTINCT
nomes[(random()*39)::int+1]||' '||
sobrenomes[(random()*39)::int+1],
cargos[(random()*3)::int+1]
FROM generate_series(1,200),
(
SELECT
ARRAY['Carlos','Ana','Bruno','Mariana','Diego','Juliana','Lucas','Beatriz','Rodrigo','Fernanda','Gabriel','Amanda','Rafael','Camila','Thiago','Patricia','Leonardo','Aline','Vinicius','Larissa','João','Marcos','Eduardo','Carolina','Felipe','Vanessa','Ricardo','Isabela','Gustavo','Bianca','Henrique','Murilo','Samuel','Daniel','Paulo','Renato','Cesar','Otavio','Livia','Natalia'] nomes,
ARRAY['Silva','Santos','Oliveira','Souza','Rodrigues','Ferreira','Alves','Pereira','Lima','Gomes','Ribeiro','Carvalho','Almeida','Costa','Rocha','Mendes','Freitas','Barbosa','Pinto','Dias','Batista','Moreira','Teixeira','Martins','Araujo','Correia','Nascimento','Rezende','Vieira','Moura','Castro','Pires','Cardoso','Campos','Cunha','Machado','Monteiro','Nogueira','Leite','Moraes'] sobrenomes,
ARRAY['Gerente','Vendedor Senior','Analista','Vendedor Pleno'] cargos
)d
LIMIT 30;

INSERT INTO clientes(nome,cidade,estado,data_cadastro)
SELECT
nomes[(random()*49)::int+1]||' '||sobrenomes[(random()*49)::int+1],
cidades[(random()*14)::int+1],
estados[(random()*4)::int+1],
CURRENT_DATE-((random()*730)::int)
FROM generate_series(1,1000),
(
SELECT
ARRAY['Gabriel','Lucas','Matheus','Pedro','Guilherme','Arthur','Gustavo','Felipe','João','Marcos','Maria','Ana','Julia','Yasmin','Beatriz','Amanda','Larissa','Bruna','Camila','Leticia','Rodrigo','Thiago','Rafael','Diego','Leonardo','Aline','Jessica','Fernanda','Caroline','Barbara','Vinicius','Henrique','Eduardo','Paulo','Renato','Daniel','Ricardo','Patricia','Carla','Vanessa','Bianca','Isabela','Livia','Natalia','Helena','Murilo','Samuel','Bruno','Cesar','Otavio'] nomes,
ARRAY['Silva','Santos','Oliveira','Souza','Rodrigues','Ferreira','Alves','Pereira','Lima','Gomes','Ribeiro','Carvalho','Almeida','Costa','Rocha','Mendes','Freitas','Barbosa','Pinto','Dias','Batista','Moreira','Teixeira','Martins','Araujo','Correia','Nascimento','Rezende','Vieira','Moura','Castro','Pires','Cardoso','Campos','Cunha','Farias','Machado','Monteiro','Nogueira','Sales','Andrade','Azevedo','Borges','Leite','Moraes','Peixoto','Queiroz','Tavares','Vasconcelos','Xavier'] sobrenomes,
ARRAY['Sorocaba','São Paulo','Campinas','Rio de Janeiro','Niterói','Belo Horizonte','Uberlândia','Curitiba','Londrina','Joinville','Florianópolis','Porto Alegre','Salvador','Recife','Goiânia'] cidades,
ARRAY['SP','RJ','MG','PR','SC'] estados
)d;

INSERT INTO produtos(nome,preco,categoria_id,fornecedor_id)
SELECT
'Produto '||g||' - '||
(ARRAY['Premium','Plus','Pro','Max','Ultra'])[floor(random()*5)+1],
round((50+random()*5000)::numeric,2),
((g-1)%10)+1,
((g-1)%50)+1
FROM generate_series(1,300) g;

INSERT INTO pedidos(cliente_id,funcionario_id,data_pedido,status)
SELECT
(random()*999)::int+1,
(random()*29)::int+1,
CURRENT_DATE-((random()*365)::int),
(ARRAY['PENDENTE','FALHADO','PAGO','ENVIADO','ENTREGUE'])[floor(random()*5)+1]
FROM generate_series(1,5000);

INSERT INTO itens_pedido(pedido_id,produto_id,quantidade,valor_unitario)
SELECT DISTINCT ON (pedido_id,produto_id)
pedido_id,
produto_id,
(random()*2)::int+1,
p.preco
FROM (
SELECT
(random()*4999)::int+1 pedido_id,
(random()*299)::int+1 produto_id
FROM generate_series(1,40000)
)x
JOIN produtos p ON p.id=x.produto_id
LIMIT 20000;

INSERT INTO pagamentos(pedido_id,forma_pagamento,valor)
SELECT
p.id,
(ARRAY['PIX','CARTAO_CREDITO','BOLETO'])[floor(random()*3)+1],
COALESCE(SUM(i.quantidade*i.valor_unitario),0)
FROM pedidos p
LEFT JOIN itens_pedido i ON i.pedido_id=p.id
GROUP BY p.id;

INSERT INTO entregas(pedido_id,transportadora,data_envio,data_entrega)
SELECT
id,
(ARRAY['Correios','Jadlog','Loggi','Azul Cargo'])[floor(random()*4)+1],
data_pedido+((random()*2)::int)+1,
data_pedido+((random()*7)::int)+4
FROM pedidos
WHERE status IN ('ENVIADO','ENTREGUE');

INSERT INTO avaliacoes(cliente_id,produto_id,nota,comentario)
SELECT
(random()*999)::int+1,
(random()*299)::int+1,
(random()*2)::int+3,
(ARRAY[
'Excelente produto.','Muito satisfeito.',
'Entrega rápida.','Ótimo custo-benefício.',
'Produto original.','Superou expectativas.',
'Boa qualidade.','Recomendo.',
'Atendeu ao esperado.','Voltarei a comprar.'
])[floor(random()*10)+1]
FROM generate_series(1,5000);

CREATE INDEX idx_pedidos_cliente ON pedidos(cliente_id);
CREATE INDEX idx_itens_produto ON itens_pedido(produto_id);
CREATE INDEX idx_pagamentos_pedido ON pagamentos(pedido_id);
