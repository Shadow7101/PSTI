USE [AceiteEletronico]
GO
/****** Object:  StoredProcedure [dbo].[sp_upd_Processo]    Script Date: 31/01/2020 12:10:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author     :	Wilson de Oliveira Junior
-- Create date: 31/01/2020
-- Description:	atualiza um processo existente
-- Change date: 
-- Change for : 
-- =============================================
CREATE PROCEDURE [dbo].[sp_upd_Processo]
	@ID_PROCESSO		INT,
	@NM_PROCESSO		VARCHAR(100), 
	@DESC_PROCESSO		VARCHAR(MAX)
AS
BEGIN	
	SET NOCOUNT ON;

	IF NOT EXISTS(SELECT 1 FROM Processo WHERE ID_PROCESSO = @ID_PROCESSO)
	BEGIN
		RAISERROR ('O processo informado não existe!',16, 1);  
		RETURN 1
	END

	UPDATE Processo SET
		NM_PROCESSO   = @NM_PROCESSO,
		DESC_PROCESSO = @DESC_PROCESSO
	WHERE ID_PROCESSO = @ID_PROCESSO
END
GO
