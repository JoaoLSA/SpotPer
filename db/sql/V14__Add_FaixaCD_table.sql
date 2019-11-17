create table FaixaDisco (
	cod_faixa smallint not null,
	cod_disco smallint not null,
	constraint faixa_disco_pk
	primary key (cod_faixa, cod_disco),
	constraint fd_faixa_fk foreign key (cod_faixa)
	references Faixa on delete cascade,
	constraint fd_cd_fk foreign key (cod_disco)
	references Disco on delete cascade
)