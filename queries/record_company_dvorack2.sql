create or alter view playlists_gravadoras
(cod_recorder, cod_playlist)
as
	select
		G.cod,
		P.cod
	from
		Gravadora G,
		Playlist P,
		PlaylistFaixa PF,
		Faixa F,
		Album A
	where
		G.cod = A.codgravadora and
		F.cod_album = A.cod and
		F.cod = PF.cod_faixa and
		PF.cod_playlist = P.cod
	group by
		G.cod, P.cod
select * from playlists_gravadoras
go
insert into compositor values (
'dvorack',
getDate(),
getDate(),
1
)
select
	G.nome
from
	playlists_gravadoras PG,
	Gravadora G
where
	PG.cod_recorder = G.cod and
	exists(
		select PG.cod_playlist
		from
			Faixa F,
			PlaylistFaixa PF,
			Compositor C,
			FaixaCompositor FC,
			Album A
		where
			A.codgravadora = G.cod and
			F.cod_album = A.cod and
			F.cod = PF.cod_faixa and
			PG.cod_playlist = PF.cod_playlist and
			C.cod = FC.cod_compositor and
			F.cod = FC.cod_faixa and
			C.nome = 'dvorack'
		)
group by
	G.cod,
	G.nome
having
	count(
