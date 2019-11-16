create table Compra (
	cod smallint identity,
	datacompra datetime not null,
	prcompra decimal(4,2) not null,
	constraint compra_pk primary key (cod)
)