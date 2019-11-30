create or alter function canBuyAlbum (@album_id smallint)
returns BIT
as
begin
	if exists (
		select * from
			Faixa F,
			FaixaCompositor FC,
			Compositor C,
			CompositorPeriodo CP,
			PeriodoMusical PM
		where
			F.cod_album = 1 and
			F.cod = FC.cod_faixa and
			C.cod = FC.cod_compositor and
			CP.cod_periodo = PM.cod and
			CP.cod_compositor = C.cod and
			PM.descricao = 'barroco' and
			F.tipoGravacao <> 'DDD'
	)
	begin
		return 0;
	end
	return 1
end
go
alter table AlbumCompra
add constraint only_DDD
check(
	dbo.canBuyAlbum(1) = 1
)