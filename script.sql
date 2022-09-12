create database gastos_deputados;

create table deputados (
	nudeputadoid int,
	codlegislatura int,
	nucarteiraparlamentar float,
	sguf varchar(2),
	nulegislatura int,
	numano int,
	sgpartido varchar (20),
	txnomeparlamentar varchar(200)
);

COPY deputados(codlegislatura, nucarteiraparlamentar, nudeputadoid, sguf, nulegislatura, numano, sgpartido, txnomeparlamentar)
FROM 'caminho_do_arquivo_deputados.csv' /* Mude o caminho para o arquivo nesta linha */
DELIMITER ','
CSV HEADER;

create table gastos (
	datemissao date,
	idedocumento int,
	indtipodocumento int,
	numparcela int,
	numressarcimento float,
	txtdescricao text,
	vlrdocumento float,
	vlrglosa float,
	vlrliquido float,
	vlrrestituicao float,
	txtfornecedor text,
	nudeputadoid int
);

COPY gastos(datemissao, idedocumento, indtipodocumento, nudeputadoid, numparcela, numressarcimento, txtdescricao, vlrdocumento, vlrglosa, vlrliquido, vlrrestituicao, txtfornecedor)
FROM 'caminho_do_arquivo_gastos.csv' /* Mude o caminho para o arquivo nesta linha */
DELIMITER ','
CSV HEADER;

/* Primary key */
alter table deputados add primary key (nudeputadoid);

/* Foreign Key */
alter table gastos add constraint nudeputadoid foreign key (nudeputadoid) references deputados(nudeputadoid);


/* Gastos com passagens aéreas por ano */
select sum(vlrliquido) as valor, date_part('year', datemissao) as ano from gastos where txtdescricao = 'PASSAGENS AÉREAS' group by ano order by valor desc;

/* Os cinco deputados federais que mais gastam dinheiro público */
select deputados.txnomeparlamentar nome, sum(gastos.vlrliquido) valor_gasto from deputados left join gastos on deputados.nudeputadoid = gastos.nudeputadoid group by nome order by valor_gasto desc limit 5;


/* Estados com maiores gastos com deputados federais */
select deputados.sguf estado, sum(gastos.vlrliquido) valor_gasto from deputados left join gastos on deputados.nudeputadoid = gastos.nudeputadoid group by estado order by valor_gasto desc;


/* Estados com maiores gastos com deputados federais por ano*/
select deputados.sguf estado, sum(gastos.vlrliquido) valor_gasto, date_part('year', gastos.datemissao) ano from deputados left join gastos on deputados.nudeputadoid = gastos.nudeputadoid group by estado, ano order by valor_gasto desc;


/* Partidos que mais gastam dinheiro público */
select deputados.sgpartido partido, sum(gastos.vlrliquido) valor_gasto from deputados left join gastos on deputados.nudeputadoid = gastos.nudeputadoid group by partido order by valor_gasto desc;


/* Partidos com maior número de deputados */
select deputados.sgpartido partido, count(deputados.sgpartido) n_deputados from deputados group by partido order by n_deputados desc;

