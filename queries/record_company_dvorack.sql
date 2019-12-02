select
	G.nome
from
	Gravadora G,
	Album A,
	Faixa F,
	FaixaCompositor FC,
	Compositor C,
	Playlist P,
	PlaylistFaixa PF
where
	G.cod = A.codgravadora and
	F.cod_album = A.cod and
	F.cod = FC.cod_faixa and
	FC.cod_compositor = C.cod and
	F.cod = PF.cod_faixa and
	PF.cod_playlist = P.cod and
	C.nome = 'Dvorack'
group by
	G.cod, G.nome
having
	count(distinct P.cod) >=
	all(select count(distinct P.cod))

