select
	A.descricao
from
	Compra C, ALbum A
where
	C.cod_album = A.cod and
	C.prcompra > (select avg(prcompra) from Compra)