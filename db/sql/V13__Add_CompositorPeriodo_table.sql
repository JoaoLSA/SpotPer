create table CompositorPeriodo (
	cod_compositor smallint not null,
	cod_periodo smallint not null,
	constraint compositor_periodo_pk
	primary key (cod_compositor, cod_periodo),
	constraint cp_compositor_fk foreign key (cod_compositor)
	references Compositor on delete cascade,
	constraint cp_periodo_fk foreign key (cod_periodo)
	references PeriodoMusical on delete cascade
)