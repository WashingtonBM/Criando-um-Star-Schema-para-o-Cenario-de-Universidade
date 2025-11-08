
/*
Star Schema: Universidade_StarSchema
Central fact: fato_professor
Dimensions: dim_professor, dim_curso, dim_disciplina, dim_departamento, dim_tempo, dim_campus
Generated: Automated by ChatGPT based on user's request.
*/

-- DIMENSIONS

CREATE TABLE dim_professor (
    professor_sk INT AUTO_INCREMENT PRIMARY KEY,
    professor_id VARCHAR(50) NOT NULL, -- origem / natural key
    nome VARCHAR(200) NOT NULL,
    titulacao VARCHAR(100),
    data_ingresso DATE,
    sexo CHAR(1),
    carga_base_horas INT,
    departamento_id VARCHAR(50),
    atributos BINARY,
    UNIQUE KEY ux_professor_natural (professor_id)
);

CREATE TABLE dim_curso (
    curso_sk INT AUTO_INCREMENT PRIMARY KEY,
    curso_id VARCHAR(50) NOT NULL,
    nome VARCHAR(200) NOT NULL,
    nivel VARCHAR(50),
    duracao_semestres INT,
    campus_id VARCHAR(50),
    atributos BINARY,
    UNIQUE KEY ux_curso_natural (curso_id)
);

CREATE TABLE dim_disciplina (
    disciplina_sk INT AUTO_INCREMENT PRIMARY KEY,
    disciplina_id VARCHAR(50) NOT NULL,
    nome VARCHAR(200) NOT NULL,
    carga_horaria INT,
    codigo VARCHAR(50),
    departamento_id VARCHAR(50),
    atributos BINARY,
    UNIQUE KEY ux_disciplina_natural (disciplina_id)
);

CREATE TABLE dim_departamento (
    departamento_sk INT AUTO_INCREMENT PRIMARY KEY,
    departamento_id VARCHAR(50) NOT NULL,
    nome VARCHAR(200) NOT NULL,
    chefe_professor_id VARCHAR(50),
    atributos BINARY,
    UNIQUE KEY ux_departamento_natural (departamento_id)
);

CREATE TABLE dim_campus (
    campus_sk INT AUTO_INCREMENT PRIMARY KEY,
    campus_id VARCHAR(50) NOT NULL,
    nome VARCHAR(200) NOT NULL,
    cidade VARCHAR(100),
    estado VARCHAR(100),
    atributos BINARY,
    UNIQUE KEY ux_campus_natural (campus_id)
);

CREATE TABLE dim_tempo (
    tempo_sk INT AUTO_INCREMENT PRIMARY KEY,
    data_date DATE NOT NULL,
    ano INT NOT NULL,
    semestre INT,
    trimestre INT,
    mes INT,
    dia INT,
    dia_da_semana INT,
    fiscal_year INT,
    descricao VARCHAR(100),
    UNIQUE KEY ux_tempo_date (data_date)
);


-- FACT TABLE
CREATE TABLE fato_professor (
    fato_professor_sk BIGINT AUTO_INCREMENT PRIMARY KEY,
    -- Surrogate keys to dimensions
    professor_sk INT NOT NULL,
    curso_sk INT,
    disciplina_sk INT,
    departamento_sk INT,
    campus_sk INT,
    tempo_sk INT NOT NULL,
    
    -- Measures (examples)
    horas_ministradas DECIMAL(10,2) DEFAULT 0,
    numero_turmas INT DEFAULT 0,
    total_creditos INT DEFAULT 0,
    media_avaliacao DECIMAL(5,2) DEFAULT NULL,
    numero_alunos_total INT DEFAULT 0,
    custo_associado DECIMAL(12,2) DEFAULT NULL,
    
    -- Degenerate dimensions / attributes directly on fact
    semestre VARCHAR(20),
    observacoes VARCHAR(500),
    
    -- Audit
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign key constraints (recommended; optional for large star schemas)
    INDEX ix_fato_professor_prof_sk (professor_sk),
    INDEX ix_fato_professor_tempo_sk (tempo_sk),
    INDEX ix_fato_professor_curso_sk (curso_sk),
    INDEX ix_fato_professor_disciplina_sk (disciplina_sk),
    INDEX ix_fato_professor_depto_sk (departamento_sk),
    INDEX ix_fato_professor_campus_sk (campus_sk),
    CONSTRAINT fk_fato_professor_prof FOREIGN KEY (professor_sk) REFERENCES dim_professor(professor_sk),
    CONSTRAINT fk_fato_professor_tempo FOREIGN KEY (tempo_sk) REFERENCES dim_tempo(tempo_sk),
    CONSTRAINT fk_fato_professor_curso FOREIGN KEY (curso_sk) REFERENCES dim_curso(curso_sk),
    CONSTRAINT fk_fato_professor_disciplina FOREIGN KEY (disciplina_sk) REFERENCES dim_disciplina(disciplina_sk),
    CONSTRAINT fk_fato_professor_depto FOREIGN KEY (departamento_sk) REFERENCES dim_departamento(departamento_sk),
    CONSTRAINT fk_fato_professor_campus FOREIGN KEY (campus_sk) REFERENCES dim_campus(campus_sk)
);

-- Index suggestions for common queries
CREATE INDEX ix_fato_professor_prof_tempo ON fato_professor (professor_sk, tempo_sk);
CREATE INDEX ix_fato_professor_curso_tempo ON fato_professor (curso_sk, tempo_sk);
