alter table faixa
drop constraint if exists cod_album_fk

alter table faixa
add constraint cod_album_fk
foreign key (cod_album)
references album
on delete cascade