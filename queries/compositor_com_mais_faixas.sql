select
*
from
Faixa F,
Compositor C,
FaixaCompositor FC
where
C.cod = FC.cod_compositor and
F.cod = FC.cod_faixa
select * from PlaylistFaixa
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
	FaixaCompositor FC,
	Faixa F,
	PlaylistFaixa PF,
	Playlist P
where
	C.cod = FC.cod_compositor and
	F.cod = FC.cod_faixa and
	F.cod = PF.cod_faixa and
	P.cod = PF.cod_playlist
group by
	C.cod, C.nome
having
	count(distinct F.cod) >=
	all (select count (distinct F.cod))