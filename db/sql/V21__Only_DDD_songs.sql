create or alter trigger only_ddd on Compra
for insert, update
as
	if update(cod_album)
		declare @cod_album smallint
		declare cursor_compra cursor scroll for
		select cod_album from inserted
		open cursor_compra
		fetch first from cursor_compra
		into @cod_album
		while(@@FETCH_STATUS = 0)
		begin
			if exists(
			select
				F.tipoGravacao
			from
				Faixa F,
				PeriodoMusical PM,
				CompositorPeriodo CP,
				Compositor C
			where
				PM.descricao = 'barroco' and
				F.cod_album = @cod_album and
				PM.cod = CP.cod_periodo and
				C.cod = CP.cod_compositor and
				F.tipoGravacao <> 'DDD'
			)
			begin
				raiserror('Album nao pode ser adiquirido, pois tem faixa com tipo de gravacao invalido', 16, 1)
				rollback transaction
				deallocate cursor_compra
				return
			end
			fetch next from cursor_compra
			into @cod_album
		end
		deallocate cursor_compra