create or alter function canBuyAlbumPrice (@albumid smallint, @cod_compra smallint)
returns BIT
as
begin
declare @price decimal(4, 2) = (
	select prcompra
	from Compra
	where cod = @cod_compra 
)
	if @price > (
		select avg(C.prcompra)
		from AlbumCompra AC, Compra C
		where
			@albumid = AC.cod_album and
			C.cod = AC.cod_compra
		) * 3
	begin
		return 0
	end
	return 1
end

alter table AlbumCompra
add constraint checkAlbumPrice
check (dbo.canBuyAlbumPrice(cod_album, cod_compra) = 1)