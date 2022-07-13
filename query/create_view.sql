USE ClinicaCavalcante
GO

CREATE VIEW [dbo].[Clientes] AS
SELECT pes.*, cli.dt_cadastro, cli.sexo, cli.tel, cp.cd_matricula, cp.nm_convenio, cp.sigla_convenio
FROM [dbo].[Pessoa] AS pes
	INNER JOIN [dbo].[Cliente] AS cli
		ON pes.id = cli.id 
	INNER JOIN [dbo].[Carteirinha_Paciente] AS cp
		ON cp.id_cliente = cli.id
GO


CREATE VIEW [dbo].[RecepsAdms] AS
SELECT pes.*, fun.login, fun.senha, ra.nm_cargo
FROM [dbo].[Pessoa] AS pes
	INNER JOIN [dbo].[Funcionario] AS fun
		ON pes.id = fun.id 
	INNER JOIN [dbo].[Recep_Adm] AS ra
		ON ra.id = fun.id
GO


CREATE VIEW [dbo].[ProfissionalSaude] AS
SELECT pes.*, fun.login, fun.senha, ps.cd_crm, esp.nm_especialidade
FROM [dbo].[Pessoa] AS pes
	INNER JOIN [dbo].[Funcionario] AS fun
		ON pes.id = fun.id 
	INNER JOIN [dbo].[Profis_Saude] AS ps
		ON ps.id = fun.id
	INNER JOIN [dbo].[Profis_Saude_Especialdade] AS pse
		ON pse.id_profis_saude = ps.id
	INNER JOIN [dbo].[Especialidade] AS esp
		ON esp.sigla = pse.sigla_especialidade
GO


CREATE VIEW [dbo].[Agendas] AS
SELECT agen.id, agen.dt_inicial, agen.dt_final, agen.qtd_tempo_consulta, agen.id_profis_saude, 
	ps.nm_pessoa AS nm_profis_saude, ps.cd_crm, agen.sigla_especialidade, ps.nm_especialidade,
	agen.id_recep_adm, ra.nm_pessoa AS nm_responsavel, ra.nm_cargo
FROM [dbo].[Agenda] AS agen
	INNER JOIN [dbo].[ProfissionalSaude] AS ps
		ON agen.id_profis_saude = ps.id
	INNER JOIN [dbo].[RecepsAdms] AS ra
		ON agen.id_recep_adm = ra.id
GO


CREATE VIEW [dbo].[Consultas] AS
SELECT cons.*, cli.id AS id_paciente, cli.nm_pessoa AS nm_paciente, cli.dt_nascimento AS dt_nascimento_paciente, cli.nm_convenio AS nm_convenio_paciente,
	agen.id_profis_saude, agen.nm_profis_saude, agen.cd_crm, agen.sigla_especialidade, nm_especialidade,
	ra.nm_pessoa AS nm_responsavel_agendamento
FROM [dbo].[Consulta] AS cons
	INNER JOIN [dbo].[Clientes] AS cli
		ON cons.cd_carteirinha_paciente = cli.cd_matricula
	INNER JOIN [dbo].[Agendas] AS agen
		ON cons.id_agenda = agen.id
	INNER JOIN [dbo].[RecepsAdms] AS ra
		ON cons.id_recep_adm = ra.id
GO


CREATE VIEW [dbo].[Procedimentos_Consultas] AS
SELECT cons.id AS id_consulta, cons.dt_consulta, cons.hr_consulta,
	pro.id AS id_procedimento, pro.nm_procedimento, pro.vl_procedimento
FROM [dbo].[Consulta] AS cons
	INNER JOIN [dbo].[Procedimento_Consulta] AS pc
		ON cons.id = pc.id_consulta
	INNER JOIN [dbo].[Procedimento] AS pro
		ON pc.id_procedimento = pro.id
GO


CREATE VIEW [dbo].[Orcamentos] AS
SELECT orca.*, pro.id AS id_procedimento, pro.nm_procedimento, pro.sigla_especialidade
FROM [dbo].[Orcamento] AS orca
	INNER JOIN [dbo].[Procedimento_Orcamento] AS po
		ON orca.id = po.id_orcamento
	INNER JOIN [dbo].[Procedimento] AS pro
		ON po.id_procedimento = pro.id
GO


CREATE VIEW [dbo].[Estoques] AS
SELECT est.id AS id_estoque, est.id_item, it.nm_item, it.ds_item, est.qtd_item, est.id_unidade
FROM [dbo].[Estoque] AS est		
	INNER JOIN [dbo].[Item] AS it
		ON est.id_item = it.id
GO


CREATE VIEW [dbo].[ProcedimentosRealizados] AS
SELECT pro.id AS id_procedimento, pro.nm_procedimento, pro.sigla_especialidade as sigla_especialiadade_procedimento,
	ps.id AS id_profis_saude, ps.nm_pessoa AS nm_profis_saude
FROM [dbo].[Procedimento] AS pro
	INNER JOIN [dbo].[Procedimento_Profis_Saude] AS pps
		ON pro.id = pps.id_procedimento
	INNER JOIN [dbo].[ProfissionalSaude] AS ps
		ON ps.id = pps.id_profis_saude
GO