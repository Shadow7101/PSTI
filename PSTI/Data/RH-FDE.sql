USE MASTER
GO
DROP DATABASE [AceiteEletronico]
GO
CREATE DATABASE [AceiteEletronico]
GO
USE [AceiteEletronico]
GO
-----------------------------------------------
-------------------> Processo <----------------
-----------------------------------------------
CREATE TABLE Processo (
	ID_PROCESSO INT IDENTITY(1,1) NOT NULL,
	CONSTRAINT Processo_PK PRIMARY KEY(ID_PROCESSO),
	NM_PROCESSO VARCHAR(100) NOT NULL,	
	DESC_PROCESSO VARCHAR(255) NOT NULL,
	DT_PROCESSO SMALLDATETIME NOT NULL DEFAULT (GETDATE()),
	FL_PROCESSO BIT DEFAULT(1)
)
GO
-------------------------------------------------------
-------> procedure que insere um novo processo <-------
-------------------------------------------------------
CREATE PROCEDURE sp_INS_Processo (
	@NM_PROCESSO VARCHAR(100),
	@DESC_PROCESSO VARCHAR(255),
	@ID_PROCESSO INT OUTPUT
) AS BEGIN
	
	INSERT Processo(NM_PROCESSO, DESC_PROCESSO) VALUES (@NM_PROCESSO, @DESC_PROCESSO)
	SELECT @ID_PROCESSO = @@IDENTITY
END
GO
--------------------------------------------------------
------> testando a procedure de novo processo <---------
--------------------------------------------------------
DECLARE @ID_PROCESSO INT 
EXEC sp_INS_Processo 
	@NM_PROCESSO = 'POLÍTICA DE SEGURANÇA DE TECNOLOGIA DA INFORMAÇÃO – PSTI',
	@DESC_PROCESSO = 'http://h-solicitacoesapi.educacao.intragov/demoImages/f28f7fa6-1218-4330-84c3-ab701b476402.rtf',
	@ID_PROCESSO = @ID_PROCESSO OUTPUT
	--PRINT @ID_PROCESSO
GO
------------------------------------------------------
---------------------> perfil <-----------------------
------------------------------------------------------
CREATE TABLE Perfil (
	ID_PERFIL INT IDENTITY(1,1) NOT NULL,
	CONSTRAINT Perfil_PK PRIMARY KEY(ID_PERFIL),
	NM_PERFIL VARCHAR(100) NOT NULL,
	CONSTRAINT Perfil_UN UNIQUE(NM_PERFIL),
	DT_PERFIL SMALLDATETIME NOT NULL DEFAULT (GETDATE())
)
GO
-------------------------------------------------------
-------> procedure que insere um novo perfil <-------
-------------------------------------------------------
CREATE PROCEDURE sp_INS_Perfil (
	@NM_PERFIL VARCHAR(100),
	@ID_PERFIL INT OUTPUT
) AS BEGIN
	IF NOT EXISTS(SELECT 1 FROM Perfil WHERE NM_PERFIL = @NM_PERFIL)
	BEGIN
		INSERT Perfil(NM_PERFIL) VALUES (@NM_PERFIL);
		SELECT @ID_PERFIL = @@IDENTITY
	END
END
GO
--------------------------------------------------------
------> testando a procedure de novo perfil <---------
--------------------------------------------------------
DECLARE @ID_PERFIL INT 
EXEC sp_INS_Perfil 
	@NM_PERFIL = '(Todos)',
	@ID_PERFIL = @ID_PERFIL OUTPUT
	--PRINT @ID_PROCESSO
GO
------------------------------------------------------
------------------> Processo_Perfil <-----------------
------------------------------------------------------
CREATE TABLE Processo_Perfil (
	ID_PROCESSO INT NOT NULL,
	ID_PERFIL   INT NOT NULL,
	CONSTRAINT Processo_Perfil_PK PRIMARY KEY(ID_PROCESSO,ID_PERFIL),
	CONSTRAINT Processo_Perfil_FK_1 FOREIGN KEY (ID_PROCESSO) REFERENCES Processo (ID_PROCESSO),
	CONSTRAINT Processo_Perfil_FK_2 FOREIGN KEY (ID_PERFIL) REFERENCES Perfil (ID_PERFIL),
	END_ARQ_DOC VARCHAR(250) NULL,
	DT_INICIO SMALLDATETIME NULL,
	DT_FIM SMALLDATETIME NULL,
	FL_BLOQ BIT NULL
)
GO
-------------------------------------------------------
-------> procedure que insere um novo perfil <-------
-------------------------------------------------------
CREATE PROCEDURE sp_INS_Processo_Perfil (
	@ID_PROCESSO INT,
	@ID_PERFIL INT,
	@END_ARQ_DOC VARCHAR(255),
	@DT_INICIO DATE,
	@DT_FIM DATE,
	@FL_BLOQ BIT
) AS BEGIN
	IF EXISTS(SELECT 1 FROM Processo_Perfil WHERE ID_PROCESSO = @ID_PROCESSO AND ID_PERFIL = @ID_PERFIL)
	BEGIN
		UPDATE Processo_Perfil SET
			END_ARQ_DOC = @END_ARQ_DOC,
			DT_INICIO	= @DT_INICIO,
			DT_FIM		= @DT_FIM,
			FL_BLOQ		= @FL_BLOQ
		WHERE ID_PROCESSO = @ID_PROCESSO AND ID_PERFIL = @ID_PERFIL
	END
	ELSE
	BEGIN
		INSERT Processo_Perfil(ID_PROCESSO, ID_PERFIL, END_ARQ_DOC, DT_INICIO, DT_FIM, FL_BLOQ) 
		VALUES (@ID_PROCESSO, @ID_PERFIL, @END_ARQ_DOC, @DT_INICIO, @DT_FIM, @FL_BLOQ);
	END
END
GO
---------------------------------------------------------------
------> testando a procedure de novo processo perfil <---------
---------------------------------------------------------------
EXEC sp_INS_Processo_Perfil 
	@ID_PROCESSO = 1,
	@ID_PERFIL =1,
	@END_ARQ_DOC = 'http://h-solicitacoesapi.educacao.intragov/demoImages/2e3c981b-271e-4578-9069-6a91df954b1b.rtf',
	@DT_INICIO = '2020-01-01',
	@DT_FIM = '2020-02-29',
	@FL_BLOQ = 1
GO

---------------------------------------------------------------
----------------------> EXIBE PROCESSO <-----------------------
---------------------------------------------------------------
CREATE PROCEDURE sp_SEL_Processo (
	@ID_PROCESSO INT = 0
) AS SELECT P1.ID_PROCESSO
		,P1.NM_PROCESSO
		,P1.DESC_PROCESSO
		,P2.END_ARQ_DOC
		,P2.FL_BLOQ
		,P3.NM_PERFIL
FROM Processo AS P1
INNER JOIN Processo_Perfil AS P2 ON P2.ID_PROCESSO = P1.ID_PROCESSO
INNER JOIN Perfil AS P3 ON P3.ID_PERFIL = P2.ID_PERFIL
WHERE (P1.ID_PROCESSO = @ID_PROCESSO) OR
(@ID_PROCESSO = 0 AND P2.DT_INICIO <= GETDATE() AND P2.DT_FIM >= GETDATE())
go
GO
------------------------------------------------
------------------> Usuario <-------------------
------------------------------------------------
CREATE TABLE Usuario (
	CPF_USUARIO  CHAR(11) NOT NULL,
	CONSTRAINT Usuario_PK PRIMARY KEY(CPF_USUARIO),
	NM_USUARIO VARCHAR(100) NOT NULL,
	DM_USUARIO VARCHAR(100) NOT NULL,
	EMAIL_USUARIO VARCHAR(100) NOT NULL,
	RAMAL_USUARIO VARCHAR(30) NOT NULL
)
GO
-----------------------------------------------------
-------> procedure que insere um novo usuario <------
-----------------------------------------------------
CREATE PROCEDURE sp_INS_Usuario (
	@CPF_USUARIO CHAR(11),
	@NM_USUARIO VARCHAR(100),
	@DM_USUARIO VARCHAR(100),
	@EMAIL_USUARIO VARCHAR(100),
	@RAMAL_USUARIO VARCHAR(30)
) AS BEGIN
	IF NOT EXISTS(SELECT 1 FROM Usuario WHERE CPF_USUARIO = @CPF_USUARIO)
	BEGIN
		INSERT Usuario (CPF_USUARIO, NM_USUARIO, DM_USUARIO, EMAIL_USUARIO, RAMAL_USUARIO)
		VALUES (@CPF_USUARIO, @NM_USUARIO, @DM_USUARIO, @EMAIL_USUARIO, @RAMAL_USUARIO)
	END
	/*ELSE
	BEGIN
		UPDATE Usuario SET 
			NM_USUARIO    = @NM_USUARIO,
			DM_USUARIO	  = @DM_USUARIO,
			EMAIL_USUARIO = @EMAIL_USUARIO,
			RAMAL_USUARIO = @RAMAL_USUARIO
		WHERE CPF_USUARIO = @CPF_USUARIO
	END*/
END
go
-----------------------------------------------------
-----------------> Usuario_Perfil <------------------
-----------------------------------------------------
CREATE TABLE Usuario_Perfil (
	CPF_USUARIO  CHAR(11) NOT NULL,
	ID_PERFIL   INT NOT NULL,
	CONSTRAINT Usuario_Perfil_PK PRIMARY KEY(CPF_USUARIO, ID_PERFIL),
	CONSTRAINT Usuario_Perfil_FK_1 FOREIGN KEY (CPF_USUARIO) REFERENCES Usuario(CPF_USUARIO),
	CONSTRAINT Usuario_Perfil_FK_2 FOREIGN KEY (ID_PERFIL) REFERENCES Perfil (ID_PERFIL),
)
GO
-----------------------------------------------------
--------------------> Aceite <----------------------
-----------------------------------------------------
CREATE TABLE Aceite (
	ID_ACEITE UNIQUEIDENTIFIER NOT NULL DEFAULT(NEWID()),
	CONSTRAINT Aceite_PK PRIMARY KEY(ID_ACEITE),
	CPF_USUARIO  CHAR(11) NOT NULL,
	ID_PROCESSO INT NOT NULL,
	CONSTRAINT Aceite_FK_1 FOREIGN KEY (CPF_USUARIO) REFERENCES Usuario(CPF_USUARIO),
	CONSTRAINT Aceite_FK_2 FOREIGN KEY (ID_PROCESSO) REFERENCES Processo (ID_PROCESSO),
	DT_ACEITE SMALLDATETIME NOT NULL DEFAULT (GETDATE()),
)
GO 
-----------------------------------------------------
-------> procedure que insere um novo aceite <-------
-----------------------------------------------------
CREATE PROCEDURE sp_INS_Aceite (
	@CPF_USUARIO CHAR(11),
	@ID_PROCESSO INT
) AS BEGIN

	INSERT Aceite(CPF_USUARIO, ID_PROCESSO) VALUES (@CPF_USUARIO, @ID_PROCESSO)

END
GO
-------------------------------------------------------
--------------------> LogAcesso <----------------------
-------------------------------------------------------
CREATE TABLE LogAcesso (
	ID_ACESSO BIGINT IDENTITY(1,1) NOT NULL,
	CONSTRAINT LogAcesso_PK PRIMARY KEY(ID_ACESSO),
	CPF_USUARIO CHAR(11) NOT NULL,
	CONSTRAINT LogAcesso_FK_1 FOREIGN KEY (CPF_USUARIO) REFERENCES Usuario(CPF_USUARIO),
	ID_PROCESSO INT NOT NULL,
	CONSTRAINT LogAcesso_FK_2 FOREIGN KEY (ID_PROCESSO) REFERENCES Processo (ID_PROCESSO),
	DT_ACESSO SMALLDATETIME NOT NULL DEFAULT (GETDATE()),
)
GO
-----------------------------------------------------
-------> procedure que insere um novo acesso <-------
-----------------------------------------------------
CREATE PROCEDURE sp_INS_LogAcesso (
	@CPF_USUARIO CHAR(11),
	@ID_PROCESSO INT
) AS BEGIN

	INSERT LogAcesso(CPF_USUARIO, ID_PROCESSO) VALUES (@CPF_USUARIO, @ID_PROCESSO)

END


GO


EXEC SP_SEL_PROCESSO