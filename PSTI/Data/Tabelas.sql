USE [AceiteEletronico]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Usuario_PrimeiroAcesso_Usuario]') AND parent_object_id = OBJECT_ID(N'[dbo].[Usuario_PrimeiroAcesso]'))
ALTER TABLE [dbo].[Usuario_PrimeiroAcesso] DROP CONSTRAINT [FK_Usuario_PrimeiroAcesso_Usuario]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Usuario_PrimeiroAcesso_Processo]') AND parent_object_id = OBJECT_ID(N'[dbo].[Usuario_PrimeiroAcesso]'))
ALTER TABLE [dbo].[Usuario_PrimeiroAcesso] DROP CONSTRAINT [FK_Usuario_PrimeiroAcesso_Processo]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Usuario_Perfil_Usuario]') AND parent_object_id = OBJECT_ID(N'[dbo].[Usuario_Perfil]'))
ALTER TABLE [dbo].[Usuario_Perfil] DROP CONSTRAINT [FK_Usuario_Perfil_Usuario]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Usuario_Perfil_Perfil]') AND parent_object_id = OBJECT_ID(N'[dbo].[Usuario_Perfil]'))
ALTER TABLE [dbo].[Usuario_Perfil] DROP CONSTRAINT [FK_Usuario_Perfil_Perfil]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Usuario_Departamento]') AND parent_object_id = OBJECT_ID(N'[dbo].[Usuario]'))
ALTER TABLE [dbo].[Usuario] DROP CONSTRAINT [FK_Usuario_Departamento]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Usuario_Cargo]') AND parent_object_id = OBJECT_ID(N'[dbo].[Usuario]'))
ALTER TABLE [dbo].[Usuario] DROP CONSTRAINT [FK_Usuario_Cargo]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Processo_Perfil_Processo]') AND parent_object_id = OBJECT_ID(N'[dbo].[Processo_Perfil]'))
ALTER TABLE [dbo].[Processo_Perfil] DROP CONSTRAINT [FK_Processo_Perfil_Processo]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Processo_Perfil_Perfil]') AND parent_object_id = OBJECT_ID(N'[dbo].[Processo_Perfil]'))
ALTER TABLE [dbo].[Processo_Perfil] DROP CONSTRAINT [FK_Processo_Perfil_Perfil]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_LogAcesso_Usuario]') AND parent_object_id = OBJECT_ID(N'[dbo].[LogAcesso]'))
ALTER TABLE [dbo].[LogAcesso] DROP CONSTRAINT [FK_LogAcesso_Usuario]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_LogAcesso_Processo]') AND parent_object_id = OBJECT_ID(N'[dbo].[LogAcesso]'))
ALTER TABLE [dbo].[LogAcesso] DROP CONSTRAINT [FK_LogAcesso_Processo]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Aceite_Usuario]') AND parent_object_id = OBJECT_ID(N'[dbo].[Aceite]'))
ALTER TABLE [dbo].[Aceite] DROP CONSTRAINT [FK_Aceite_Usuario]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Aceite_Processo]') AND parent_object_id = OBJECT_ID(N'[dbo].[Aceite]'))
ALTER TABLE [dbo].[Aceite] DROP CONSTRAINT [FK_Aceite_Processo]
GO
/****** Object:  Table [dbo].[Usuario_PrimeiroAcesso]    Script Date: 31/01/2020 12:07:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usuario_PrimeiroAcesso]') AND type in (N'U'))
DROP TABLE [dbo].[Usuario_PrimeiroAcesso]
GO
/****** Object:  Table [dbo].[Usuario_Perfil]    Script Date: 31/01/2020 12:07:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usuario_Perfil]') AND type in (N'U'))
DROP TABLE [dbo].[Usuario_Perfil]
GO
/****** Object:  Table [dbo].[Usuario]    Script Date: 31/01/2020 12:07:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usuario]') AND type in (N'U'))
DROP TABLE [dbo].[Usuario]
GO
/****** Object:  Table [dbo].[Processo_Perfil]    Script Date: 31/01/2020 12:07:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Processo_Perfil]') AND type in (N'U'))
DROP TABLE [dbo].[Processo_Perfil]
GO
/****** Object:  Table [dbo].[Processo]    Script Date: 31/01/2020 12:07:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Processo]') AND type in (N'U'))
DROP TABLE [dbo].[Processo]
GO
/****** Object:  Table [dbo].[Perfil]    Script Date: 31/01/2020 12:07:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Perfil]') AND type in (N'U'))
DROP TABLE [dbo].[Perfil]
GO
/****** Object:  Table [dbo].[LogAcesso]    Script Date: 31/01/2020 12:07:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LogAcesso]') AND type in (N'U'))
DROP TABLE [dbo].[LogAcesso]
GO
/****** Object:  Table [dbo].[Departamento]    Script Date: 31/01/2020 12:07:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Departamento]') AND type in (N'U'))
DROP TABLE [dbo].[Departamento]
GO
/****** Object:  Table [dbo].[Cargo]    Script Date: 31/01/2020 12:07:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cargo]') AND type in (N'U'))
DROP TABLE [dbo].[Cargo]
GO
/****** Object:  Table [dbo].[Aceite]    Script Date: 31/01/2020 12:07:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Aceite]') AND type in (N'U'))
DROP TABLE [dbo].[Aceite]
GO
/****** Object:  Table [dbo].[Aceite]    Script Date: 31/01/2020 12:07:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Aceite](
	[CPF_USUARIO] [varchar](11) NOT NULL,
	[ID_PROCESSO] [int] NOT NULL,
	[DT_ACEITE] [smalldatetime] NULL,
	[END_ARQ_ACEITE] [varchar](255) NULL,
	[HASH] [varchar](255) NULL,
 CONSTRAINT [PK_Aceite] PRIMARY KEY CLUSTERED 
(
	[CPF_USUARIO] ASC,
	[ID_PROCESSO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cargo]    Script Date: 31/01/2020 12:07:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cargo](
	[ID_CARGO] [int] IDENTITY(1,1) NOT NULL,
	[NM_CARGO] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Cargo] PRIMARY KEY CLUSTERED 
(
	[ID_CARGO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Departamento]    Script Date: 31/01/2020 12:07:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Departamento](
	[ID_DEPARTAMENTO] [int] IDENTITY(1,1) NOT NULL,
	[NM_DEPARTAMENTO] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Departamento] PRIMARY KEY CLUSTERED 
(
	[ID_DEPARTAMENTO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LogAcesso]    Script Date: 31/01/2020 12:07:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LogAcesso](
	[ID_LOGACESSO] [bigint] IDENTITY(1,1) NOT NULL,
	[ID_PROCESSO] [int] NOT NULL,
	[CPF_USUARIO] [varchar](11) NOT NULL,
	[DT_ACESSO] [smalldatetime] NOT NULL,
	[NM_COMPUTADOR] [varchar](50) NOT NULL,
 CONSTRAINT [PK_LogAcesso] PRIMARY KEY CLUSTERED 
(
	[ID_LOGACESSO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Perfil]    Script Date: 31/01/2020 12:07:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Perfil](
	[ID_PERFIL] [int] IDENTITY(1,1) NOT NULL,
	[NM_PERFIL] [varchar](100) NOT NULL,
	[DT_LIMITE] [smalldatetime] NULL,
 CONSTRAINT [PK_Perfil] PRIMARY KEY CLUSTERED 
(
	[ID_PERFIL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Processo]    Script Date: 31/01/2020 12:07:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Processo](
	[ID_PROCESSO] [int] IDENTITY(1,1) NOT NULL,
	[NM_PROCESSO] [varchar](100) NULL,
	[DESC_PROCESSO] [varchar](max) NULL,
	[FL_ATIVO] [bit] NULL,
	[DT_INCLUSAO] [smalldatetime] NULL,
 CONSTRAINT [PK_Processo] PRIMARY KEY CLUSTERED 
(
	[ID_PROCESSO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Processo_Perfil]    Script Date: 31/01/2020 12:07:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Processo_Perfil](
	[ID_PROCESSO] [int] NOT NULL,
	[ID_PERFIL] [int] NOT NULL,
	[END_ARQ_DOC] [varchar](255) NULL,
	[FL_BLOQ] [bit] NULL,
 CONSTRAINT [PK_Processo_Perfil] PRIMARY KEY CLUSTERED 
(
	[ID_PROCESSO] ASC,
	[ID_PERFIL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuario]    Script Date: 31/01/2020 12:07:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuario](
	[CPF_USUARIO] [varchar](11) NOT NULL,
	[NM_USUARIO] [varchar](100) NOT NULL,
	[NM_DOMINIO] [varchar](100) NOT NULL,
	[ID_PERFIL] [int] NULL,
	[ID_CARGO] [int] NOT NULL,
	[ID_DEPARTAMENTO] [int] NOT NULL,
	[EML_USUARIO] [varchar](100) NULL,
	[TEL_USUARIO] [varchar](20) NULL,
 CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED 
(
	[CPF_USUARIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuario_Perfil]    Script Date: 31/01/2020 12:07:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuario_Perfil](
	[CPF_USUARIO] [varchar](11) NOT NULL,
	[ID_PERFIL] [int] NOT NULL,
 CONSTRAINT [PK_Usuario_Perfil] PRIMARY KEY CLUSTERED 
(
	[CPF_USUARIO] ASC,
	[ID_PERFIL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuario_PrimeiroAcesso]    Script Date: 31/01/2020 12:07:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuario_PrimeiroAcesso](
	[CPF_USUARIO] [varchar](11) NOT NULL,
	[ID_PROCESSO] [int] NOT NULL,
	[DT_INICIO] [smalldatetime] NOT NULL,
	[DT_FIM] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_Usuario_PrimeiroAcesso] PRIMARY KEY CLUSTERED 
(
	[CPF_USUARIO] ASC,
	[ID_PROCESSO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Perfil] ON 

INSERT [dbo].[Perfil] ([ID_PERFIL], [NM_PERFIL], [DT_LIMITE]) VALUES (1, N'(Todos)', NULL)
SET IDENTITY_INSERT [dbo].[Perfil] OFF
SET IDENTITY_INSERT [dbo].[Processo] ON 

INSERT [dbo].[Processo] ([ID_PROCESSO], [NM_PROCESSO], [DESC_PROCESSO], [FL_ATIVO], [DT_INCLUSAO]) VALUES (4, N'POLÍTICA DE SEGURANÇA DE TECNOLOGIA DA INFORMAÇÃO – PSTI', N'http://h-solicitacoesapi.educacao.intragov/demoImages/f28f7fa6-1218-4330-84c3-ab701b476402.rtf', 1, CAST(N'2020-01-30T12:55:00' AS SmallDateTime))
SET IDENTITY_INSERT [dbo].[Processo] OFF
INSERT [dbo].[Processo_Perfil] ([ID_PROCESSO], [ID_PERFIL], [END_ARQ_DOC], [FL_BLOQ]) VALUES (4, 1, N'http://h-solicitacoesapi.educacao.intragov/demoImages/2e3c981b-271e-4578-9069-6a91df954b1b.rtf', 1)
ALTER TABLE [dbo].[Aceite]  WITH CHECK ADD  CONSTRAINT [FK_Aceite_Processo] FOREIGN KEY([ID_PROCESSO])
REFERENCES [dbo].[Processo] ([ID_PROCESSO])
GO
ALTER TABLE [dbo].[Aceite] CHECK CONSTRAINT [FK_Aceite_Processo]
GO
ALTER TABLE [dbo].[Aceite]  WITH CHECK ADD  CONSTRAINT [FK_Aceite_Usuario] FOREIGN KEY([CPF_USUARIO])
REFERENCES [dbo].[Usuario] ([CPF_USUARIO])
GO
ALTER TABLE [dbo].[Aceite] CHECK CONSTRAINT [FK_Aceite_Usuario]
GO
ALTER TABLE [dbo].[LogAcesso]  WITH CHECK ADD  CONSTRAINT [FK_LogAcesso_Processo] FOREIGN KEY([ID_PROCESSO])
REFERENCES [dbo].[Processo] ([ID_PROCESSO])
GO
ALTER TABLE [dbo].[LogAcesso] CHECK CONSTRAINT [FK_LogAcesso_Processo]
GO
ALTER TABLE [dbo].[LogAcesso]  WITH CHECK ADD  CONSTRAINT [FK_LogAcesso_Usuario] FOREIGN KEY([CPF_USUARIO])
REFERENCES [dbo].[Usuario] ([CPF_USUARIO])
GO
ALTER TABLE [dbo].[LogAcesso] CHECK CONSTRAINT [FK_LogAcesso_Usuario]
GO
ALTER TABLE [dbo].[Processo_Perfil]  WITH CHECK ADD  CONSTRAINT [FK_Processo_Perfil_Perfil] FOREIGN KEY([ID_PERFIL])
REFERENCES [dbo].[Perfil] ([ID_PERFIL])
GO
ALTER TABLE [dbo].[Processo_Perfil] CHECK CONSTRAINT [FK_Processo_Perfil_Perfil]
GO
ALTER TABLE [dbo].[Processo_Perfil]  WITH CHECK ADD  CONSTRAINT [FK_Processo_Perfil_Processo] FOREIGN KEY([ID_PROCESSO])
REFERENCES [dbo].[Processo] ([ID_PROCESSO])
GO
ALTER TABLE [dbo].[Processo_Perfil] CHECK CONSTRAINT [FK_Processo_Perfil_Processo]
GO
ALTER TABLE [dbo].[Usuario]  WITH CHECK ADD  CONSTRAINT [FK_Usuario_Cargo] FOREIGN KEY([ID_CARGO])
REFERENCES [dbo].[Cargo] ([ID_CARGO])
GO
ALTER TABLE [dbo].[Usuario] CHECK CONSTRAINT [FK_Usuario_Cargo]
GO
ALTER TABLE [dbo].[Usuario]  WITH CHECK ADD  CONSTRAINT [FK_Usuario_Departamento] FOREIGN KEY([ID_DEPARTAMENTO])
REFERENCES [dbo].[Departamento] ([ID_DEPARTAMENTO])
GO
ALTER TABLE [dbo].[Usuario] CHECK CONSTRAINT [FK_Usuario_Departamento]
GO
ALTER TABLE [dbo].[Usuario_Perfil]  WITH CHECK ADD  CONSTRAINT [FK_Usuario_Perfil_Perfil] FOREIGN KEY([ID_PERFIL])
REFERENCES [dbo].[Perfil] ([ID_PERFIL])
GO
ALTER TABLE [dbo].[Usuario_Perfil] CHECK CONSTRAINT [FK_Usuario_Perfil_Perfil]
GO
ALTER TABLE [dbo].[Usuario_Perfil]  WITH CHECK ADD  CONSTRAINT [FK_Usuario_Perfil_Usuario] FOREIGN KEY([CPF_USUARIO])
REFERENCES [dbo].[Usuario] ([CPF_USUARIO])
GO
ALTER TABLE [dbo].[Usuario_Perfil] CHECK CONSTRAINT [FK_Usuario_Perfil_Usuario]
GO
ALTER TABLE [dbo].[Usuario_PrimeiroAcesso]  WITH CHECK ADD  CONSTRAINT [FK_Usuario_PrimeiroAcesso_Processo] FOREIGN KEY([ID_PROCESSO])
REFERENCES [dbo].[Processo] ([ID_PROCESSO])
GO
ALTER TABLE [dbo].[Usuario_PrimeiroAcesso] CHECK CONSTRAINT [FK_Usuario_PrimeiroAcesso_Processo]
GO
ALTER TABLE [dbo].[Usuario_PrimeiroAcesso]  WITH CHECK ADD  CONSTRAINT [FK_Usuario_PrimeiroAcesso_Usuario] FOREIGN KEY([CPF_USUARIO])
REFERENCES [dbo].[Usuario] ([CPF_USUARIO])
GO
ALTER TABLE [dbo].[Usuario_PrimeiroAcesso] CHECK CONSTRAINT [FK_Usuario_PrimeiroAcesso_Usuario]
GO
