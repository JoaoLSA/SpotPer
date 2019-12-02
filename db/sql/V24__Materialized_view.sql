create or alter view Albums_in_Playlist (cod_playlist, nome_playlist, cod_album, num_albums)
with schemabinding
as
	select
		P.cod,
		P.nome,
		A.cod,
		count_big(*)
	from
		dbo.Playlist P,
		dbo.Album A,
		dbo.PlaylistFaixa PF,
		dbo.Faixa F
	where
		P.cod = PF.cod_playlist and
		PF.cod_faixa = F.cod and
		F.cod_album = A.cod
	group by
		P.cod, P.nome, A.cod

create or alter view Aux_Albums_in_Playlist(nome_playlist, quantidade_albuns)
as
	select
	P.nome_playlist, count(distinct P.cod_album) as 'Qtd albuns'
	from
	Albums_in_Playlist P
	group by
		P.cod_playlist, P.nome_playlist
	--virtual