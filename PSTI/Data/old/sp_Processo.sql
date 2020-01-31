USE AceiteEletronico
go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS(SELECT * FROM SYS.procedures WHERE name = 'sp_ins_Processo')
	DROP PROCEDURE sp_ins_Processo
GO
-- =============================================
-- Author     :	Wilson de Oliveira Junior
-- Create date: 31/01/2020
-- Description:	Insere um novo processo de aceite
-- Change date: 
-- Change for : 
-- =============================================
CREATE PROCEDURE dbo.sp_ins_Processo
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
--------------------------------------------------------
------> testando a procedure de novo processo <---------
--------------------------------------------------------
DECLARE @ID INT 
--EXEC sp_ins_Processo @NM_PROCESSO = 'POLÍTICA DE SEGURANÇA DE TECNOLOGIA DA INFORMAÇÃO – PSTI', @DESC_PROCESSO = 'http://h-solicitacoesapi.educacao.intragov/demoImages/f28f7fa6-1218-4330-84c3-ab701b476402.rtf', @ID = @ID OUTPUT 
PRINT @ID
GO
GO
IF EXISTS(SELECT * FROM SYS.procedures WHERE name = 'sp_upd_Processo')
	DROP PROCEDURE sp_upd_Processo
GO
-- =============================================
-- Author     :	Wilson de Oliveira Junior
-- Create date: 31/01/2020
-- Description:	atualiza um processo existente
-- Change date: 
-- Change for : 
-- =============================================
CREATE PROCEDURE dbo.sp_upd_Processo
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
go
--------------------------------------------------------
------> testando a procedure de atualiza processo <---------
--------------------------------------------------------
--EXEC sp_upd_Processo @ID_PROCESSO = 44, @NM_PROCESSO = 'POLÍTICA DE SEGURANÇA DE TECNOLOGIA DA INFORMAÇÃO – PSTI', @DESC_PROCESSO = 'http://h-solicitacoesapi.educacao.intragov/demoImages/f28f7fa6-1218-4330-84c3-ab701b476402.rtf'
GO
GO
IF EXISTS(SELECT * FROM SYS.procedures WHERE name = 'sp_del_Processo')
	DROP PROCEDURE sp_del_Processo
GO
-- =============================================
-- Author     :	Wilson de Oliveira Junior
-- Create date: 31/01/2020
-- Description:	excluir um processo existente
-- Change date: 
-- Change for : 
-- =============================================
CREATE PROCEDURE dbo.sp_del_Processo
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
--------------------------------------------------------
------> testando a procedure de exclusão de processo <---------
--------------------------------------------------------
--EXEC sp_del_Processo @ID_PROCESSO = 4
--SELECT * FROM Processo WHERE ID_PROCESSO = 4
GO
GO
GO
IF EXISTS(SELECT * FROM SYS.procedures WHERE name = 'sp_del_Processo')
	DROP PROCEDURE sp_sel_Processo
GO
-- =============================================
-- Author     :	Wilson de Oliveira Junior
-- Create date: 31/01/2020
-- Description:	procedure que lista os processos do sistema
-- Change date: 
-- Change for : 
-- =============================================
CREATE PROCEDURE dbo.sp_sel_Processo
	@ID_PROCESSO	INT = 0,
	@MODULO			INT
AS
BEGIN	
	SET NOCOUNT ON;
	--> validando o campo módulo
	IF(@MODULO <> 1 AND @MODULO <> 2 AND @MODULO <> 3)
	BEGIN
		RAISERROR ('O valor informado para módulo não é válido!',16, 1);  
		RETURN 1
	END
	--> validando o id de processo
	IF @ID_PROCESSO<> 0 AND NOT EXISTS(SELECT 1 FROM Processo WHERE ID_PROCESSO = @ID_PROCESSO)
	BEGIN
		RAISERROR ('O processo informado não existe!',16, 1);  
		RETURN 1
	END
	
	IF @MODULO = 1
	BEGIN
		---> listando todos os processo
		SELECT P.ID_PROCESSO
			,P.NM_PROCESSO
			,P.FL_ATIVO
			,P.DT_INCLUSAO
		FROM Processo AS P ORDER BY P.NM_PROCESSO
		RETURN 0
	END
	IF @MODULO = 2
	BEGIN
		--> identificando o processo pelo id
		SELECT P1.ID_PROCESSO		--00
			,P1.NM_PROCESSO			--01
			,P1.DESC_PROCESSO		--02
			,P1.FL_ATIVO			--03
			,P1.DT_INCLUSAO			--04
			,P2.END_ARQ_DOC			--05
			,P2.DT_INICIO			--06
			,P2.DT_FIM				--07
			,P2.FL_BLOQ				--08
			,P3.NM_PERFIL			--09
		FROM Processo AS P1 
		INNER JOIN Processo_Perfil AS P2 ON P2.ID_PROCESSO = P1.ID_PROCESSO
		INNER JOIN Perfil AS P3 ON P3.ID_PERFIL = P3.ID_PERFIL
		WHERE P1.ID_PROCESSO = @ID_PROCESSO 
		RETURN 0
	END
	IF @MODULO = 3
	BEGIN
		--> identificando todos os processo ativos
		SELECT P1.ID_PROCESSO		--00
			,P1.NM_PROCESSO			--01
			,P1.DESC_PROCESSO		--02
			,P1.FL_ATIVO			--03
			,P1.DT_INCLUSAO			--04
			,P2.END_ARQ_DOC			--05
			,P2.DT_INICIO			--06
			,P2.DT_FIM				--07
			,P2.FL_BLOQ				--08
			,P3.NM_PERFIL			--09
		FROM Processo AS P1 
		INNER JOIN Processo_Perfil AS P2 ON P2.ID_PROCESSO = P1.ID_PROCESSO
		INNER JOIN Perfil AS P3 ON P3.ID_PERFIL = P3.ID_PERFIL
		WHERE P2.DT_INICIO <= GETDATE() AND P2.DT_FIM >= GETDATE() AND P1.FL_ATIVO = 1
		RETURN 0
	END
END
go