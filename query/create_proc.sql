USE ClinicaCavalcante;
GO

-- Atualiza o valor de um orcamento: quando um procedimento é add ou del
CREATE PROCEDURE [dbo].[attVlOrcamento]
@vl NUMERIC (5,2),
@id_procedimento INT,
@id_orcamento INT,
@tipo_opercacao INT -- 1 para '+' ou -1 para '-'
AS

BEGIN
	DECLARE @cd_matricula_cli VARCHAR(20)
	SET @cd_matricula_cli = (SELECT cd_carteirinha_paciente FROM Orcamento WHERE id = @id_orcamento)
	
	SET @vl = [dbo].[getVlProcedimento](@id_procedimento, @cd_matricula_cli) * @tipo_opercacao
	
	UPDATE [dbo].[Orcamento]
		SET vl_total = ((SELECT vl_total FROM [dbo].[Orcamento] WHERE id = @id_orcamento) + @vl)
		WHERE id = @id_orcamento
END
GO

CREATE PROCEDURE [dbo].[attQtdItem]
@id_estoque INT,
@tp_mov CHAR(1),
@qtd_mov INT,
@erro INT OUTPUT,
@qtd_item INT OUTPUT
AS

BEGIN
	if @tp_mov = '-'
		BEGIN
			SET @erro = [dbo].[getDisponibilidadeEstoque](@id_estoque, @qtd_mov)
			if @erro = 1
				SET @erro = -1
			SET @qtd_item = (SELECT qtd_item FROM Estoque WHERE id = @id_estoque) - @qtd_mov
		END
	else
		BEGIN
			SET @qtd_item = (SELECT qtd_item FROM Estoque WHERE id = @id_estoque) + @qtd_mov
		END
	return
END
GO
