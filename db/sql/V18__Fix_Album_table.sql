alter table Album
drop column prcompra

alter table Album
drop constraint albumfaixa_fk

alter table Album
drop constraint UQ__Album__0EC41FF346F98E96
alter table Album
drop column codfaixa