USE [AceiteEletronico]
GO
/****** Object:  StoredProcedure [dbo].[sp_del_Processo]    Script Date: 31/01/2020 15:18:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author     :	Wilson de Oliveira Junior
-- Create date: 31/01/2020
-- Description:	excluir um processo existente
-- Change date: 
-- Change for : 
-- =============================================
ALTER PROCEDURE [dbo].[sp_del_Processo]
	@ID_PROCESSO		INT
AS
BEGIN	
	SET NOCOUNT ON;
	--> validando o id de processo
	IF NOT EXISTS(SELECT 1 FROM Processo WHERE ID_PROCESSO = @ID_PROCESSO)
	BEGIN
		RAISERROR ('O processo informado não existe!',16, 1);  
		RETURN 1
	END

	--desabilitando o registro de processo
	IF EXISTS(SELECT 1 FROM Processo WHERE ID_PROCESSO = @ID_PROCESSO AND FL_ATIVO <> 1)
	BEGIN
		UPDATE Processo SET FL_ATIVO = 1 WHERE ID_PROCESSO = @ID_PROCESSO
	END
	ELSE
	BEGIN
		UPDATE Processo SET FL_ATIVO = 0 WHERE ID_PROCESSO = @ID_PROCESSO
	END
END
go
go
go


EXEC sp_del_Processo @ID_PROCESSO = 5

SELECT * FROM Processo WHERE ID_PROCESSO = 5