-- ============================================================
--  AlgaeDNADB — PostgreSQL Database Script (for Supabase)
--  Algae DNA Management System
-- ============================================================

-- ── Users ────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS "Users" (
    "UserID"       SERIAL PRIMARY KEY,
    "Username"     VARCHAR(50)  NOT NULL UNIQUE,
    "PasswordHash" VARCHAR(255) NOT NULL,
    "Email"        VARCHAR(100),
    "Role"         VARCHAR(20)  NOT NULL DEFAULT 'User',
    "FullName"     VARCHAR(100),
    "Phone"        VARCHAR(15),
    "ProfileImage" VARCHAR(500),
    "LastLoginAt"  TIMESTAMP,
    "LoginCount"   INT          NOT NULL DEFAULT 0
);

-- ── AlgaeRecords ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS "AlgaeRecords" (
    "RecordID"         SERIAL PRIMARY KEY,
    "SpeciesGroup"     VARCHAR(200) NOT NULL,
    "SignatureSequence" VARCHAR(500) NOT NULL,
    "Nucleotides"      INT          NOT NULL,
    "CreatedAt"        TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt"        TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ── Index for duplicate check ─────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_duplicate_check
    ON "AlgaeRecords" ("SpeciesGroup", "SignatureSequence", "Nucleotides");

-- ── Seed: Admin user (password = "admin123") ─────────────────────────────────
INSERT INTO "Users" ("Username", "PasswordHash", "Email", "Role", "FullName", "LoginCount")
VALUES ('admin', 'admin123', 'admin@algaedb.com', 'Admin', 'System Administrator', 0)
ON CONFLICT ("Username") DO NOTHING;

-- ── Seed: Sample algae data ───────────────────────────────────────────────────
INSERT INTO "AlgaeRecords" ("SpeciesGroup", "SignatureSequence", "Nucleotides") VALUES
('AC1/Tetradesmus_acuminatus_I',               'TTGGTCAGCTCTCAGCTGACCTTAGGG',            27),
('AC2/Tetradesmus_acuminatus_II',              'GGGTTGGTCGACTGTGTGTTGGCCT',              25);
