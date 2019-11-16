create trigger limite_faixas3b on Faixa
	instead of insert, update
	as
	begin
	declare @qtd_faixas_album smallint
		select
		@qtd_faixas_album=count(*)
		from inserted, album
		where inserted.cod_album = album.cod
		if @qtd_faixas_album >= 1 -- used to test
			begin
				RAISERROR (N'Nao e mais possivel adicionar musicas nesse album.', -- Message text.  
					10, -- Severity,  
					1 -- State
					);
			end
		else
			begin
				insert into faixa select * from inserted
			end
		end