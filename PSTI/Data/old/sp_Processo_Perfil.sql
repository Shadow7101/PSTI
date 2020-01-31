USE AceiteEletronico
go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS(SELECT * FROM SYS.procedures WHERE name = 'sp_ins_Processo_Perfil')
	DROP PROCEDURE sp_ins_Processo_Perfil
GO
-- =========================================================
-- Author     :	Wilson de Oliveira Junior
-- Create date: 31/01/2020
-- Description:	Insere um novo processo de Processo_Perfil
-- Change date: 
-- Change for : 
-- =========================================================
CREATE PROCEDURE dbo.sp_ins_Processo_Perfil
	@ID_PROCESSO	INT,
	@ID_PERFIL		INT,
	@END_ARQ_DOC   VARCHAR(255),
	@DT_INICIO     DATE,
	@DT_FIM		   DATE,
	@FL_BLOQ       BIT
AS
BEGIN	
	SET NOCOUNT ON;
	IF EXISTS(SELECT 1 FROM Processo_Perfil WHERE ID_PROCESSO = @ID_PROCESSO AND ID_PERFIL = @ID_PERFIL)
	BEGIN
		RAISERROR ('O item informado já existe!',16, 1);  
		RETURN 1
	END
	IF NOT EXISTS(SELECT 1 FROM Processo WHERE ID_PROCESSO = @ID_PROCESSO)
	BEGIN
		RAISERROR ('O processo informado não existe!',16, 1);  
		RETURN 1
	END
	IF NOT EXISTS(SELECT 1 FROM Perfil WHERE ID_PERFIL = @ID_PERFIL)
	BEGIN
		RAISERROR ('O perfil informado não existe!',16, 1);  
		RETURN 1
	END

	INSERT INTO Processo_Perfil(ID_PROCESSO, ID_PERFIL, END_ARQ_DOC, DT_INICIO, DT_FIM, FL_BLOQ)
	VALUES (@ID_PROCESSO, @ID_PERFIL, @END_ARQ_DOC, @DT_INICIO, @DT_FIM, @FL_BLOQ)
END
GO
GO
/*------------------------------------------------------
------> testando a procedure de Processo_Perfil <-------
--------------------------------------------------------
EXEC sp_ins_Processo_Perfil 
	 @ID_PROCESSO = 4
	,@ID_PERFIL = 1
	,@END_ARQ_DOC = 'http://h-solicitacoesapi.educacao.intragov/demoImages/2e3c981b-271e-4578-9069-6a91df954b1b.rtf'
	,@DT_INICIO = '2020-01-01'
	,@DT_FIM = '2020-02-29'
	,@FL_BLOQ = 1
	*/
GO
GO
IF EXISTS(SELECT * FROM SYS.procedures WHERE name = 'sp_upd_Processo_Perfil')
	DROP PROCEDURE sp_upd_Processo_Perfil
GO
-- =============================================
-- Author     :	Wilson de Oliveira Junior
-- Create date: 31/01/2020
-- Description:	Insere um novo Processo_Perfil
-- Change date: 
-- Change for : 
-- =============================================
CREATE PROCEDURE dbo.sp_upd_Processo_Perfil
	@ID_PROCESSO	INT,
	@ID_PERFIL		INT,
	@END_ARQ_DOC   VARCHAR(255),
	@DT_INICIO     DATE,
	@DT_FIM		   DATE,
	@FL_BLOQ       BIT
AS
BEGIN	
	SET NOCOUNT ON;
	IF NOT EXISTS(SELECT 1 FROM Processo_Perfil WHERE ID_PROCESSO = @ID_PROCESSO AND ID_PERFIL = @ID_PERFIL)
	BEGIN
		RAISERROR ('O item informado não existe!',16, 1);  
		RETURN 1
	END
	IF NOT EXISTS(SELECT 1 FROM Processo WHERE ID_PROCESSO = @ID_PROCESSO)
	BEGIN
		RAISERROR ('O processo informado não existe!',16, 1);  
		RETURN 1
	END
	IF NOT EXISTS(SELECT 1 FROM Perfil WHERE ID_PERFIL = @ID_PERFIL)
	BEGIN
		RAISERROR ('O perfil informado não existe!',16, 1);  
		RETURN 1
	END

	UPDATE Processo_Perfil SET
		 END_ARQ_DOC  = @END_ARQ_DOC
		,DT_INICIO    = @DT_INICIO
		,DT_FIM       = @DT_FIM
		,FL_BLOQ      = @FL_BLOQ
	WHERE ID_PROCESSO = @ID_PROCESSO 
	    AND ID_PERFIL = @ID_PERFIL 

END
GO
GO
------------------------------------------------------
------> testando a procedure de Processo_Perfil <-------
--------------------------------------------------------
EXEC sp_upd_Processo_Perfil 
	 @ID_PROCESSO = 4
	,@ID_PERFIL = 1
	,@END_ARQ_DOC = 'http://h-solicitacoesapi.educacao.intragov/demoImages/2e3c981b-271e-4578-9069-6a91df954b1b.rtf'
	,@DT_INICIO = '2020-01-01'
	,@DT_FIM = '2020-02-29'
	,@FL_BLOQ = 1
GO