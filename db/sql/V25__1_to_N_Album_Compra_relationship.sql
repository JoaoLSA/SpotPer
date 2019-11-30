delete from compra
drop table AlbumCompra
alter table Compra
add qtde int not null
alter table Compra
add cod_album smallint not null
alter table Compra
add constraint compra_album_fk foreign key (cod_album)
references album on delete cascade