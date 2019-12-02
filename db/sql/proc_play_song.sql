create or alter procedure play_song
(@playlist_cod smallint, @song_cod smallint)
as
begin
	update PlaylistFaixa
	set ultima_exec = getDate()
	where cod_playlist = @playlist_cod and
	cod_faixa = @song_cod

	update PlaylistFaixa
	set contador_exec = contador_exec + 1
	where cod_playlist = @playlist_cod and
	cod_faixa = @song_cod
end