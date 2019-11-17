alter table PlaylistFaixa
add constraint pf_playlist_fk
foreign key (cod_playlist)
references Playlist
on delete cascade

alter table PlaylistFaixa
add constraint pf_faixa_fk
foreign key (cod_faixa)
references Faixa
on delete cascade