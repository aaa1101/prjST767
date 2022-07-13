USE ClinicaCavalcante
GO

-- Quando a ficha cadastral é apagada, em cliente fica NULL
CREATE TRIGGER FichaCliente
	ON [dbo].[Ficha_Cadastral]
	INSTEAD OF DELETE
	AS
BEGIN
	UPDATE [dbo].[Cliente]
		SET id_ficha_cadastral = NULL
		WHERE id_ficha_cadastral IN (SELECT deleted.id FROM deleted)
	
	DELETE [dbo].[Ficha_Cadastral] 
		WHERE id IN (SELECT deleted.id FROM deleted)
END
GO

-- Quando uma especialidade é excluida, em procedimento fica NULL
CREATE TRIGGER Especialidade_NULL_Procedimento
	ON [dbo].[Especialidade]
	INSTEAD OF DELETE
	AS
BEGIN
	UPDATE [dbo].[Procedimento]
		SET sigla_especialidade = NULL
		WHERE sigla_especialidade IN (SELECT deleted.sigla FROM deleted)
	
	DELETE [dbo].[Especialidade] 
		WHERE sigla IN (SELECT deleted.sigla FROM deleted)
END
GO

-- Quando um tipo de agendamento é excluido, em procedimento fica NULL
CREATE TRIGGER TpAgendamento_NULL_Procedimento
	ON [dbo].[Tipo_Agendamento]
	INSTEAD OF DELETE
	AS
BEGIN
	UPDATE [dbo].[Procedimento]
		SET id_tipo_agendamento = NULL
		WHERE id_tipo_agendamento IN (SELECT deleted.id FROM deleted)
	
	DELETE [dbo].[Tipo_Agendamento]
		WHERE id IN (SELECT deleted.id FROM deleted)
END
GO

-- Quando RecepAdm é excluido, em consulta e agenda fica NULL
CREATE TRIGGER RecepAdm_NULL
	ON [dbo].[Recep_Adm]
	FOR DELETE
	AS
BEGIN
	UPDATE [dbo].[Consulta]
		SET id_recep_adm = NULL
		WHERE id_recep_adm IN (SELECT deleted.id FROM deleted)
	
	UPDATE [dbo].[Agenda]
		SET id_recep_adm = NULL
		WHERE id_recep_adm IN (SELECT deleted.id FROM deleted)
END
GO

-- Quando funcionario é excluido, em modificacao consulta fica NULL
CREATE TRIGGER Funcionaio_NULL
	ON [dbo].[Funcionario]
	FOR DELETE
	AS
BEGIN
	UPDATE [dbo].[Modificacao_Consulta]
		SET id_funcionario = NULL
		WHERE id_funcionario IN (SELECT deleted.id FROM deleted)
END
GO

-- Quando um procedimento é excluido, o valor total do orcamento atualiza 
CREATE TRIGGER DelProcedimentoOrcamento
	ON [dbo].[Procedimento_Orcamento]
	AFTER DELETE
	AS
BEGIN
	DECLARE @vl NUMERIC(5,2),
			@id_procedimento INT,
			@id_orcamento INT,
			@tipo_operacao INT

	SET @vl = 0.0
	SET @id_orcamento = (SELECT deleted.id_orcamento FROM deleted)
	SET @id_procedimento = (SELECT deleted.id_procedimento FROM deleted)
	SET @tipo_operacao = -1

	EXEC [dbo].[attVlOrcamento] @vl, @id_procedimento, @id_orcamento, @tipo_operacao;
END
GO

-- Quando uma movimentacao no caixa ocorre, seu valor final é atualizado
CREATE TRIGGER AddMovimentacaoCaixa
	ON [dbo].[Movimentacao_Caixa]
	AFTER INSERT
	AS
BEGIN
	DECLARE @id_caixa INT,
			@tp_mov CHAR(1),
			@vl NUMERIC (7,2),
			@vl_final NUMERIC (7,2)

	SET @id_caixa = (SELECT id_caixa FROM inserted)
	SET @tp_mov	= (SELECT ds_tipo_movimentacao FROM [dbo].[Movimentacao_Caixa] WHERE id_caixa = @id_caixa)
	SET @vl = (SELECT vl_movimentacao FROM [dbo].[Movimentacao_Caixa] WHERE id_caixa = @id_caixa)
	
	if @tp_mov = '+'
		SET @vl_final = (@vl + (SELECT vl_final FROM [dbo].[Caixa] WHERE id = @id_caixa))
	else
		SET @vl_final = ((SELECT vl_final FROM [dbo].[Caixa] WHERE id = @id_caixa) - @vl)

	UPDATE [dbo].[Caixa] 
		SET vl_final = @vl_final
		WHERE id = @id_caixa
END
GO

-- Quando ocorre uma movimentacao no estoque, atuzaliza a qtd de itens no estoque
CREATE TRIGGER AddMovimentacaoEstoque
	ON [dbo].[Movimentacao_Estoque]
	AFTER INSERT
	AS
BEGIN
	DECLARE @id_estoque INT,
			@dt_mov DATE,
			@hr_mov TIME,
			@id_recep_adm INT,
			@tp_mov CHAR(1),
			@qtd INT,
			@qtd_final INT,
			@erro INT

	SET @id_estoque = (SELECT id_estoque FROM inserted)
	SET @dt_mov = (SELECT dt_movimentacao FROM inserted)
	SET @hr_mov = (SELECT hr_movimentacao FROM inserted)
	SET @id_recep_adm = (SELECT id_recep_adm FROM inserted)

	SET @tp_mov	= (SELECT ds_tipo_movimentacao FROM [dbo].[Movimentacao_Estoque] WHERE id_estoque = @id_estoque AND dt_movimentacao = @dt_mov AND hr_movimentacao = @hr_mov AND id_recep_adm = @id_recep_adm)
	SET @qtd = (SELECT qtd_item FROM [dbo].[Movimentacao_Estoque] WHERE id_estoque = @id_estoque AND dt_movimentacao = @dt_mov AND hr_movimentacao = @hr_mov AND id_recep_adm = @id_recep_adm)
	
	EXEC [dbo].[attQtdItem] @id_estoque, @tp_mov, @qtd, @erro OUTPUT, @qtd_final OUTPUT
	
	if @erro = -1
		DELETE [dbo].[Movimentacao_Estoque] WHERE id_estoque = @id_estoque
		AND dt_movimentacao = @dt_mov
		AND hr_movimentacao = @hr_mov
		AND id_recep_adm = @id_recep_adm
	else
		UPDATE [dbo].[Estoque] 
			SET qtd_item = @qtd_final
			WHERE id = @id_estoque
END
GO