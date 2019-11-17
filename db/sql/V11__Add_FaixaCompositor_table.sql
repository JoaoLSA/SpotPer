create table FaixaCompositor (
	cod_faixa smallint not null,
	cod_compositor smallint not null,
	constraint faixa_compositor_pk
	primary key (cod_faixa, cod_compositor),
	constraint fc_faixa_fk foreign key (cod_faixa)
	references Faixa on delete cascade,
	constraint fc_compositor_fk foreign key (cod_compositor)
	references Compositor on delete cascade
)