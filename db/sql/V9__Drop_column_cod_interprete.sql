alter table Faixa
drop constraint if exists
	tipo_interprete_fk, cod_interprete_fk

alter table Faixa
drop column if exists cod_interprete