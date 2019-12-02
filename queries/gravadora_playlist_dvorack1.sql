create or alter view playlists_com_som_do_dvorack
(cod_playlist, cod_faixa)
as
	select
		P.cod,
		F.cod
	from
		Playlist P,
		PlaylistFaixa PF,
		Faixa F,
		FaixaCompositor FC,
		Compositor C
	where
		P.cod = PF.cod_playlist and
		F.cod = PF.cod_faixa and
		F.cod = FC. cod_faixa and
		C.cod = FC.cod_compositor
	group by
		P.cod, F.cod
	having
		'dvorack' = any(
			select
				C.nome
			from
				PlaylistFaixa PF,
				Faixa F,
				FaixaCompositor FC,
				Compositor C
			where
				P.cod = PF.cod_playlist and
				F.cod = PF.cod_faixa and
				F.cod = FC.cod_faixa and
				C.cod = FC.cod_compositor
			)
create or alter view playlists_por_gravadora
(cod_gravadora, cod_playlist)
as
	select
	G.cod, P.cod_playlist
from
	gravadora G,
	Album A,
	Faixa F,
	PlaylistFaixa PF,
	playlists_com_som_do_dvorack P
where
	F.cod = PF.cod_faixa and
	P.cod_playlist = PF.cod_playlist and
	F.cod_album = A.cod and
	A.codgravadora = G.cod
select * from playlists_com_som_do_dvorack
select *
from
	Faixa F,
	FaixaCompositor FC,
	Compositor C
where
	F.cod = FC.cod_faixa and
	C.cod = FC.cod_compositor
select * from album
select
	Gr.nome
from
	playlists_por_gravadora G,
	Gravadora Gr
where
	G.cod_gravadora = Gr.cod
group by
	Gr.cod, Gr.nome
having
	count(distinct G.cod_playlist) >= all(
		select count(distinct G.cod_playlist)
		from playlists_por_gravadora G
		group by G.cod_gravadora
	)
