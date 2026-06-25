-- ecommerce_profissional.sql
-- PostgreSQL

DROP TABLE IF EXISTS avaliacoes CASCADE;
DROP TABLE IF EXISTS entregas CASCADE;
DROP TABLE IF EXISTS pagamentos CASCADE;
DROP TABLE IF EXISTS itens_pedido CASCADE;
DROP TABLE IF EXISTS pedidos CASCADE;
DROP TABLE IF EXISTS produtos CASCADE;
DROP TABLE IF EXISTS fornecedores CASCADE;
DROP TABLE IF EXISTS funcionários CASCADE;
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
    valor_unitario NUMERIC(10,2)
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

---
--- POPULANDO O BANCO DE DADOS COM VALORES FICTÍCIOS REALISTAS
---

-- 1. Categorias do E-commerce
INSERT INTO categorias(nome) VALUES
('Eletrônicos'), ('Informática'), ('Celulares e Telefonia'), 
('Moda e Acessórios'), ('Beleza e Saúde'), ('Casa e Decoração'), 
('Livros e Papelaria'), ('Esporte e Lazer'), ('Games'), ('Brinquedos');

-- 2. Fornecedores Realistas (30 registros)
INSERT INTO fornecedores(nome, cidade)
SELECT 
    (ARRAY[
        'TechDistribuidores Ltda', 'Global Logística e Suprimentos', 'Alpha Componentes Eletrônicos', 
        'MegaAtacado Brasil', 'LogiTech Importações e Comércio', 'Moda Fashion Atacadista', 
        'Livros & Cia Distribuidora Nacional', 'Nexus Eletro S.A.', 'Sul Brasil Esportes', 'GamerZone Distribuidora'
    ])[((g-1) % 10) + 1] || CASE WHEN g > 10 THEN ' filial ' || (g/10)::int ELSE '' END,
    (ARRAY['São Paulo', 'Campinas', 'Rio de Janeiro', 'Belo Horizonte', 'Curitiba', 'Porto Alegre', 'Salvador', 'Recife', 'Goiânia', 'Manaus'])[((g-1) % 10) + 1]
FROM generate_series(1,30) g;

-- 3. Funcionários Realistas (20 registros)
INSERT INTO funcionarios(nome, cargo)
SELECT 
    (ARRAY['Carlos', 'Ana', 'Bruno', 'Mariana', 'Diego', 'Juliana', 'Lucas', 'Beatriz', 'Rodrigo', 'Fernanda'])[((g-1) % 10) + 1] || ' ' || 
    (ARRAY['Silva', 'Santos', 'Oliveira', 'Souza', 'Rodrigues', 'Ferreira', 'Alves', 'Pereira', 'Lima', 'Gomes'])[((g-1) % 10) + 1],
    CASE WHEN g % 4 = 0 THEN 'Gerente de Operações'
         WHEN g % 4 = 1 THEN 'Vendedor Sênior'
         WHEN g % 4 = 2 THEN 'Analista de Atendimento'
         ELSE 'Vendedor Pleno' END
FROM generate_series(1,20) g;

-- 4. Clientes Realistas sem números no nome (500 registros)
INSERT INTO clientes(nome, cidade, estado, data_cadastro)
SELECT
    (ARRAY[
        'Gabriel', 'Lucas', 'Matheus', 'Pedro', 'Guilherme', 'Arthur', 'Gustavo', 'Felipe', 'João', 'Marcos',
        'Maria', 'Ana', 'Julia', 'Yasmin', 'Beatriz', 'Amanda', 'Larissa', 'Bruna', 'Camila', 'Letícia',
        'Rodrigo', 'Thiago', 'Rafael', 'Diego', 'Leonardo', 'Aline', 'Jessica', 'Fernanda', 'Caroline', 'Barbara'
    ])[((g-1) % 30) + 1] || ' ' || 
    (ARRAY[
        'Silva', 'Santos', 'Oliveira', 'Souza', 'Rodrigues', 'Ferreira', 'Alves', 'Pereira', 'Lima', 'Gomes',
        'Ribeiro', 'Carvalho', 'Almeida', 'Costa', 'Rocha', 'Mendes', 'Freitas', 'Barbosa', 'Pinto', 'Dias'
    ])[((g-1) % 20) + 1],
    (ARRAY['Sorocaba', 'São Paulo', 'Niterói', 'Rio de Janeiro', 'Uberlândia', 'Belo Horizonte', 'Londrina', 'Curitiba', 'Joinville', 'Florianópolis'])[((g-1) % 10) + 1],
    CASE (g % 5)
        WHEN 0 THEN 'SP'
        WHEN 1 THEN 'RJ'
        WHEN 2 THEN 'MG'
        WHEN 3 THEN 'PR'
        ELSE 'SC'
    END,
    CURRENT_DATE - ((random()*730)::int) -- Cadastros nos últimos 2 anos
FROM generate_series(1,500) g;

-- 5. Produtos de E-commerce com nomes comerciais limpos (100 registros)
INSERT INTO produtos(nome, preco, categoria_id, fornecedor_id)
SELECT
    (ARRAY[
        'Smartphone Galaxy S23 Ultra 256GB', 'Notebook UltraFast Intel i7 16GB', 'Smart TV LED 55 4K Crystal', 'Fone de Ouvido Bluetooth AirPro',
        'Camiseta Algodão Egípcio Premium', 'Calça Jeans Slim Fit Casual', 'Tênis Running Confort Max', 'Mochila Impermeável Urbana Office',
        'Livro - O Mistério do Código Limpo', 'Cadeira Gamer Ergonômica Reclinável', 'Teclado Mecânico RGB Switch Blue', 'Mouse Gamer Sem Fio 16000 DPI',
        'Monitor Gamer 24 144Hz Full HD', 'Carregador Portátil PowerBank 20000mAh', 'Cafeteira Expresso Automática 19 Bar', 'Aspirador de Pó Robô Smart Wi-Fi',
        'Perfume Elegance Male 100ml', 'Kit Whey Protein Isolado + Coqueteleira', 'Jogo de Panelas Antiaderente 5 Peças', 'Console PlayStation 5 825GB'
    ])[((g-1) % 20) + 1],
    round((40 + random()*4500)::numeric, 2),
    ((g-1) % 10) + 1,
    ((g-1) % 30) + 1
FROM generate_series(1,100) g;

-- 6. Pedidos Realistas (3000 registros)
INSERT INTO pedidos(cliente_id, funcionario_id, data_pedido, status)
SELECT
    ((random()*499)::int)+1,
    ((random()*19)::int)+1,
    CURRENT_DATE - ((random()*365)::int), -- Pedidos no último ano
    (ARRAY['PENDENTE', 'FALHADO', 'PAGO', 'ENVIADO', 'ENTREGUE'])[floor(random()*5)+1]
FROM generate_series(1,3000);

-- 7. Itens dos Pedidos baseados no preço do produto (10000 registros)
INSERT INTO itens_pedido(pedido_id, produto_id, quantidade, valor_unitario)
SELECT
    p.pedido_id,
    p.produto_id,
    ((random()*2)::int)+1, -- Quantidades mais comuns de compra (1 a 3 itens)
    prod.preco
FROM (
    SELECT 
        ((random()*2999)::int)+1 as pedido_id,
        ((random()*99)::int)+1 as produto_id
    FROM generate_series(1,10000)
) p
JOIN produtos prod ON prod.id = p.produto_id;

-- 8. Pagamentos Vinculados aos valores do pedido de forma dinâmica
INSERT INTO pagamentos(pedido_id, forma_pagamento, valor)
SELECT
    p.id,
    (ARRAY['PIX', 'CARTAO_CREDITO', 'BOLETO_BANCARIO'])[floor(random()*3)+1],
    round((30 + random()*5000)::numeric,2)
FROM pedidos p;

-- 9. Entregas Fictícias baseadas na coerência de datas do pedido
INSERT INTO entregas(pedido_id, transportadora, data_envio, data_entrega)
SELECT
    p.id,
    (ARRAY['Correios (SEDEX)', 'Loggi Express', 'Jadlog Transportes', 'DHL Supply Chain'])[floor(random()*4)+1],
    p.data_pedido + ((random()*2)::int) + 1, -- Envio em até 3 dias úteis
    p.data_pedido + ((random()*5)::int) + 4  -- Entrega finalizada de 4 a 9 dias após o pedido
FROM pedidos p
WHERE p.status IN ('ENVIADO', 'ENTREGUE');

-- 10. Avaliações com Feedbacks Realistas (2000 registros)
INSERT INTO avaliacoes(cliente_id, produto_id, nota, comentario)
SELECT
    ((random()*499)::int)+1,
    ((random()*99)::int)+1,
    ((random()*2)::int)+4, -- Tendência a notas mais realistas em e-commerce (3 a 5 estrelas)
    (ARRAY[
        'Excelente produto, superou minhas expectativas!', 
        'Entrega rápida e produto de ótima qualidade.', 
        'O produto é bom, mas a embalagem veio um pouco amassada.', 
        'Muito satisfeito com a compra, recomendo.', 
        'Custo-benefício excelente. Recomendo a todos!',
        'Chegou antes do prazo e funciona perfeitamente.'
    ])[floor(random()*6)+1]
FROM generate_series(1,2000);

-- Índices para otimização de consultas
CREATE INDEX idx_pedidos_cliente ON pedidos(cliente_id);
CREATE INDEX idx_itens_produto ON itens_pedido(produto_id);
CREATE INDEX idx_pagamentos_pedido ON pagamentos(pedido_id);