alter table album
drop column if exists data_compra

alter table album
drop constraint if exists tipoCompra_fk
alter table album
drop column if exists tipocompra