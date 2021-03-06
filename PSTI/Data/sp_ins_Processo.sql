USE [AceiteEletronico]
GO
/****** Object:  StoredProcedure [dbo].[sp_ins_Processo]    Script Date: 31/01/2020 15:19:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author     :	Wilson de Oliveira Junior
-- Create date: 31/01/2020
-- Description:	Insere um novo processo de aceite
-- Change date: 
-- Change for : 
-- =============================================
ALTER PROCEDURE [dbo].[sp_ins_Processo]
	@NM_PROCESSO		VARCHAR(100), 
	@DESC_PROCESSO		VARCHAR(MAX), 
	@ID		INT OUTPUT
AS
BEGIN	
	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM Processo WHERE NM_PROCESSO = @NM_PROCESSO)
	BEGIN
		RAISERROR ('O processo informado já existe!',16, 1);  
		RETURN 1
	END


	INSERT INTO Processo(NM_PROCESSO, DESC_PROCESSO, DT_INCLUSAO, FL_ATIVO)
	VALUES (@NM_PROCESSO, @DESC_PROCESSO, GETDATE(), 1)

	SELECT @ID = @@IDENTITY

END
GO 
GO

SELECT * FROM Processo




GO
DECLARE @ID INT 
EXEC sp_ins_Processo 
	@NM_PROCESSO = 'Aceite do uso do WIFI'
	,@DESC_PROCESSO = 'http://h-solicitacoesapi.educacao.intragov/demoImages/f28f7fa6-1218-4330-84c3-ab701b476402.rtf'
	,@ID = @ID