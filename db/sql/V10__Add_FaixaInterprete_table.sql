create table FaixaInterprete (
	cod_faixa smallint not null,
	cod_interprete smallint not null,
	constraint faixa_interprete_pk 
	primary key (cod_faixa, cod_interprete),
	constraint fi_faixa_fk foreign key
	(cod_faixa) references Faixa on delete cascade,
	constraint fi_interprete_fk foreign key
	(cod_interprete) references Interprete on delete cascade
)