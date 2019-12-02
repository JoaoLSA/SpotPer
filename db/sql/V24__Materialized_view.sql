create or alter view Albums_in_Playlist (cod, playlist, num_albums)
with schemabinding
as
	select
		P.cod,
		P.nome,
		count_big(A.cod) as 'Número de albums'
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
select * from Albums_in_Playlist
create or alter view Albums_in_Playlist (playlist, num_albums)
with schemabinding
as
	select 
		P.nome,
		(
		select count(distinct A.cod) as num
		from
			dbo.Album A,
			dbo.PlaylistFaixa PF,
			dbo.Faixa F
		where
			A.cod = F.cod_album and
			PF.cod_playlist = P.cod and
			PF.cod_faixa = F.cod
		)
	from
		dbo.Playlist P
create unique clustered index I_Albums_in_Playlist
on Albums_in_Playlist(playlist)