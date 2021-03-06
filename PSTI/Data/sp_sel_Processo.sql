USE [AceiteEletronico]
GO
/****** Object:  StoredProcedure [dbo].[sp_sel_Processo]    Script Date: 31/01/2020 15:25:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author     :	Wilson de Oliveira Junior
-- Create date: 31/01/2020
-- Description:	procedure que lista os processos do sistema
-- Change date: 
-- Change for : 
-- =============================================
ALTER PROCEDURE [dbo].[sp_sel_Processo]
	@ID_PROCESSO	INT = 0,
	@CPF_USUARIO	VARCHAR(11) = NULL,	
	@OPCAO			INT
AS
BEGIN	
	SET NOCOUNT ON;
	--> validando o campo módulo
	IF(@OPCAO <> 1 AND @OPCAO <> 2 AND @OPCAO <> 3)
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
	
	IF @OPCAO = 1
	BEGIN
		---> listando todos os processo ativos para a aplicação cliente
		SELECT P.ID_PROCESSO
			,P.NM_PROCESSO
			,P.FL_ATIVO
			,P.DT_INCLUSAO
		FROM Processo AS P 
		WHERE P.FL_ATIVO = 1
		ORDER BY P.NM_PROCESSO
		RETURN 0
	END
	IF @OPCAO = 2
	BEGIN
		--> identificando o processo pelo id
		SELECT P1.ID_PROCESSO		--00
			,P1.NM_PROCESSO			--01
			,P1.DESC_PROCESSO		--02
			,P1.FL_ATIVO			--03
			,P1.DT_INCLUSAO			--04
			,P2.END_ARQ_DOC			--05
			,P2.FL_BLOQ				--08
			,P3.NM_PERFIL			--09
		FROM Processo AS P1 
		INNER JOIN Processo_Perfil AS P2 ON P2.ID_PROCESSO = P1.ID_PROCESSO
		INNER JOIN Perfil AS P3 ON P3.ID_PERFIL = P3.ID_PERFIL
		WHERE P1.ID_PROCESSO = @ID_PROCESSO  AND P1.FL_ATIVO = 1
		RETURN 0
	END
	IF @OPCAO = 3
	BEGIN
		--> identificando todos os processo ativos
		SELECT P1.ID_PROCESSO		--00
			,P1.NM_PROCESSO			--01
			,P1.DESC_PROCESSO		--02
			,P1.FL_ATIVO			--03
			,P1.DT_INCLUSAO			--04
			,P2.END_ARQ_DOC			--05
			--,P2.DT_INICIO			--06
			--,P2.DT_FIM				--07
			,P2.FL_BLOQ				--08
			,P3.NM_PERFIL			--09
		FROM Processo AS P1 
		INNER JOIN Processo_Perfil AS P2 ON P2.ID_PROCESSO = P1.ID_PROCESSO
		INNER JOIN Perfil AS P3 ON P3.ID_PERFIL = P3.ID_PERFIL
		--WHERE P2.DT_INICIO <= GETDATE() AND P2.DT_FIM >= GETDATE() AND P1.FL_ATIVO = 1
		RETURN 0
	END
END
go
go
go
EXEC sp_sel_Processo @OPCAO = 1

EXEC sp_sel_Processo @OPCAO = 2, @ID_PROCESSO = 4
