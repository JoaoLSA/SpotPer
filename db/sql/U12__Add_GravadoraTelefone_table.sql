create table GravadoraTelefone (
	cod_gravadora smallint not null,
	cod_telefone smallint not null,
	constraint gravadora_telefone_fk
	primary key (cod_gravadora, cod_telefone),
	constraint gf_gravadora_fk foreign key (cod_gravadora)
	references Gravadora on delete cascade,
	constraint gf_telefone_fk foreign key (cod_telefone)
	references Telefone on delete cascade
)