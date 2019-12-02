create or alter trigger only_ddd on Compra
for insert, update
as
	if update(cod_album)
	begin
		declare @cod_album smallint
		declare cursor_compra1 cursor scroll for
		select cod_album from inserted

		open cursor_compra1
		fetch first from cursor_compra1
		into @cod_album
		print 'Numero de tuplas inseridas: '
		declare @num_rows smallint
		select @num_rows=count(cod_album) from inserted
		print @num_rows
		while(@@FETCH_STATUS = 0)
		begin
			print 'cod_album'
			print @cod_album
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
				deallocate cursor_compra1
				return
			end
			print('fetch next')
			fetch next from cursor_compra1
			into @cod_album
		end
		deallocate cursor_compra1
	end