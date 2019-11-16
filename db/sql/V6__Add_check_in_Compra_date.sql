alter table compra
add constraint min_data_compra check
(
	datacompra > '01-01-2000'
)