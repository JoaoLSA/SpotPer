create or alter function num_songs_on_album (@album_id smallint)
returns smallint
as
begin
	Declare @num_songs smallint;
	select @num_songs = count(*)
	from Faixa F
	where F.cod_album = @album_id
	return @num_songs
end
go
alter table Faixa
add constraint songs_limit
	check(
		dbo.num_songs_on_album (cod_album) <= 1
	)