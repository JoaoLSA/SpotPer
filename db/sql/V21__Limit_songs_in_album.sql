create or alter trigger limit_songs_in_album on Faixa for
insert, update
	as
	if update(cod_album)
		begin
		declare @limit_songs_in_album smallint
		set @limit_songs_in_album = 64
		declare @cod_album smallint
		declare cursor_faixa cursor scroll for
		select cod_album from inserted
		open cursor_faixa
		fetch first from cursor_faixa
		into @cod_album
		while(@@FETCH_STATUS = 0)
		begin
			declare @qtd_faixas smallint
			select @qtd_faixas = count(*)
			from
				Faixa F
			where
				F.cod_album = @cod_album
			if @qtd_faixas > @limit_songs_in_album
			begin
				declare @error_message nvarchar(60)
				set @error_message =
					'Limite de ' + cast(@limit_songs_in_album as nvarchar(3)) +
					' faixa(s) no album com código ' + cast(@cod_album as nvarchar(10)) + ' atingido'
				raiserror(@error_message, 16, 1)
				deallocate cursor_faixa
				rollback transaction
				return
			end
			fetch next from cursor_faixa
			into @cod_album
		end
		deallocate cursor_faixa
	end