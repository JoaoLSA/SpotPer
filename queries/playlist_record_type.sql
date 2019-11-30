select
	P.nome
from
	Playlist P,
	PlaylistFaixa PF,
	Faixa F,
	TipoComposicao TC,
	FaixaCompositor FC,
	Compositor C,
	CompositorPeriodo CP,
	PeriodoMusical PM
where
	