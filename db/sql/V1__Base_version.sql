USE [master]
GO
/****** Object:  Database [SpotPer1]    Script Date: 16/11/2019 14:36:41 ******/
/*CREATE DATABASE [SpotPer1]
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
*/
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
/****** Object:  Table [dbo].[Album]    Script Date: 16/11/2019 14:36:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Album](
	[cod] [smallint] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](40) NOT NULL,
	[data_compra] [datetime] NOT NULL,
	[prcompra] [decimal](9, 2) NOT NULL,
	[tipoCompra] [char](10) NOT NULL,
	[codgravadora] [smallint] NOT NULL,
	[codfaixa] [smallint] NOT NULL,
 CONSTRAINT [album_pk1] PRIMARY KEY CLUSTERED 
(
	[cod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2],
UNIQUE NONCLUSTERED 
(
	[codfaixa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
) ON [SPOT_PER2]
GO
/****** Object:  Table [dbo].[Compositor]    Script Date: 16/11/2019 14:36:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Compositor](
	[cod] [smallint] IDENTITY(1,1) NOT NULL,
	[nome] [char](40) NOT NULL,
	[data_nasc] [datetime] NOT NULL,
	[data_falec] [datetime] NULL,
	[endereco] [smallint] NULL,
	[periodo] [smallint] NOT NULL,
	[codEnder] [smallint] NOT NULL,
 CONSTRAINT [compositor_pk1] PRIMARY KEY CLUSTERED 
(
	[cod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
) ON [SPOT_PER2]
GO
/****** Object:  Table [dbo].[Disco]    Script Date: 16/11/2019 14:36:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Disco](
	[cod] [smallint] IDENTITY(1,1) NOT NULL,
	[descricao] [char](20) NOT NULL,
	[codFaixa] [smallint] NOT NULL,
 CONSTRAINT [disco_pk1] PRIMARY KEY CLUSTERED 
(
	[cod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER2]
) ON [SPOT_PER2]
GO
/****** Object:  Table [dbo].[Endereco]    Script Date: 16/11/2019 14:36:42 ******/
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
/****** Object:  Table [dbo].[Faixa]    Script Date: 16/11/2019 14:36:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Faixa](
	[cod] [smallint] IDENTITY(1,1) NOT NULL,
	[descricao] [char](20) NOT NULL,
	[numero_faixa] [smallint] NOT NULL,
	[tempo_exec] [float] NOT NULL,
	[tipoGravacao] [char](5) NOT NULL,
	[tipoComposicao] [char](10) NOT NULL,
	[cod_interprete] [smallint] NOT NULL,
	[cod_album] [smallint] NOT NULL,
 CONSTRAINT [faixa_pk1] PRIMARY KEY CLUSTERED 
(
	[cod] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [SPOT_PER1]
) ON [SPOT_PER1]
GO
/****** Object:  Table [dbo].[Gravadora]    Script Date: 16/11/2019 14:36:42 ******/
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
/****** Object:  Table [dbo].[Interprete]    Script Date: 16/11/2019 14:36:42 ******/
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
/****** Object:  Table [dbo].[PeriodoMusical]    Script Date: 16/11/2019 14:36:42 ******/
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
/****** Object:  Table [dbo].[Playlist]    Script Date: 16/11/2019 14:36:42 ******/
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
/****** Object:  Table [dbo].[PlaylistFaixa]    Script Date: 16/11/2019 14:36:42 ******/
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
/****** Object:  Table [dbo].[Telefone]    Script Date: 16/11/2019 14:36:42 ******/
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
/****** Object:  Table [dbo].[TipoComposicao]    Script Date: 16/11/2019 14:36:42 ******/
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
/****** Object:  Table [dbo].[TipoCompra]    Script Date: 16/11/2019 14:36:42 ******/
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
/****** Object:  Table [dbo].[TipoGravacao]    Script Date: 16/11/2019 14:36:42 ******/
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
/****** Object:  Table [dbo].[TipoInterprete]    Script Date: 16/11/2019 14:36:42 ******/
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
ALTER TABLE [dbo].[PeriodoMusical] ADD  DEFAULT (getdate()) FOR [inicio]
GO
ALTER TABLE [dbo].[Playlist] ADD  CONSTRAINT [DF__Playlist__data_c__36B12243]  DEFAULT (getdate()) FOR [data_criacao]
GO
ALTER TABLE [dbo].[PlaylistFaixa] ADD  DEFAULT (getdate()) FOR [ultima_exec]
GO
ALTER TABLE [dbo].[PlaylistFaixa] ADD  CONSTRAINT [df_playlist_faixa]  DEFAULT ((0)) FOR [contador_exec]
GO
ALTER TABLE [dbo].[Album]  WITH CHECK ADD  CONSTRAINT [albumfaixa_fk] FOREIGN KEY([codfaixa])
REFERENCES [dbo].[Faixa] ([cod])
GO
ALTER TABLE [dbo].[Album] CHECK CONSTRAINT [albumfaixa_fk]
GO
ALTER TABLE [dbo].[Album]  WITH CHECK ADD  CONSTRAINT [albumgravadora_fk] FOREIGN KEY([codgravadora])
REFERENCES [dbo].[Gravadora] ([cod])
GO
ALTER TABLE [dbo].[Album] CHECK CONSTRAINT [albumgravadora_fk]
GO
ALTER TABLE [dbo].[Album]  WITH CHECK ADD  CONSTRAINT [tipoCompra_fk] FOREIGN KEY([tipoCompra])
REFERENCES [dbo].[TipoCompra] ([tipo])
GO
ALTER TABLE [dbo].[Album] CHECK CONSTRAINT [tipoCompra_fk]
GO
ALTER TABLE [dbo].[Compositor]  WITH CHECK ADD  CONSTRAINT [compositor_fk] FOREIGN KEY([periodo])
REFERENCES [dbo].[PeriodoMusical] ([cod])
GO
ALTER TABLE [dbo].[Compositor] CHECK CONSTRAINT [compositor_fk]
GO
ALTER TABLE [dbo].[Compositor]  WITH CHECK ADD  CONSTRAINT [compositorEnder_fk] FOREIGN KEY([endereco])
REFERENCES [dbo].[Endereco] ([cod])
GO
ALTER TABLE [dbo].[Compositor] CHECK CONSTRAINT [compositorEnder_fk]
GO
ALTER TABLE [dbo].[Compositor]  WITH CHECK ADD  CONSTRAINT [enderecocompositor_fk] FOREIGN KEY([codEnder])
REFERENCES [dbo].[Endereco] ([cod])
GO
ALTER TABLE [dbo].[Compositor] CHECK CONSTRAINT [enderecocompositor_fk]
GO
ALTER TABLE [dbo].[Disco]  WITH CHECK ADD  CONSTRAINT [discofaixa_fk] FOREIGN KEY([codFaixa])
REFERENCES [dbo].[Faixa] ([cod])
GO
ALTER TABLE [dbo].[Disco] CHECK CONSTRAINT [discofaixa_fk]
GO
ALTER TABLE [dbo].[Faixa]  WITH CHECK ADD  CONSTRAINT [cod_album_fk] FOREIGN KEY([cod_album])
REFERENCES [dbo].[Album] ([cod])
GO
ALTER TABLE [dbo].[Faixa] CHECK CONSTRAINT [cod_album_fk]
GO
ALTER TABLE [dbo].[Faixa]  WITH CHECK ADD  CONSTRAINT [cod_interprete_fk] FOREIGN KEY([cod_interprete])
REFERENCES [dbo].[Interprete] ([cod])
GO
ALTER TABLE [dbo].[Faixa] CHECK CONSTRAINT [cod_interprete_fk]
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
ALTER TABLE [dbo].[Interprete]  WITH CHECK ADD  CONSTRAINT [tipo_interprete_fk] FOREIGN KEY([tipoInterprete])
REFERENCES [dbo].[TipoInterprete] ([descricao])
GO
ALTER TABLE [dbo].[Interprete] CHECK CONSTRAINT [tipo_interprete_fk]
GO
USE [master]
GO
ALTER DATABASE [SpotPer1] SET  READ_WRITE 
GO
