select * from
Faixa F, FaixaCompositor FC, Compositor C
where
	F.cod = Fc.cod_faixa and
	C.cod = FC.cod_compositor
select
	C.nome
from
	Compositor C,
	FaixaCompositor FC,
	Faixa F,
	PlaylistFaixa PF,
	Playlist P
where
	C.cod = FC.cod_faixa and
	F.cod = FC.cod_faixa and
	F.cod = PF.cod_faixa and
	P.cod = PF.cod_playlist
group by
	C.cod, C.nome
having
	count(distinct F.cod) >=
	all (select count (distinct F.cod))