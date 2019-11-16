alter table compra
add cod_album smallint not null

alter table compra
add constraint album_fk foreign key (cod_album)
references album