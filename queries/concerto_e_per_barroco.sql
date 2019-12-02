select
	P.nome
from
	playlist P,
	PlaylistFaixa PF,
	Faixa F,
	FaixaCompositor FC,
	Compositor C,
	CompositorPeriodo CP,
	PeriodoMusical PM
where
	P.cod = PF.cod_playlist and
	F.cod = PF.cod_faixa and
	C.cod = CP.cod_compositor and
	PM.cod = CP.cod_periodo and
	C.cod = FC.cod_compositor and
	F.cod = FC.cod_faixa
group by
	P.cod, P.nome
having
	'concerto' = all (
		select F.tipoComposicao
		from Faixa F, PlaylistFaixa PF
		where
		F.cod = PF.cod_faixa and
		PF.cod_playlist = P.cod
		) and
	'barroco' = all (
		select
			PM.descricao
		from
			PeriodoMusical PM,
			CompositorPeriodo CP,
			Compositor C,
			Faixa F,
			FaixaCompositor FC,
			PlaylistFaixa PF
		where
			F.cod = PF.cod_faixa and
			PF.cod_playlist = cod_playlist and
			C.cod = FC.cod_compositor and
			F.cod = FC.cod_faixa and
			C.cod = CP.cod_compositor and
			PM.cod = CP.cod_periodo
		)

