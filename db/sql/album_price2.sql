create or alter trigger limit_album_price on Compra
instead of insert, update
as
begin
	if update(prcompra)
	begin
		declare @price_limit decimal(9,2)
		select @price_limit = isnull(avg(prcompra), 0) * 3
		from
			compra C,
			(
				select
					A.cod
				from
					Album A,
					Faixa F
				where
					A.cod = F.cod_album
				group by
					A.cod
				having
					'DDD' = all (select F.tipoGravacao from Faixa F where F.cod_album = A.cod)
			) as A
		where
			C.cod_album = A.cod
		if @price_limit > 0
		begin
			declare @prcompra decimal(9,2)
			declare @nome_album nvarchar(40)
			declare cursor_compra cursor scroll for
			select
				prcompra, A.descricao
			from inserted I, Album A
			where I.cod_album = A.cod

			open cursor_compra
			fetch first from cursor_compra into
			@prcompra, @nome_album
			while(@@FETCH_STATUS = 0)
			begin
				if @prcompra > @price_limit
				begin
					declare @error_message nvarchar(80)
					set @error_message =
						'Valor de compra do album ' + @nome_album + ' acima do limite(' + cast(@price_limit as nvarchar(10)) +  ')'
					raiserror(@error_message,16,1)
					deallocate cursor_compra
					return
				end
				fetch next from cursor_compra into
				@prcompra, @nome_album
			end
			deallocate cursor_compra
		end
		insert into compra
		(datacompra, prcompra, tipo_compra, qtde, cod_album)
		select datacompra, prcompra, tipo_compra, qtde, cod_album from inserted
	end
end