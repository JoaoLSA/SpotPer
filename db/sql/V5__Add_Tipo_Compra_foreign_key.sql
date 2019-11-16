alter table Compra
add tipo_compra char(10) not null

alter table Compra
add constraint tipo_compra_fk foreign key (tipo_compra) references TipoCompra on delete no action