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



INSERT INTO produtos(nome, preco, categoria_id, fornecedor_id)
SELECT
    p.produto,
    round(
        CASE p.categoria_id
            WHEN 1 THEN 300 + random()*7000      -- Eletrônicos
            WHEN 2 THEN 200 + random()*12000     -- Informática
            WHEN 3 THEN 500 + random()*8000      -- Celulares
            WHEN 4 THEN 50 + random()*500        -- Moda
            WHEN 5 THEN 20 + random()*400        -- Beleza
            WHEN 6 THEN 80 + random()*3000       -- Casa
            WHEN 7 THEN 20 + random()*200        -- Livros
            WHEN 8 THEN 50 + random()*2000       -- Esportes
            WHEN 9 THEN 100 + random()*5000      -- Games
            ELSE 30 + random()*500               -- Brinquedos
        END::numeric,
        2
    ),
    p.categoria_id,
    ((row_number() OVER()) % 50) + 1
FROM (
VALUES

-- ELETRÔNICOS
('Smart TV Samsung Crystal UHD 50"',1),
('Smart TV LG OLED C4 55"',1),
('Soundbar JBL Cinema',1),
('Caixa de Som JBL Flip 6',1),
('Alexa Echo Dot 5ª Geração',1),
('Google Nest Mini',1),
('Projetor Full HD Epson',1),
('Home Theater Sony',1),
('Smartwatch Galaxy Watch 7',1),
('Apple Watch Series 10',1),
('Drone DJI Mini 4K',1),
('GoPro Hero 13',1),
('Câmera Canon EOS R50',1),
('Câmera Sony Alpha A6400',1),
('Fone JBL Tune 720BT',1),
('Headphone Sony WH-1000XM5',1),
('AirPods Pro 2',1),
('Kindle Paperwhite',1),
('Tablet Samsung Galaxy Tab S9',1),
('iPad Air M3',1),

-- INFORMÁTICA
('Notebook Dell Inspiron i7',2),
('Notebook Lenovo Legion 5',2),
('Notebook Acer Nitro V15',2),
('Notebook ASUS Vivobook',2),
('MacBook Air M3',2),
('Monitor LG Ultrawide 29"',2),
('Monitor Samsung Odyssey G5',2),
('Monitor AOC Hero 24"',2),
('Teclado Mecânico Redragon Kumara',2),
('Teclado Logitech MX Keys',2),
('Mouse Logitech G502',2),
('Mouse Logitech MX Master 3S',2),
('Mouse Razer DeathAdder',2),
('SSD Kingston NV2 1TB',2),
('SSD Samsung 990 Pro 2TB',2),
('HD Externo Seagate 2TB',2),
('Memória RAM Corsair 16GB',2),
('Processador Ryzen 7 7800X',2),
('Processador Intel i7 14700K',2),
('Placa de Vídeo RTX 4070',2),
('Placa de Vídeo RX 7800 XT',2),
('Fonte Corsair 750W',2),
('Gabinete Gamer NZXT',2),
('Webcam Logitech C920',2),
('Microfone HyperX QuadCast',2),

-- CELULARES
('Samsung Galaxy S24 Ultra 256GB',3),
('Samsung Galaxy S24 FE',3),
('iPhone 16 Pro 256GB',3),
('iPhone 16 128GB',3),
('Motorola Edge 50 Pro',3),
('Motorola G85',3),
('Xiaomi Redmi Note 14',3),
('Xiaomi Poco X7',3),
('Realme GT 6',3),
('ASUS ROG Phone 8',3),

-- MODA
('Camiseta Básica Premium',4),
('Camiseta Polo Masculina',4),
('Calça Jeans Slim',4),
('Calça Jeans Feminina',4),
('Tênis Nike Revolution 7',4),
('Tênis Adidas Runfalcon',4),
('Tênis Olympikus Corre 4',4),
('Tênis Asics Gel Nimbus',4),
('Jaqueta Corta Vento',4),
('Moletom Unissex',4),
('Bolsa Feminina Couro',4),
('Mochila Executiva',4),
('Mochila Gamer',4),
('Relógio Masculino Casual',4),
('Relógio Feminino Elegance',4),

-- BELEZA
('Perfume Masculino 100ml',5),
('Perfume Feminino 100ml',5),
('Kit Skincare Facial',5),
('Shampoo Profissional',5),
('Condicionador Profissional',5),
('Creme Hidratante',5),
('Protetor Solar FPS 70',5),
('Kit Maquiagem Premium',5),
('Secador de Cabelo',5),
('Chapinha Profissional',5),

-- CASA
('Geladeira Frost Free',6),
('Microondas Panasonic',6),
('Air Fryer Philips Walita',6),
('Cafeteira Nespresso',6),
('Cafeteira Dolce Gusto',6),
('Aspirador Robô Smart',6),
('Purificador de Água',6),
('Ventilador Arno',6),
('Ar Condicionado Inverter',6),
('Máquina de Lavar 12kg',6),
('Cooktop 5 Bocas',6),
('Forno Elétrico',6),
('Jogo de Panelas',6),
('Conjunto de Facas',6),
('Sofá Retrátil',6),

-- LIVROS
('Clean Code',7),
('Engenharia de Dados',7),
('Python para Análise de Dados',7),
('SQL para Cientistas de Dados',7),
('Arquitetura Limpa',7),
('Data Warehouse Toolkit',7),
('Storytelling com Dados',7),
('Entendendo Algoritmos',7),
('Domain Driven Design',7),
('Fundamentos de Banco de Dados',7),

-- ESPORTES
('Bicicleta Mountain Bike',8),
('Esteira Ergométrica',8),
('Halter Emborrachado 10kg',8),
('Bola Oficial de Futebol',8),
('Bola Oficial de Vôlei',8),
('Luva de Academia',8),
('Kit Faixa Elástica',8),
('Corda de Pular',8),
('Colchonete Fitness',8),
('Whey Protein 900g',8),
('Creatina Monohidratada',8),

-- GAMES
('PlayStation 5 Slim',9),
('Xbox Series X',9),
('Nintendo Switch OLED',9),
('Controle DualSense',9),
('Controle Xbox',9),
('Headset Gamer HyperX',9),
('Cadeira Gamer ThunderX3',9),
('Mesa Gamer',9),
('Volante Logitech G29',9),
('Placa de Captura',9),

-- BRINQUEDOS
('LEGO Star Wars',10),
('LEGO City',10),
('Boneca Barbie',10),
('Carrinho Hot Wheels',10),
('Quebra-Cabeça 1000 Peças',10),
('Jogo de Tabuleiro',10),
('Uno',10),
('Banco Imobiliário',10),
('Pelúcia Ursinho',10),
('Pista Hot Wheels',10)

) AS p(produto, categoria_id);

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

INSERT INTO avaliacoes(cliente_id, produto_id, nota, comentario)
SELECT
    (random()*999)::int+1,
    (random()*119)::int+1, -- Ajustado de 299 para 119 (Gera IDs de 1 a 120)
    (random()*2)::int+3,
    (ARRAY[
        'Excelente produto.', 'Muito satisfeito.',
        'Entrega rápida.', 'Ótimo custo-benefício.',
        'Produto original.', 'Superou expectativas.',
        'Boa qualidade.', 'Recomendo.',
        'Atendeu ao esperado.', 'Voltarei a comprar.'
    ])[floor(random()*10)+1]
FROM generate_series(1, 5000);

CREATE INDEX idx_pedidos_cliente ON pedidos(cliente_id);
CREATE INDEX idx_itens_produto ON itens_pedido(produto_id);
CREATE INDEX idx_pagamentos_pedido ON pagamentos(pedido_id);
