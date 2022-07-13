USE ClinicaCavalcante
GO

-- Pega o valor do procedimento com o desconto ja retirado
CREATE FUNCTION [dbo].[getVlProcedimento](@id_procedimento INT, @cd_matricula_cliente VARCHAR(20))
RETURNS NUMERIC(5,2)
AS

BEGIN
	DECLARE @vl_total NUMERIC(5,2), @qtd_desconto NUMERIC(5,2), @unidade_medida VARCHAR(20), @vl_procedimento NUMERIC(5,2)
	SET @vl_procedimento = (SELECT vl_procedimento FROM Procedimento WHERE id = @id_procedimento)

	SET @qtd_desconto = (SELECT qtd_desconto FROM Desconto_Procedimento
		WHERE id_procedimento = @id_procedimento
		AND sigla_convenio IN (SELECT sigla_convenio FROM Carteirinha_Paciente WHERE cd_matricula = @cd_matricula_cliente )
		AND nm_convenio IN ( SELECT nm_convenio FROM Carteirinha_Paciente WHERE cd_matricula = @cd_matricula_cliente )
		)

	if @qtd_desconto > 0.0
		BEGIN
			SET @unidade_medida = (SELECT unidade_medida FROM Desconto_Procedimento
				WHERE id_procedimento = @id_procedimento
				AND sigla_convenio IN (SELECT sigla_convenio FROM Carteirinha_Paciente WHERE cd_matricula = @cd_matricula_cliente )
				AND nm_convenio IN ( SELECT nm_convenio FROM Carteirinha_Paciente WHERE cd_matricula = @cd_matricula_cliente )
				)

			if @unidade_medida = 'porcent'
				SET @vl_total = @vl_procedimento - (@vl_procedimento * @qtd_desconto / 100)
			else
				SET @vl_total = @vl_procedimento - @qtd_desconto
		END
	else
		BEGIN
			SET @vl_total = @vl_procedimento
		END
	
	return @vl_total
END
GO

-- Verifica se tem itens disponiveis para uma diminuicao no estoque
CREATE FUNCTION [dbo].[getDisponibilidadeEstoque](@id_estoque INT, @qtd_itens_mov INT)
RETURNS INT
AS

BEGIN
	DECLARE @qtd_item INT,
			@erro INT

	SET @qtd_item = (SELECT qtd_item FROM Estoque WHERE id = @id_estoque)

	if @qtd_item < @qtd_itens_mov
		SET @erro = 1
	else
		SET @erro = 0

	return @erro
END
