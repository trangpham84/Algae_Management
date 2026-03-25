-- ============================================================
--  AlgaeDNADB — SQL Server Database Script
--  Algae DNA Management System
-- ============================================================

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'AlgaeDNADB')
    DROP DATABASE AlgaeDNADB;
GO

CREATE DATABASE AlgaeDNADB;
GO

USE AlgaeDNADB;
GO

-- ── Users ────────────────────────────────────────────────────────────────────
CREATE TABLE Users (
    UserID       INT IDENTITY(1,1) PRIMARY KEY,
    Username     NVARCHAR(50)  NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    Email        NVARCHAR(100),
    Role         NVARCHAR(20)  NOT NULL DEFAULT 'User',
    FullName     NVARCHAR(100),
    Phone        NVARCHAR(15),
    ProfileImage NVARCHAR(500),
    LastLoginAt  DATETIME,
    LoginCount   INT           NOT NULL DEFAULT 0
);
GO

-- ── AlgaeRecords ─────────────────────────────────────────────────────────────
CREATE TABLE AlgaeRecords (
    RecordID          INT IDENTITY(1,1) PRIMARY KEY,
    SpeciesGroup      NVARCHAR(200) NOT NULL,
    SignatureSequence  NVARCHAR(500) NOT NULL,
    Nucleotides       INT           NOT NULL,
    CreatedAt         DATETIME      NOT NULL DEFAULT GETDATE(),
    UpdatedAt         DATETIME      NOT NULL DEFAULT GETDATE()
);
GO

-- ── Seed: Admin user (password = "admin123") ─────────────────────────────────
INSERT INTO Users (Username, PasswordHash, Email, Role, FullName, LoginCount)
VALUES ('admin', 'admin123', 'admin@algaedb.com', 'Admin', 'System Administrator', 0);
GO

-- ── Seed: Sample algae data ───────────────────────────────────────────────────
INSERT INTO AlgaeRecords (SpeciesGroup, SignatureSequence, Nucleotides) VALUES
('AC1/Tetradesmus_acuminatus_I',          'TTGGTCAGCTCTCAGCTGACCTTAGGG',            27),
('AC2/Tetradesmus_acuminatus_II',         'GGGTTGGTCGACTGTGTGTTGGCCT',             25),
('BA1/Tetradesmus_bajacalifornicus_I',    'TGGAGGGCTGGTCAGCTCTTAGTT',              24),
('BA2/Tetradesmus_bajacalifornicus_II',   'TGGAGGGTTGGTCAGCTCTCAGTTGACCT',         29),
('D1/Tetradesmus_distendus_I',            'TTCCCAATTGGCTTACTCCGATT',               23),
('D2/Tetradesmus_distendus_II',           'AGAGTTGGTCAGCTCTCAGTTGACCTTA',          28),
('N/Tetradesmus_nygaardii',               'GAGTGGATCTGGCTTTCCCATT',               22),
('O/Tetradesmus_obliquus',                'ATTGGTTCACTCCGATTGGGTTGGCTGAAGCT',      32),
('O/Tetradesmus_obliquus',                'ATTGGTTCACTCCGAATGGGTTGGCTGAAGCT',      32),
('O1/Tetradesmus_obliquus_subgroup_1',    'GTCAGCTTCTAGTTGGCCTCAGGGG',             25),
('O2/Tetradesmus_obliquus_subgroup_2',    'GTCAGCTTCTAGTTGGCCTCAGGGA',             25),
('O3/Tetradesmus_obliquus_subgroup_3',    'GTCAGCTTTTAGTTGGCCTCAGGGG',             25),
('O4/Tetradesmus_obliquus_subgroup_4',    'GTCAGCTTCTAGTTGGCCTTAGGGG',             25),
('OD/Tetradesmus_obliquus_var.dactylococcoide', 'CTGGTCAGCTTCTAGTTGGCCTGAGGGG',   28),
('RE/Tetradesmus_reginae',                'TAGGAGTGGATCTGGCTTTCCCAATT',            26),
('RB/Tetradesmus_bernardii',              'CAGGAAACATGCTTTTGCATGTCT',             24),
('RB/Tetradesmus_bernardii',              'CCTCCCTCCTTTGGAGGGCTGGTCAGC',           27),
('Tetradesmus_adustus',                   'TGGAGGGTTGGTCAACTCTCAGTTGACCT',         29),
('Tetradesmus_arenicola',                 'CTGGCTTTCCCAATTGGATTATT',               23),
('Tetradesmus_deserticola',               'TTTGGAGGGTTGGTCAGCTTTCAGTTGG',          28),
('Tetradesmus_dissociatus',               'CAACATTCAGTTGGCCTCAGGGG',               23),
('Scenedesmus_sp.BOP',                    'ATCGCAGGTTAGCTTATCAGCTGGCCC',           27);
GO

PRINT 'AlgaeDNADB created and seeded successfully.';
GO

CREATE INDEX idx_duplicate_check ON AlgaeRecords (SpeciesGroup, SignatureSequence, Nucleotides);