USE [AceiteEletronico]
GO
/****** Object:  StoredProcedure [dbo].[sp_ins_Processo_Perfil]    Script Date: 31/01/2020 15:37:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author     :	Wilson de Oliveira Junior
-- Create date: 31/01/2020
-- Description:	procedure que insere um novo perfil no sistema
-- Change date: 
-- Change for : 
-- =============================================
ALTER PROCEDURE [dbo].[sp_ins_Processo_Perfil] 
	@ID_PROCESSO    INT, 
	@ID_PERFIL		INT,
	@END_ARQ_DOC	VARCHAR(255),
	@FL_BLOQ		BIT
AS
BEGIN
	SET NOCOUNT ON;
	--> CHECANDO SE O PROCESSO EXISTE
	IF NOT EXISTS(SELECT 1 FROM Processo WHERE ID_PROCESSO = @ID_PROCESSO)
	BEGIN
		RAISERROR('O processo especificado não foi encontrado!', 16,1)
		RETURN 1
	END
	
	--> CHECANDO SE O PERFIL EXISTE
	IF NOT EXISTS(SELECT 1 FROM Perfil WHERE ID_PERFIL = @ID_PERFIL)
	BEGIN
		RAISERROR('O Perfil especificado não foi encontrado!', 16,1)
		RETURN 1
	END
	
	--> INSERINDO O REGISTRO DE PROCESSO PERFIL
	INSERT INTO Processo_Perfil (ID_PROCESSO, ID_PERFIL, END_ARQ_DOC, FL_BLOQ)
	VALUES (@ID_PROCESSO, @ID_PERFIL, @END_ARQ_DOC, @FL_BLOQ)
END