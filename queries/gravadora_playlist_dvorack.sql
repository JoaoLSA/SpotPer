create or alter view playlists_com_som_do_dvorack
(cod_playlist)
as
	select
		P.cod
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
		P.cod
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
				F.cod = FC. cod_faixa and
				C.cod = FC.cod_compositor
			)
select * from playlists_com_som_do_dvorack
select
	G.nome
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
group by
	G.cod, G.nome
having
	count(distinct P.cod_playlist) >= all(
		select count(distinct P.cod_playlist)
		)
