alter table FaixaCompositor
drop constraint fc_faixa_fk

alter table PlaylistFaixa
drop constraint pf_faixa_fk

alter table FaixaDisco
drop constraint fd_faixa_fk

alter table FaixaInterprete
drop constraint fi_faixa_fk

alter table faixa
drop constraint faixa_pk1

drop index
if exists faixa_pk1 on Faixa

create clustered index faixa_album_fk
on Faixa(cod_album)
with (pad_index=on, fillfactor=100)

create nonclustered index faixa_tcomp_fk
on Faixa(tipoComposicao)
with (pad_index=on, fillfactor=100)

alter table Faixa
add constraint faixa_pk
primary key nonclustered (cod)

alter table FaixaCompositor
add constraint fc_faixa_fk
foreign key (cod_faixa)
references Faixa
on delete cascade

alter table FaixaCompositor
add constraint fc_faixa_fk
foreign key (cod_faixa)
references Faixa
on delete cascade

alter table FaixaInterprete
add constraint fi_faixa_fk
foreign key (cod_faixa)
references Faixa
on delete cascade
