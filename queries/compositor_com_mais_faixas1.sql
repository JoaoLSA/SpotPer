create view compositor_faixa_em_playlist
(cod_compositor, cod_faixa)
as
	select
		C.cod,
		F.cod
	from
		Compositor C,
		FaixaCompositor FC,
		Faixa F,
		PlaylistFaixa PF,
		Playlist P
	where
		C.cod = FC.cod_compositor and
		F.cod = FC.cod_faixa and
		F.cod = PF.cod_faixa and
		P.cod = PF.cod_playlist
select
	C.nome
from
	Compositor C,
	compositor_faixa_em_playlist CFP
where
	C.cod = CFP.cod_compositor
group by
	C.cod, C.nome
having
	count(CFP.cod_faixa) >=
	all (
	select count(CP.cod_faixa)
	from compositor_faixa_em_playlist CP
	group by CP.cod_compositor
	)