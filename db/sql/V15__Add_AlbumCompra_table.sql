create table AlbumCompra (
	cod_album smallint not null,
	cod_compra smallint not null,
	constraint album_compra_pk
	primary key (cod_album, cod_compra),
	constraint ac_album_fk foreign key (cod_album)
	references Album on delete cascade,
	constraint ac_compra_fk foreign key (cod_compra)
	references Compra on delete cascade
)