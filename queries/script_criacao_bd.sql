USE [master]
GO
/****** Object:  Database [SpotPer1]    Script Date: 02/12/2019 15:48:35 ******/
CREATE DATABASE [SpotPer1]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SpotPer1', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\SpotPer1.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ), 
 FILEGROUP [SPOT_PER1] 
( NAME = N'PLAYLIST', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\PLAYLIST.ndf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ), 
 FILEGROUP [SPOT_PER2]  DEFAULT
( NAME = N'PADRAO', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\PADRAO.ndf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ),
( NAME = N'PADRAO2', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\PADRAO2.ndf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'SpotPer1_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\SpotPer1_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [SpotPer1] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SpotPer1].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SpotPer1] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SpotPer1] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SpotPer1] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SpotPer1] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SpotPer1] SET ARITHABORT OFF 
GO
ALTER DATABASE [SpotPer1] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SpotPer1] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SpotPer1] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SpotPer1] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SpotPer1] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SpotPer1] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SpotPer1] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SpotPer1] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SpotPer1] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SpotPer1] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SpotPer1] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SpotPer1] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SpotPer1] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SpotPer1] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SpotPer1] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SpotPer1] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SpotPer1] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SpotPer1] SET RECOVERY FULL 
GO
ALTER DATABASE [SpotPer1] SET  MULTI_USER 
GO
ALTER DATABASE [SpotPer1] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SpotPer1] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SpotPer1] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SpotPer1] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [SpotPer1] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'SpotPer1', N'ON'
GO
ALTER DATABASE [SpotPer1] SET QUERY_STORE = OFF
GO
USE [SpotPer1]
GO
/****** Object:  UserDefinedFunction [dbo].[canBuyAlbum]    Script Date: 02/12/2019 15:48:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[canBuyAlbum] (@album_id smallint)
returns BIT
as
begin
	if exists (
		select * from
			Faixa F,
			FaixaCompositor FC,
			Compositor C,
			CompositorPeriodo CP,
			PeriodoMusical PM
		where
			F.cod_album = 1 and
			F.cod = FC.cod_faixa and
			C.cod = FC.cod_compositor and
			CP.cod_periodo = PM.cod and
			CP.cod_compositor = C.cod and
			PM.descricao = 'barroco' and
			F.tipoGravacao <> 'DDD'
	)
	begin
		return 0;
	end
	return 1
end
GO
/****** Object:  UserDefinedFunction [dbo].[canBuyAlbumPrice]    Script Date: 02/12/2019 15:48:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[canBuyAlbumPrice] (@albumid smallint, @cod_compra smallint)
returns BIT
as
begin
declare @price decimal(9, 2) = (
	select prcompra
	from Compra
	where cod = @cod_compra 
)
	if @price > (
		select avg(C.prcompra)
		from AlbumCompra AC, Compra C
		where
			@albumid = AC.cod_album and
			C.cod = AC.cod_compra
		) * 3
	begin
		return 0
	end
	return 1
end
GO
/****** Object:  UserDefinedFunction [dbo].[num_songs_on_album]    Script Date: 02/12/2019 15:48:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[num_songs_on_album] (@album_id smallint)
returns smallint
as
begin
	Declare @num_songs smallint;
	select @num_songs = count(*)
	from Faixa F
	where F.cod_album = @album_id
	return @num_songs
end
GO
/****** Object:  Table [dbo].[Playlist]    Script Date: 02/12/2019 15:48:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Playlist](
	[cod] [smallint] IDENTITY(1,1) NOT NULL,
	[nome] [char](16) NOT NULL,
	[data_criacao] [datetime] NULL,
 CONSTRAINT [PK__Playlist__D8360F7B67D9D181] PRIMARY KEY CLUSTERED 
(
	[cod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER1]
) ON [SPOT_PER1]
GO
/****** Object:  Table [dbo].[PlaylistFaixa]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PlaylistFaixa](
	[cod_playlist] [smallint] NOT NULL,
	[cod_faixa] [smallint] NOT NULL,
	[ultima_exec] [datetime] NULL,
	[contador_exec] [smallint] NULL,
 CONSTRAINT [pk_playlist_faixa1] PRIMARY KEY CLUSTERED 
(
	[cod_playlist] ASC,
	[cod_faixa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER1]
) ON [SPOT_PER1]
GO
/****** Object:  Table [dbo].[Album]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Album](
	[cod] [smallint] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](40) NOT NULL,
	[codgravadora] [smallint] NOT NULL,
 CONSTRAINT [album_pk1] PRIMARY KEY CLUSTERED 
(
	[cod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
) ON [SPOT_PER2]
GO
/****** Object:  Table [dbo].[Faixa]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Faixa](
	[cod] [smallint] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](50) NOT NULL,
	[numero_faixa] [smallint] NOT NULL,
	[tempo_exec] [decimal](10, 2) NOT NULL,
	[tipoGravacao] [char](5) NOT NULL,
	[tipoComposicao] [char](10) NOT NULL,
	[cod_album] [smallint] NOT NULL,
 CONSTRAINT [faixa_pk] PRIMARY KEY NONCLUSTERED 
(
	[cod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER1]
) ON [SPOT_PER1]
GO
/****** Object:  Index [faixa_album_fk]    Script Date: 02/12/2019 15:48:38 ******/
CREATE CLUSTERED INDEX [faixa_album_fk] ON [dbo].[Faixa]
(
	[cod_album] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [SPOT_PER1]
GO
/****** Object:  View [dbo].[Albums_in_Playlist]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[Albums_in_Playlist] (cod_playlist, nome_playlist, cod_album, num_albums)
with schemabinding
as
	select
		P.cod,
		P.nome,
		A.cod,
		count_big(*)
	from
		dbo.Playlist P,
		dbo.Album A,
		dbo.PlaylistFaixa PF,
		dbo.Faixa F
	where
		P.cod = PF.cod_playlist and
		PF.cod_faixa = F.cod and
		F.cod_album = A.cod
	group by
		P.cod, P.nome, A.cod
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO
/****** Object:  Index [I_Albums_in_Playlist]    Script Date: 02/12/2019 15:48:38 ******/
CREATE UNIQUE CLUSTERED INDEX [I_Albums_in_Playlist] ON [dbo].[Albums_in_Playlist]
(
	[cod_playlist] ASC,
	[cod_album] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
GO
/****** Object:  Table [dbo].[FaixaCompositor]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FaixaCompositor](
	[cod_faixa] [smallint] NOT NULL,
	[cod_compositor] [smallint] NOT NULL,
 CONSTRAINT [faixa_compositor_pk] PRIMARY KEY CLUSTERED 
(
	[cod_faixa] ASC,
	[cod_compositor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
) ON [SPOT_PER2]
GO
/****** Object:  Table [dbo].[Compositor]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Compositor](
	[cod] [smallint] IDENTITY(1,1) NOT NULL,
	[nome] [char](40) NOT NULL,
	[data_nasc] [datetime] NOT NULL,
	[data_falec] [datetime] NULL,
	[codEnder] [smallint] NOT NULL,
 CONSTRAINT [compositor_pk1] PRIMARY KEY CLUSTERED 
(
	[cod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
) ON [SPOT_PER2]
GO
/****** Object:  UserDefinedFunction [dbo].[albums_from_composer]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function
[dbo].[albums_from_composer] (@name nvarchar)
returns table
as
return (
	select A.cod, A.descricao
	from
		Album A,
		Compositor C,
		Faixa F,
		FaixaCompositor FC
	where
		A.cod = F.cod_album and
		C.cod = FC.cod_compositor and
		F.cod = FC.cod_faixa and
		C.nome like concat('%', @name, '%')
)
GO
/****** Object:  Table [dbo].[Gravadora]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Gravadora](
	[cod] [smallint] IDENTITY(1,1) NOT NULL,
	[nome] [char](40) NOT NULL,
	[home_page] [nvarchar](2083) NOT NULL,
	[codTel] [smallint] NULL,
	[codEnder] [smallint] NULL,
 CONSTRAINT [gravadora_pk1] PRIMARY KEY CLUSTERED 
(
	[cod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
) ON [SPOT_PER2]
GO
/****** Object:  View [dbo].[playlists_gravadoras]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[playlists_gravadoras]
(cod_recorder, cod_playlist)
as
	select
		G.cod,
		P.cod
	from
		Gravadora G,
		Playlist P,
		PlaylistFaixa PF,
		Faixa F,
		Album A
	where
		G.cod = A.codgravadora and
		F.cod_album = A.cod and
		F.cod = PF.cod_faixa and
		PF.cod_playlist = P.cod
	group by
		G.cod, P.cod
GO
/****** Object:  View [dbo].[playlists_com_som_do_dvorack]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[playlists_com_som_do_dvorack]
(cod_playlist, cod_faixa)
as
	select
		P.cod,
		F.cod
	from
		Playlist P,
		PlaylistFaixa PF,
		Faixa F,
		FaixaCompositor FC,
		Compositor C
	where
		P.cod = PF.cod_playlist and
		F.cod = PF.cod_faixa and
		F.cod = FC. cod_faixa and
		C.cod = FC.cod_compositor and
		C.nome = 'dvorack'
	group by
		P.cod, F.cod
GO
/****** Object:  View [dbo].[playlists_por_gravadora]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[playlists_por_gravadora]
(cod_gravadora, cod_playlist)
as
	select
	G.cod, P.cod_playlist
from
	gravadora G,
	Album A,
	Faixa F,
	PlaylistFaixa PF,
	playlists_com_som_do_dvorack P
where
	F.cod = P.cod_faixa and
	P.cod_faixa = PF.cod_faixa and
	P.cod_playlist = PF.cod_playlist and
	F.cod_album = A.cod and
	A.codgravadora = G.cod
GO
/****** Object:  View [dbo].[compositor_faixa_em_playlist]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[compositor_faixa_em_playlist]
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
GO
/****** Object:  View [dbo].[Aux_Albums_in_Playlist]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[Aux_Albums_in_Playlist](nome_playlist, quantidade_albuns)
as
	select
	P.nome_playlist, count(distinct P.cod_album) as 'Qtd albuns'
	from
	Albums_in_Playlist P
	group by
		P.cod_playlist, P.nome_playlist
GO
/****** Object:  Table [dbo].[CompositorPeriodo]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompositorPeriodo](
	[cod_compositor] [smallint] NOT NULL,
	[cod_periodo] [smallint] NOT NULL,
 CONSTRAINT [compositor_periodo_fk] PRIMARY KEY CLUSTERED 
(
	[cod_compositor] ASC,
	[cod_periodo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
) ON [SPOT_PER2]
GO
/****** Object:  Table [dbo].[Compra]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Compra](
	[cod] [smallint] IDENTITY(1,1) NOT NULL,
	[datacompra] [datetime] NOT NULL,
	[prcompra] [decimal](9, 2) NOT NULL,
	[tipo_compra] [char](10) NOT NULL,
	[qtde] [int] NOT NULL,
	[cod_album] [smallint] NOT NULL,
 CONSTRAINT [compra_pk] PRIMARY KEY CLUSTERED 
(
	[cod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
) ON [SPOT_PER2]
GO
/****** Object:  Table [dbo].[Disco]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Disco](
	[cod] [smallint] IDENTITY(1,1) NOT NULL,
	[descricao] [char](20) NOT NULL,
 CONSTRAINT [disco_pk1] PRIMARY KEY CLUSTERED 
(
	[cod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
) ON [SPOT_PER2]
GO
/****** Object:  Table [dbo].[Endereco]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Endereco](
	[cod] [smallint] IDENTITY(1,1) NOT NULL,
	[cidade] [nvarchar](30) NULL,
	[estado] [nvarchar](30) NULL,
	[pais] [nvarchar](30) NULL,
 CONSTRAINT [endereco_pk1] PRIMARY KEY CLUSTERED 
(
	[cod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
) ON [SPOT_PER2]
GO
/****** Object:  Table [dbo].[FaixaDisco]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FaixaDisco](
	[cod_faixa] [smallint] NOT NULL,
	[cod_disco] [smallint] NOT NULL,
 CONSTRAINT [faixa_disco_pk] PRIMARY KEY CLUSTERED 
(
	[cod_faixa] ASC,
	[cod_disco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
) ON [SPOT_PER2]
GO
/****** Object:  Table [dbo].[FaixaInterprete]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FaixaInterprete](
	[cod_faixa] [smallint] NOT NULL,
	[cod_interprete] [smallint] NOT NULL,
 CONSTRAINT [faixa_interprete_pk] PRIMARY KEY CLUSTERED 
(
	[cod_faixa] ASC,
	[cod_interprete] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
) ON [SPOT_PER2]
GO
/****** Object:  Table [dbo].[flyway_schema_history]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[flyway_schema_history](
	[installed_rank] [int] NOT NULL,
	[version] [nvarchar](50) NULL,
	[description] [nvarchar](200) NULL,
	[type] [nvarchar](20) NOT NULL,
	[script] [nvarchar](1000) NOT NULL,
	[checksum] [int] NULL,
	[installed_by] [nvarchar](100) NOT NULL,
	[installed_on] [datetime] NOT NULL,
	[execution_time] [int] NOT NULL,
	[success] [bit] NOT NULL,
 CONSTRAINT [flyway_schema_history_pk] PRIMARY KEY CLUSTERED 
(
	[installed_rank] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
) ON [SPOT_PER2]
GO
/****** Object:  Table [dbo].[GravadoraTelefone]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GravadoraTelefone](
	[cod_gravadora] [smallint] NOT NULL,
	[cod_telefone] [smallint] NOT NULL,
 CONSTRAINT [gravadora_telefone_fk] PRIMARY KEY CLUSTERED 
(
	[cod_gravadora] ASC,
	[cod_telefone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
) ON [SPOT_PER2]
GO
/****** Object:  Table [dbo].[Interprete]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Interprete](
	[cod] [smallint] IDENTITY(1,1) NOT NULL,
	[nome] [char](40) NOT NULL,
	[tipoInterprete] [char](10) NOT NULL,
 CONSTRAINT [interprete_pk1] PRIMARY KEY CLUSTERED 
(
	[cod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
) ON [SPOT_PER2]
GO
/****** Object:  Table [dbo].[PeriodoMusical]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PeriodoMusical](
	[cod] [smallint] IDENTITY(1,1) NOT NULL,
	[descricao] [char](20) NOT NULL,
	[inicio] [datetime] NULL,
	[termino] [datetime] NULL,
 CONSTRAINT [periodo_musical_pk1] PRIMARY KEY CLUSTERED 
(
	[cod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
) ON [SPOT_PER2]
GO
/****** Object:  Table [dbo].[Telefone]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Telefone](
	[cod] [smallint] IDENTITY(1,1) NOT NULL,
	[ddd] [nvarchar](4) NOT NULL,
	[numero] [nvarchar](10) NOT NULL,
 CONSTRAINT [telefone_pk1] PRIMARY KEY CLUSTERED 
(
	[cod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
) ON [SPOT_PER2]
GO
/****** Object:  Table [dbo].[TipoComposicao]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoComposicao](
	[descricao] [char](10) NOT NULL,
 CONSTRAINT [tipo_composicao_pk] PRIMARY KEY CLUSTERED 
(
	[descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
) ON [SPOT_PER2]
GO
/****** Object:  Table [dbo].[TipoCompra]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoCompra](
	[tipo] [char](10) NOT NULL,
 CONSTRAINT [tipo_compra_pk] PRIMARY KEY CLUSTERED 
(
	[tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
) ON [SPOT_PER2]
GO
/****** Object:  Table [dbo].[TipoGravacao]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoGravacao](
	[descricao] [char](5) NOT NULL,
 CONSTRAINT [tipo_gravacao_pk] PRIMARY KEY CLUSTERED 
(
	[descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
) ON [SPOT_PER2]
GO
/****** Object:  Table [dbo].[TipoInterprete]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoInterprete](
	[descricao] [char](10) NOT NULL,
 CONSTRAINT [tipo_interprete_pk] PRIMARY KEY CLUSTERED 
(
	[descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
) ON [SPOT_PER2]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [faixa_tcomp_fk]    Script Date: 02/12/2019 15:48:38 ******/
CREATE NONCLUSTERED INDEX [faixa_tcomp_fk] ON [dbo].[Faixa]
(
	[tipoComposicao] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [SPOT_PER1]
GO
/****** Object:  Index [flyway_schema_history_s_idx]    Script Date: 02/12/2019 15:48:38 ******/
CREATE NONCLUSTERED INDEX [flyway_schema_history_s_idx] ON [dbo].[flyway_schema_history]
(
	[success] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
GO
ALTER TABLE [dbo].[flyway_schema_history] ADD  DEFAULT (getdate()) FOR [installed_on]
GO
ALTER TABLE [dbo].[PeriodoMusical] ADD  DEFAULT (getdate()) FOR [inicio]
GO
ALTER TABLE [dbo].[Playlist] ADD  CONSTRAINT [DF__Playlist__data_c__36B12243]  DEFAULT (getdate()) FOR [data_criacao]
GO
ALTER TABLE [dbo].[PlaylistFaixa] ADD  CONSTRAINT [df_playlist_faixa]  DEFAULT ((0)) FOR [contador_exec]
GO
ALTER TABLE [dbo].[Album]  WITH CHECK ADD  CONSTRAINT [albumgravadora_fk] FOREIGN KEY([codgravadora])
REFERENCES [dbo].[Gravadora] ([cod])
GO
ALTER TABLE [dbo].[Album] CHECK CONSTRAINT [albumgravadora_fk]
GO
ALTER TABLE [dbo].[Compositor]  WITH CHECK ADD  CONSTRAINT [enderecocompositor_fk] FOREIGN KEY([codEnder])
REFERENCES [dbo].[Endereco] ([cod])
GO
ALTER TABLE [dbo].[Compositor] CHECK CONSTRAINT [enderecocompositor_fk]
GO
ALTER TABLE [dbo].[CompositorPeriodo]  WITH CHECK ADD  CONSTRAINT [cp_compositor_fk] FOREIGN KEY([cod_compositor])
REFERENCES [dbo].[Compositor] ([cod])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CompositorPeriodo] CHECK CONSTRAINT [cp_compositor_fk]
GO
ALTER TABLE [dbo].[CompositorPeriodo]  WITH CHECK ADD  CONSTRAINT [cp_periodo_fk] FOREIGN KEY([cod_periodo])
REFERENCES [dbo].[PeriodoMusical] ([cod])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CompositorPeriodo] CHECK CONSTRAINT [cp_periodo_fk]
GO
ALTER TABLE [dbo].[Compra]  WITH CHECK ADD  CONSTRAINT [compra_album_fk] FOREIGN KEY([cod_album])
REFERENCES [dbo].[Album] ([cod])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Compra] CHECK CONSTRAINT [compra_album_fk]
GO
ALTER TABLE [dbo].[Compra]  WITH CHECK ADD  CONSTRAINT [tipo_compra_fk] FOREIGN KEY([tipo_compra])
REFERENCES [dbo].[TipoCompra] ([tipo])
GO
ALTER TABLE [dbo].[Compra] CHECK CONSTRAINT [tipo_compra_fk]
GO
ALTER TABLE [dbo].[Faixa]  WITH CHECK ADD  CONSTRAINT [cod_album_fk] FOREIGN KEY([cod_album])
REFERENCES [dbo].[Album] ([cod])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Faixa] CHECK CONSTRAINT [cod_album_fk]
GO
ALTER TABLE [dbo].[Faixa]  WITH CHECK ADD  CONSTRAINT [tipo_composicao_fk] FOREIGN KEY([tipoComposicao])
REFERENCES [dbo].[TipoComposicao] ([descricao])
GO
ALTER TABLE [dbo].[Faixa] CHECK CONSTRAINT [tipo_composicao_fk]
GO
ALTER TABLE [dbo].[Faixa]  WITH CHECK ADD  CONSTRAINT [tipo_gravacao_fk] FOREIGN KEY([tipoGravacao])
REFERENCES [dbo].[TipoGravacao] ([descricao])
GO
ALTER TABLE [dbo].[Faixa] CHECK CONSTRAINT [tipo_gravacao_fk]
GO
ALTER TABLE [dbo].[FaixaCompositor]  WITH CHECK ADD  CONSTRAINT [fc_compositor_fk] FOREIGN KEY([cod_compositor])
REFERENCES [dbo].[Compositor] ([cod])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FaixaCompositor] CHECK CONSTRAINT [fc_compositor_fk]
GO
ALTER TABLE [dbo].[FaixaCompositor]  WITH CHECK ADD  CONSTRAINT [fc_faixa_fk] FOREIGN KEY([cod_faixa])
REFERENCES [dbo].[Faixa] ([cod])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FaixaCompositor] CHECK CONSTRAINT [fc_faixa_fk]
GO
ALTER TABLE [dbo].[FaixaDisco]  WITH CHECK ADD  CONSTRAINT [fd_cd_fk] FOREIGN KEY([cod_disco])
REFERENCES [dbo].[Disco] ([cod])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FaixaDisco] CHECK CONSTRAINT [fd_cd_fk]
GO
ALTER TABLE [dbo].[FaixaDisco]  WITH CHECK ADD  CONSTRAINT [fd_faixa_fk] FOREIGN KEY([cod_faixa])
REFERENCES [dbo].[Faixa] ([cod])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FaixaDisco] CHECK CONSTRAINT [fd_faixa_fk]
GO
ALTER TABLE [dbo].[FaixaInterprete]  WITH CHECK ADD  CONSTRAINT [fi_faixa_fk] FOREIGN KEY([cod_faixa])
REFERENCES [dbo].[Faixa] ([cod])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FaixaInterprete] CHECK CONSTRAINT [fi_faixa_fk]
GO
ALTER TABLE [dbo].[FaixaInterprete]  WITH CHECK ADD  CONSTRAINT [fi_interprete_fk] FOREIGN KEY([cod_interprete])
REFERENCES [dbo].[Interprete] ([cod])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FaixaInterprete] CHECK CONSTRAINT [fi_interprete_fk]
GO
ALTER TABLE [dbo].[Gravadora]  WITH CHECK ADD  CONSTRAINT [gravadoraendereco_fk] FOREIGN KEY([codEnder])
REFERENCES [dbo].[Endereco] ([cod])
GO
ALTER TABLE [dbo].[Gravadora] CHECK CONSTRAINT [gravadoraendereco_fk]
GO
ALTER TABLE [dbo].[Gravadora]  WITH CHECK ADD  CONSTRAINT [gravadoratelefone_fk] FOREIGN KEY([codTel])
REFERENCES [dbo].[Telefone] ([cod])
GO
ALTER TABLE [dbo].[Gravadora] CHECK CONSTRAINT [gravadoratelefone_fk]
GO
ALTER TABLE [dbo].[GravadoraTelefone]  WITH CHECK ADD  CONSTRAINT [gf_gravadora_fk] FOREIGN KEY([cod_gravadora])
REFERENCES [dbo].[Gravadora] ([cod])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[GravadoraTelefone] CHECK CONSTRAINT [gf_gravadora_fk]
GO
ALTER TABLE [dbo].[GravadoraTelefone]  WITH CHECK ADD  CONSTRAINT [gf_telefone_fk] FOREIGN KEY([cod_telefone])
REFERENCES [dbo].[Telefone] ([cod])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[GravadoraTelefone] CHECK CONSTRAINT [gf_telefone_fk]
GO
ALTER TABLE [dbo].[Interprete]  WITH CHECK ADD  CONSTRAINT [tipo_interprete_fk] FOREIGN KEY([tipoInterprete])
REFERENCES [dbo].[TipoInterprete] ([descricao])
GO
ALTER TABLE [dbo].[Interprete] CHECK CONSTRAINT [tipo_interprete_fk]
GO
ALTER TABLE [dbo].[PlaylistFaixa]  WITH CHECK ADD  CONSTRAINT [pf_faixa_fk] FOREIGN KEY([cod_faixa])
REFERENCES [dbo].[Faixa] ([cod])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PlaylistFaixa] CHECK CONSTRAINT [pf_faixa_fk]
GO
ALTER TABLE [dbo].[PlaylistFaixa]  WITH CHECK ADD  CONSTRAINT [pf_playlist_fk] FOREIGN KEY([cod_playlist])
REFERENCES [dbo].[Playlist] ([cod])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PlaylistFaixa] CHECK CONSTRAINT [pf_playlist_fk]
GO
/****** Object:  StoredProcedure [dbo].[play_song]    Script Date: 02/12/2019 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[play_song]
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
GO
USE [master]
GO
ALTER DATABASE [SpotPer1] SET  READ_WRITE 
GO
