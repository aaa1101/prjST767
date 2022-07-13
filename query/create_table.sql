USE ClinicaCavalcante;

--Pessoa = { id, cpf, rg, nm_pessoa, dt_nascimeno, email }
CREATE TABLE [dbo].[Pessoa](
	[id] INT NOT NULL,
	[nm_pessoa] VARCHAR(80) NOT NULL,
	[dt_nascimento] DATE NULL,
	[cpf] VARCHAR(14) NULL,
	[rg] VARCHAR(14) NULL,
	[email] VARCHAR(256) NULL,
	CONSTRAINT [pk_pessoa] PRIMARY KEY CLUSTERED (
		[id] ASC
	)
)
GO


-- Funcionario = { id, login, senha, cd_tipo }
CREATE TABLE [dbo].[Funcionario](
	[id] INT NOT NULL,
	[login] VARCHAR(20) NOT NULL,
	[senha] VARCHAR(16) NULL,
	[cd_tipo] INT NOT NULL,
	CONSTRAINT [fk_funcionario] FOREIGN KEY ([id]) 
		REFERENCES [dbo].[Pessoa]([id])
		ON DELETE CASCADE,
	CONSTRAINT [pk_funcionario] PRIMARY KEY CLUSTERED(
		[id] ASC
	)
)
GO

--Recep_Adm = { id, nm_cargo }
CREATE TABLE [dbo].[Recep_Adm](
	[id] INT NOT NULL,
	[nm_cargo] VARCHAR(20) NOT NULL,
	CONSTRAINT [fk_recep_adm] FOREIGN KEY ([id]) 
		REFERENCES [dbo].[Funcionario]([id])
		ON DELETE CASCADE,
	CONSTRAINT [pk_recep_adm] PRIMARY KEY CLUSTERED(
		[id] ASC
	)
)
GO

-- Profis_Saude = { id, cd_crm}
CREATE TABLE [dbo].[Profis_Saude](
	[id] INT NOT NULL,
	[cd_crm] INT NOT NULL,
	CONSTRAINT [fk_profis_saude] FOREIGN KEY ([id]) 
		REFERENCES [dbo].[Funcionario]([id])
		ON DELETE CASCADE,
	CONSTRAINT [pk_profis_saude] PRIMARY KEY CLUSTERED(
		[id] ASC
	)
)
GO

-- Ficha_Cadastral = { id, cel, estado_civil, naturalidade, endereco, nm_bairro, nm_cidade, nm_uf, cep, nm_pai, nm_mae, nm_profissao }
CREATE TABLE [dbo].[Ficha_Cadastral](
	[id] INT NOT NULL,
	[cel] VARCHAR(14) NULL,
	[nm_mae] VARCHAR(80) NULL,
	[nm_pai] VARCHAR(80) NULL,
	[endereco] VARCHAR(50) NULL,
	[nm_bairro] VARCHAR(30) NULL,
	[nm_cidade] VARCHAR(30) NULL,
	[nm_uf] VARCHAR(20) NULL,
	[cep] VARCHAR(9) NULL,
	[estado_civil] VARCHAR(10) NULL,
	[naturalidade] VARCHAR(45) NULL,
	[nm_profissao] VARCHAR(50) NULL,
	CONSTRAINT [pk_ficha_cadastral] PRIMARY KEY CLUSTERED(
		[id] ASC
	)
)
GO

-- Cliente = { id, sexo, tel, dt_cadastro, id_ficha_cadastral }
CREATE TABLE [dbo].[Cliente](
	[id] INT NOT NULL,
	[sexo] CHAR NULL,
	[tel] VARCHAR(20) NULL,
	[dt_cadastro] DATE NULL,
	[id_ficha_cadastral] INT NULL,
	CONSTRAINT [pk_cliente] PRIMARY KEY CLUSTERED(
		[id] ASC
	),
	CONSTRAINT [fk_ficha_cadastral] FOREIGN KEY ([id_ficha_cadastral]) 
		REFERENCES [dbo].[Ficha_Cadastral]([id]),
)
GO

-- Especialidade = { sigla, nm_especialidade, ds_especialidade }
CREATE TABLE [dbo].[Especialidade](
	[sigla] VARCHAR(5) NOT NULL,
	[nm_especialidade] VARCHAR(50) NOT NULL,
	[ds_especialidade] VARCHAR(256) NULL,
	CONSTRAINT [pk_especialidade] PRIMARY KEY CLUSTERED(
		[sigla] ASC
	)
)
GO

-- Profis_Saude_Especialdade = { id_profis_saude, sigla_especialidade }
CREATE TABLE [dbo].[Profis_Saude_Especialdade](
	[id_profis_saude] INT NOT NULL,
	[sigla_especialidade] VARCHAR(5) NOT NULL,
	CONSTRAINT [fk_profis_saude_especialidade] FOREIGN KEY ([id_profis_saude]) 
		REFERENCES [dbo].[Profis_Saude]([id])
		ON DELETE CASCADE,
	CONSTRAINT [fk_especialidade_profis_saude] FOREIGN KEY ([sigla_especialidade]) 
		REFERENCES [dbo].[Especialidade]([sigla])
		ON DELETE CASCADE,
	CONSTRAINT [pk_profis_saude_especialdade] PRIMARY KEY CLUSTERED(
		[sigla_especialidade] ASC,
		[id_profis_saude] ASC
	)
)
GO

-- Tipo_Agendamento = { id, nm_tipo_agendamento, ds_tipo_agendamento, ds_restricao }
CREATE TABLE [dbo].[Tipo_Agendamento](
	[id] INT NOT NULL,
	[nm_tipo_agendamento] VARCHAR(30) NOT NULL,
	[ds_tipo_agendamento] VARCHAR(256) NULL,
	[ds_restricao] VARCHAR(256) NULL,
	CONSTRAINT [pk_tipo_agendamento] PRIMARY KEY CLUSTERED(
		[id] ASC
	)
)
GO

-- Tipo_Agendamento_Especialidade = { id_tipo_agendamento, sigla_especialidade, vl_atendimento }
CREATE TABLE [dbo].[Tipo_Agendamento_Especialidade](
	[sigla_especialidade] VARCHAR(5) NOT NULL,
	[id_tipo_agendamento] INT NOT NULL,
	[vl_atendimento] NUMERIC(5,2) NULL,
	CONSTRAINT [fk_tipo_agendamento_especialidade] FOREIGN KEY ([id_tipo_agendamento]) 
		REFERENCES [dbo].[Tipo_Agendamento]([id])
		ON DELETE CASCADE,
	CONSTRAINT [fk_especialidade_tipo_agendamento] FOREIGN KEY ([sigla_especialidade]) 
		REFERENCES [dbo].[Especialidade]([sigla])
		ON DELETE CASCADE,
	CONSTRAINT [pk_tipo_agendamento_especialidade] PRIMARY KEY CLUSTERED(
		[sigla_especialidade] ASC,
		[id_tipo_agendamento] ASC
	)
)
GO

-- Procedimento = { id, nm_procedimento, ds_procedimento, ds_pre_requisito, vl_procedimento, sigla_especialidade, id_tipo_atendimento }
CREATE TABLE [dbo].[Procedimento](
	[id] INT NOT NULL,
	[sigla_especialidade] VARCHAR(5) NULL,
	[nm_procedimento] VARCHAR(50) NOT NULL,
	[vl_procedimento] NUMERIC(5,2) NULL,
	[id_tipo_agendamento] INT NULL,
	[ds_pre_requisito] VARCHAR(256) NULL,
	[ds_descricao] VARCHAR(256) NULL,
	CONSTRAINT [fk_procedimento_especialidade] FOREIGN KEY ([sigla_especialidade]) 
		REFERENCES [dbo].[Especialidade]([sigla]),
	CONSTRAINT [fk_procedimento_tipo_agendamento] FOREIGN KEY ([id_tipo_agendamento]) 
		REFERENCES [dbo].[Tipo_Agendamento]([id]),
)
GO

CREATE CLUSTERED INDEX IX_CL_Procedimento ON [dbo].[Procedimento] ([sigla_especialidade], [id])
GO

ALTER TABLE [dbo].[Procedimento] ADD CONSTRAINT [pk_procedimento] PRIMARY KEY([id])
GO

--Procedimento_Profis_Saude = { id_procedimento, id_profis_saude }
CREATE TABLE [dbo].[Procedimento_Profis_Saude](
	[id_procedimento] INT NOT NULL,
	[id_profis_saude] INT NOT NULL,
	CONSTRAINT [fk_procedimento_profis_saude] FOREIGN KEY ([id_procedimento]) 
		REFERENCES [dbo].[Procedimento]([id])
		ON DELETE CASCADE,
	CONSTRAINT [fk_profis_saude_procedimento] FOREIGN KEY ([id_profis_saude]) 
		REFERENCES [dbo].[Profis_Saude]([id])
		ON DELETE CASCADE,
	CONSTRAINT [pk_procedimento_profis_saude] PRIMARY KEY CLUSTERED (
		[id_procedimento] ASC,
		[id_profis_saude] ASC
	)
)
GO

-- Agenda = { id, dt_inicial, dt_final, qtd_tempo_consulta, id_recep_adm, id_profis_saude, sigla_especialidade }
CREATE TABLE [dbo].[Agenda](
	[sigla_especialidade] VARCHAR(5) NOT NULL,
	[id_profis_saude] INT NOT NULL,
	[id] INT NOT NULL,
	[dt_inicial] DATE NULL,
	[dt_final] DATE NULL,
	[qtd_tempo_consulta] TIME NULL,
	[id_recep_adm] INT NULL,
	CONSTRAINT [fk_agenda_recep_adm] FOREIGN KEY ([id_recep_adm]) 
		REFERENCES [dbo].[Recep_Adm]([id]),
	CONSTRAINT [fk_agenda_profis_saude] FOREIGN KEY ([id_profis_saude]) 
		REFERENCES [dbo].[Recep_Adm]([id])
		ON DELETE CASCADE,
	CONSTRAINT [fk_agenda_especialidade] FOREIGN KEY ([sigla_especialidade]) 
		REFERENCES [dbo].[Especialidade]([sigla])
		ON DELETE CASCADE
)
GO

CREATE UNIQUE CLUSTERED INDEX IX_CL_Agenda ON [dbo].[Agenda] ([id_profis_saude], [sigla_especialidade], [id])
GO

ALTER TABLE [dbo].[Agenda] ADD CONSTRAINT [pk_agenda] PRIMARY KEY ([id])
GO

-- Dia_Semana = { sigla, nm_dia_semana}
CREATE TABLE [dbo].[Dia_Semana](
	[sigla] VARCHAR(3) NOT NULL,
	[nm_dia_semana] VARCHAR(7) NOT NULL,
	CONSTRAINT [pk_dia_semana] PRIMARY KEY CLUSTERED (
		[sigla] ASC
	)
)
GO

-- Dia_Agenda = { id_agenda, sigla_dia_semana, hr_inicial, hr_final}
CREATE TABLE [dbo].[Dia_Agenda](
	[id_agenda] INT NOT NULL,
	[sigla_dia_semana] VARCHAR(3) NOT NULL,
	[hr_inicial] TIME NULL,
	[hr_final] TIME NULL,
	CONSTRAINT [fk_dia_agenda] FOREIGN KEY ([id_agenda]) 
		REFERENCES [dbo].[Agenda]([id])
		ON DELETE CASCADE,
	CONSTRAINT [fk_dia_agenda_semana] FOREIGN KEY ([sigla_dia_semana]) 
		REFERENCES [dbo].[Dia_Semana]([sigla])
		ON DELETE CASCADE,
	CONSTRAINT [pk_dia_agenda] PRIMARY KEY CLUSTERED (
		[id_agenda] ASC,
		[sigla_dia_semana] ASC
	)
)
GO

-- Convenio = { sigla_convenio, nm_convenio, tel, email }
CREATE TABLE [dbo].[Convenio](
	[sigla_convenio] VARCHAR(5) NOT NULL,
	[nm_convenio] VARCHAR(25) NOT NULL,
	[tel] VARCHAR(20) NULL,
	[email] VARCHAR(256) NULL,
	CONSTRAINT [pk_convenio] PRIMARY KEY CLUSTERED(
		[sigla_convenio] ASC,
		[nm_convenio] ASC
	)
)
GO

-- Desconto_Procedimento = { sigla_convenio, nm_convenio, id_procedimento, qtd_desconto, unidade_medida }
CREATE TABLE [dbo].[Desconto_Procedimento](
	[sigla_convenio] VARCHAR(5) NOT NULL,
	[nm_convenio] VARCHAR(25) NOT NULL,
	[id_procedimento] INT NOT NULL,
	[qtd_desconto] NUMERIC (5,2) NULL,
	[unidade_medida] CHAR NULL,
	CONSTRAINT [fk_desconto_procedimento_convenio] FOREIGN KEY ([sigla_convenio], [nm_convenio]) 
		REFERENCES [dbo].[Convenio]([sigla_convenio], [nm_convenio])
		ON DELETE CASCADE,
	CONSTRAINT [fk_desconto_procedimento] FOREIGN KEY ([id_procedimento])
		REFERENCES [dbo].[Procedimento]([id])
		ON DELETE CASCADE,
	CONSTRAINT [pk_desconto_procedimento] PRIMARY KEY CLUSTERED(
		[id_procedimento] ASC,
		[sigla_convenio] ASC,
		[nm_convenio] ASC
	)
)
GO

-- Desconto_Tipo_Atendimento = { sigla_convenio, nm_convenio, id_tipo_atendimento, sigla_especialidade, qtd_desconto, unidade_medida }
CREATE TABLE [dbo].[Desconto_Tipo_Atendimento](
	[sigla_convenio] VARCHAR(5) NOT NULL,
	[nm_convenio] VARCHAR(25) NOT NULL,
	[id_tipo_atendimento] INT NOT NULL,
	[sigla_especialidade] VARCHAR(5) NOT NULL,
	[qtd_desconto] NUMERIC(5,2) NULL,
	[unidade_medida] VARCHAR(10) NULL,
	CONSTRAINT [fk_desconto_tipo_atendimento_convenio] FOREIGN KEY ([sigla_convenio], [nm_convenio]) 
		REFERENCES [dbo].[Convenio]([sigla_convenio], [nm_convenio])
		ON DELETE CASCADE,
	CONSTRAINT [fk_desconto_tipo_atendimento] FOREIGN KEY ([id_tipo_atendimento])
		REFERENCES [dbo].[Tipo_Agendamento]([id])
		ON DELETE CASCADE,
	CONSTRAINT [fk_desconto_tipo_atendimento_especialidade] FOREIGN KEY ([sigla_especialidade])
		REFERENCES [dbo].[Especialidade]([sigla])
		ON DELETE CASCADE,
	CONSTRAINT [pk_desconto_tipo_atendimento] PRIMARY KEY CLUSTERED(
		[sigla_especialidade] ASC,
		[id_tipo_atendimento] ASC,
		[sigla_convenio] ASC,
		[nm_convenio] ASC
	)
)
GO

-- Carteirinha_Paciente = { cd_matricula, sigla_convenio, nm_convenio, id_cliente }
CREATE TABLE [dbo].[Carteirinha_Paciente](
	[cd_matricula] VARCHAR(20) NOT NULL,
	[sigla_convenio] VARCHAR(5) NULL,
	[nm_convenio] VARCHAR(25) NULL,
	[id_cliente] INT NOT NULL,
	CONSTRAINT [fk_carteirinha_paciente_convenio] FOREIGN KEY ([sigla_convenio], [nm_convenio]) 
		REFERENCES [dbo].[Convenio]([sigla_convenio], [nm_convenio])
		ON DELETE CASCADE,
	CONSTRAINT [fk_carteirinha_paciente] FOREIGN KEY ([id_cliente])
		REFERENCES [dbo].[Cliente]([id])
		ON DELETE CASCADE
)
GO

CREATE CLUSTERED INDEX IX_CL_Carteirinha_Paciente ON [dbo].[Carteirinha_Paciente] ([id_cliente])
GO

ALTER TABLE [dbo].[Carteirinha_Paciente] ADD CONSTRAINT [pk_carteirinha_paciente] PRIMARY KEY ([cd_matricula])
GO

-- Consulta = { id, hr_consulta, dt_cosulta, nm_status, ds_observacao, vl_total, cd_carteirinha_paciente, id_recep_adm, id_agenda}
CREATE TABLE [dbo].[Consulta](
	[cd_carteirinha_paciente] VARCHAR(20) NOT NULL,
	[id_agenda] INT NOT NULL,
	[id] INT NOT NULL,
	[dt_consulta] DATE NULL,
	[hr_consulta] TIME NULL,
	[nm_status] VARCHAR(20) NULL,
	[ds_observacao] VARCHAR(256) NULL,
	[id_recep_adm] INT NULL,
	CONSTRAINT [fk_consulta_carteirinha_paciente] FOREIGN KEY ([cd_carteirinha_paciente])
		REFERENCES [dbo].[Carteirinha_Paciente]([cd_matricula])
		ON DELETE CASCADE,
	CONSTRAINT [fk_consulta_recep_adm] FOREIGN KEY ([id_recep_adm])
		REFERENCES [dbo].[Recep_Adm]([id]),
	CONSTRAINT [fk_consulta_agenda] FOREIGN KEY ([id_agenda])
		REFERENCES [dbo].[Agenda]([id])
		ON DELETE CASCADE
)
GO

CREATE UNIQUE CLUSTERED INDEX IX_CL_Consulta ON [dbo].[Consulta] ([id_agenda], [dt_consulta], [id])
GO

ALTER TABLE [dbo].[Consulta] ADD CONSTRAINT [pk_consulta] PRIMARY KEY ([id])
GO

-- Procedimento_Consulta = { id_consulta, id_procedimento }
CREATE TABLE [dbo].[Procedimento_Consulta](
	[id_consulta] INT NOT NULL,
	[id_procedimento] INT NOT NULL,
	CONSTRAINT [fk_procedimento_consulta] FOREIGN KEY ([id_consulta])
		REFERENCES [dbo].[Consulta]([id])
		ON DELETE CASCADE,
	CONSTRAINT [fk_consulta_procedimento] FOREIGN KEY ([id_procedimento])
		REFERENCES [dbo].[Procedimento]([id])
		ON DELETE CASCADE,
	CONSTRAINT [pk_procedimento_consulta] PRIMARY KEY CLUSTERED(
		[id_consulta] ASC,
		[id_procedimento] ASC
	)
)
GO

-- Tipo_Agendamento_Consulta = { id_consulta, id_tipo_agendamento }
CREATE TABLE [dbo].[Tipo_Agendamento_Consulta](
	[id_consulta] INT NOT NULL,
	[id_tipo_agendamento] INT NOT NULL,
	CONSTRAINT [fk_tipo_agendamento_consulta] FOREIGN KEY ([id_consulta])
		REFERENCES [dbo].[Consulta]([id])
		ON DELETE CASCADE,
	CONSTRAINT [fk_consulta_tipo_agendamento] FOREIGN KEY ([id_tipo_agendamento])
		REFERENCES [dbo].[Tipo_Agendamento]([id])
		ON DELETE CASCADE,
	CONSTRAINT [pk_tipo_agendamento_consulta] PRIMARY KEY CLUSTERED (
		[id_consulta] ASC,
		[id_tipo_agendamento] ASC
	)
)
GO

-- Modificacao_Consulta = { id, dt_modificacao, ds_modificacao, id_consulta, id_funcionario }
CREATE TABLE [dbo].[Modificacao_Consulta](
	[id] INT NOT NULL,
	[dt_modificacao] DATETIME NOT NULL,
	[ds_modificacao] VARCHAR(256) NOT NULL,
	[id_consulta] INT NOT NULL,
	[id_funcionario] INT NULL,
	CONSTRAINT [fk_modificacao_consulta] FOREIGN KEY ([id_consulta])
		REFERENCES [dbo].[Consulta]([id])
		ON DELETE CASCADE,
	CONSTRAINT [fk_modificacao_consulta_funcionario] FOREIGN KEY ([id_funcionario])
		REFERENCES [dbo].[Funcionario]([id])
)
GO

CREATE UNIQUE CLUSTERED INDEX IX_CL_Modificacao_Consulta ON [dbo].[Modificacao_Consulta] ([id_consulta], [id])
GO

ALTER TABLE [dbo].[Modificacao_Consulta] ADD CONSTRAINT [pk_modificacao_consulta] PRIMARY KEY ([id])
GO

-- Orcamento = { id, vl_total, dt_criacao, cd_carteirinha_paciente }
CREATE TABLE [dbo].[Orcamento](
	[id] INT NOT NULL,
	[vl_total] NUMERIC(6,2) NOT NULL,
	[dt_criacao] DATE NOT NULL,
	[cd_carteirinha_paciente] VARCHAR(20) NOT NULL,
	CONSTRAINT [fk_orcamento] FOREIGN KEY ([cd_carteirinha_paciente])
		REFERENCES [dbo].[Carteirinha_Paciente]([cd_matricula])
		ON DELETE CASCADE,
)
GO

CREATE UNIQUE CLUSTERED INDEX IX_CL_Orcamento ON [dbo].[Orcamento] ([cd_carteirinha_paciente], [id])
GO

ALTER TABLE [dbo].[Orcamento] ADD CONSTRAINT [pk_orcamento] PRIMARY KEY ([id])
GO

-- Procedimento_Orcamento = { id_procedimento, id_orcamento }
CREATE TABLE [dbo].[Procedimento_Orcamento](
	[id_procedimento] INT NOT NULL,
	[id_orcamento] INT NOT NULL,
	CONSTRAINT [fk_procedimento_orcamento] FOREIGN KEY ([id_procedimento])
		REFERENCES [dbo].[Procedimento]([id])
		ON DELETE CASCADE,
	CONSTRAINT [fk_orcamento_procedimento] FOREIGN KEY ([id_orcamento])
		REFERENCES [dbo].[Orcamento]([id])
		ON DELETE CASCADE,
	CONSTRAINT [pk_procedimento_orcamento] PRIMARY KEY CLUSTERED(
		[id_orcamento] ASC,
		[id_procedimento] ASC
	)
)
GO

-- Forma_Pagamento = { id, nm_forma_pagamento, qtd_desconto }
CREATE TABLE [dbo].[Forma_Pagamento](
	[id] INT NOT NULL,
	[nm_forma_pagamento] VARCHAR (7) NOT NULL,
	[qtd_desconto] NUMERIC(5,2) NULL,
	CONSTRAINT [pk_forma_pagamento] PRIMARY KEY CLUSTERED(
		[id] ASC
	)
)
GO

-- Pagamento = { id, dt_pagamento, hr_pagamento, vl_pagamento, id_consulta, id_forma_pagamento }
CREATE TABLE [dbo].[Pagamento](
	[id] INT NOT NULL,
	[dt_pagamento] DATE NOT NULL,
	[hr_pagamento] TIME NOT NULL,
	[vl_pagamento] NUMERIC(6,2) NOT NULL,
	[id_consulta] INT NOT NULL,
	[id_forma_pagamento] INT NOT NULL,
	CONSTRAINT [fk_pagamento_consulta] FOREIGN KEY ([id_consulta])
		REFERENCES [dbo].[Consulta]([id])
		ON DELETE CASCADE,
	CONSTRAINT [fk_forma_pagamento] FOREIGN KEY ([id_forma_pagamento])
		REFERENCES [dbo].[Forma_Pagamento]([id])
		ON DELETE CASCADE
)
GO

CREATE UNIQUE CLUSTERED INDEX IX_CL_Pagamento ON [dbo].[Pagamento] ([id_consulta], [id])
GO

ALTER TABLE [dbo].[Pagamento] ADD CONSTRAINT [pk_pagamento] PRIMARY KEY ([id])
GO

-- Filial = { id, nm_cidade }
CREATE TABLE [dbo].[Filial](
	[id] INT NOT NULL,
	[nm_cidade] VARCHAR(30) NOT NULL,
	CONSTRAINT [pk_filial] PRIMARY KEY CLUSTERED(
		[id] ASC
	)
)
GO

-- Unidade = { id, endereco, id_filial }
CREATE TABLE [dbo].[Unidade](
	[id] INT NOT NULL,
	[endereco] VARCHAR(30) NULL,
	[id_filial] INT NOT NULL,
	CONSTRAINT [fk_unidade] FOREIGN KEY ([id_filial])
		REFERENCES [dbo].[Filial]([id])
		ON DELETE CASCADE,
	CONSTRAINT [pk_unidade] PRIMARY KEY CLUSTERED(
		[id] ASC
	)
)
GO

-- Telefone = { cd_ddd, num_telefone, id_unidade }
CREATE TABLE [dbo].[Telefone](
	[cd_ddd] INT NOT NULL,
	[num_telefone] VARCHAR(10) NOT NULL,
	[id_unidade] INT NOT NULL,
	CONSTRAINT [fk_telefone] FOREIGN KEY ([id_unidade])
		REFERENCES [dbo].[Unidade]([id])
		ON DELETE CASCADE,
	CONSTRAINT [pk_telefone] PRIMARY KEY CLUSTERED(
		[cd_ddd] ASC,
		[num_telefone] ASC
	)
)
GO

-- Funcionario_unidade = { id_funcionario, id_unidade }
CREATE TABLE [dbo].[Funcionario_unidade](
	[id_funcionario] INT NOT NULL,
	[id_unidade] INT NOT NULL,
	CONSTRAINT [fk_funcionario_unidade] FOREIGN KEY ([id_funcionario])
		REFERENCES [dbo].[Funcionario]([id])
		ON DELETE CASCADE,
	CONSTRAINT [fk_unidade_funcionario] FOREIGN KEY ([id_unidade])
		REFERENCES [dbo].[Unidade]([id])
		ON DELETE CASCADE,
	CONSTRAINT [pk_funcionario_unidade] PRIMARY KEY CLUSTERED(
		[id_unidade] ASC,
		[id_funcionario] ASC
	)
)
GO

-- Item = { id, nm_item, ds_item }
CREATE TABLE [dbo].[Item](
	[id] INT NOT NULL,
	[nm_item] VARCHAR(80) NOT NULL,
	[ds_item] VARCHAR(256) NULL,
	CONSTRAINT [pk_item] PRIMARY KEY CLUSTERED(
		[id] ASC
	)
)
GO

-- Estoque = { id, qtd_item, id_item, id_unidade }
CREATE TABLE [dbo].[Estoque](
	[id] INT NOT NULL,
	[qtd_item] INT NULL,
	[id_item] INT NOT NULL,
	[id_unidade]  INT NOT NULL,
	CONSTRAINT [fk_estoque_item] FOREIGN KEY ([id_item])
		REFERENCES [dbo].[Item]([id])
		ON DELETE CASCADE,
	CONSTRAINT [fk_estoque_unidade] FOREIGN KEY ([id_unidade])
		REFERENCES [dbo].[Unidade]([id])
		ON DELETE CASCADE,
)
GO

CREATE UNIQUE CLUSTERED INDEX IX_CL_Estoque ON [dbo].[Estoque] ([id_unidade], [id_item])
GO

ALTER TABLE [dbo].[Estoque] ADD CONSTRAINT [pk_estoque] PRIMARY KEY ([id])
GO

-- Movimentacao_Estoque = { dt_movimentacao, hr_movimentacao, id_estoque, id_recep_adm,  qtd_item, ds_tipo_movimentacao, ds_observacao }
CREATE TABLE [dbo].[Movimentacao_Estoque](
	[id_estoque] INT NOT NULL,
	[dt_movimentacao] DATE NOT NULL,
	[hr_movimentacao] TIME NOT NULL,
	[id_recep_adm] INT NOT NULL,
	[qtd_item] INT NOT NULL,
	[ds_tipo_movimentacao] CHAR NOT NULL,
	[ds_observacao] VARCHAR(256) NULL,
	CONSTRAINT [fk_movimentacao_estoque] FOREIGN KEY ([id_estoque])
		REFERENCES [dbo].[Estoque]([id])
		ON DELETE CASCADE,
	CONSTRAINT [fk_movimentacao_estoque_recep_adm] FOREIGN KEY ([id_recep_adm])
		REFERENCES [dbo].[Recep_Adm]([id])
		ON DELETE CASCADE,
	CONSTRAINT [pk_movimentacao_estoque] PRIMARY KEY CLUSTERED(
		[id_estoque] ASC,
		[dt_movimentacao] ASC,
		[hr_movimentacao] ASC,
		[id_recep_adm] ASC
	)
)
GO

-- Caixa = { id, vl_inicial, vl_final, dt_caixa, id_unidade }
CREATE TABLE [dbo].[Caixa](
	[id] INT NOT NULL,
	[vl_inicial] NUMERIC(7,2) NOT NULL,
	[vl_final] NUMERIC(7,2) NOT NULL,
	[dt_caixa] DATE NOT NULL,
	[id_unidade] INT NOT NULL,
	CONSTRAINT [fk_caixa] FOREIGN KEY ([id_unidade])
		REFERENCES [dbo].[Unidade]([id])
		ON DELETE CASCADE
)
GO

CREATE UNIQUE CLUSTERED INDEX IX_CL_Caixa ON [dbo].[Caixa] ([id_unidade], [dt_caixa])
GO

ALTER TABLE [dbo].[Caixa] ADD CONSTRAINT [pk_caixa] PRIMARY KEY ([id])
GO

-- Movimentacao_Caixa = { dt_movimentacao, hr_movimentacao, id_caixa, id_recep_adm, vl_movimentado, ds_tipo_movimentacao, ds_observacao }
CREATE TABLE [dbo].[Movimentacao_Caixa](
	[id_caixa] INT NOT NULL,
	[dt_movimentacao] DATE NOT NULL,
	[hr_movimentacao] TIME NOT NULL,
	[id_recep_adm] INT NOT NULL,
	[vl_movimentacao] NUMERIC(7,2) NOT NULL,
	[ds_tipo_movimentacao] CHAR NOT NULL,
	[ds_observacao] VARCHAR(256) NULL,
	CONSTRAINT [fk_movimentacao_caixa] FOREIGN KEY ([id_caixa])
		REFERENCES [dbo].[Caixa]([id])
		ON DELETE CASCADE,
	CONSTRAINT [fk_movimentacao_caixa_recep_adm] FOREIGN KEY ([id_recep_adm])
		REFERENCES [dbo].[Recep_Adm]([id])
		ON DELETE CASCADE,
	CONSTRAINT [pk_movimentacao_caixa] PRIMARY KEY CLUSTERED(
		[id_caixa] ASC,
		[dt_movimentacao] ASC,
		[hr_movimentacao] ASC,
		[id_recep_adm] ASC
	)
)
GO

