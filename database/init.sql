-- Etik Kurul Yönetim Sistemi - PostgreSQL Setup Script
-- Bu script tüm tabloları ve ilk verileri oluşturur

-- ============================================================
-- 1. USERS TABLE - Kullanıcı bilgileri
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  title VARCHAR(50) NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(20),
  university VARCHAR(255) DEFAULT 'Kafkas Üniversitesi',
  department VARCHAR(255),
  password_hash VARCHAR(255) NOT NULL,
  email_verified_at TIMESTAMP,
  is_active BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_is_active ON users(is_active);

-- ============================================================
-- 2. ROLES TABLE - Sistem rolleri
-- ============================================================
CREATE TABLE IF NOT EXISTS roles (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL,
  display_name VARCHAR(100) NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 3. USER_ROLES TABLE - Kullanıcı-rol ilişkisi
-- ============================================================
CREATE TABLE IF NOT EXISTS user_roles (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role_id INTEGER NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, role_id)
);

CREATE INDEX IF NOT EXISTS idx_user_roles_user_id ON user_roles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_role_id ON user_roles(role_id);

-- ============================================================
-- 4. APPLICATIONS TABLE - Başvurular
-- ============================================================
CREATE TABLE IF NOT EXISTS applications (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  application_type VARCHAR(50) NOT NULL DEFAULT 'new',
  -- new, name_change, subject_change, content_change
  
  parent_application_id INTEGER REFERENCES applications(id) ON DELETE CASCADE,
  -- null ise ana başvuru, dolu ise değişiklik başvurusu
  
  subject TEXT NOT NULL,
  helper_researchers TEXT,
  study_year INTEGER NOT NULL,
  
  status VARCHAR(50) NOT NULL DEFAULT 'pending',
  -- pending, approved, rejected, revision, signing, approved_ready
  
  session_date DATE,
  session_number INTEGER,
  yearly_sequence_number INTEGER,
  
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_applications_user_id ON applications(user_id);
CREATE INDEX IF NOT EXISTS idx_applications_status ON applications(status);
CREATE INDEX IF NOT EXISTS idx_applications_parent_application_id ON applications(parent_application_id);
CREATE INDEX IF NOT EXISTS idx_applications_study_year ON applications(study_year);
CREATE INDEX IF NOT EXISTS idx_applications_yearly_sequence ON applications(study_year, yearly_sequence_number);

-- ============================================================
-- 5. APPLICATION_CHANGE_DETAILS TABLE - Değişiklik detayları
-- ============================================================
CREATE TABLE IF NOT EXISTS application_change_details (
  id SERIAL PRIMARY KEY,
  application_id INTEGER NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
  change_type VARCHAR(50) NOT NULL,
  -- name_change, subject_change, content_change
  
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_application_change_details_application_id 
  ON application_change_details(application_id);

-- ============================================================
-- 6. APPLICATION_STATUS_LOGS TABLE - Durum geçmişi
-- ============================================================
CREATE TABLE IF NOT EXISTS application_status_logs (
  id SERIAL PRIMARY KEY,
  application_id INTEGER NOT NULL REFERENCES applications(id) ON DELETE CASCADE,
  old_status VARCHAR(50),
  new_status VARCHAR(50) NOT NULL,
  note TEXT,
  changed_by_user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_application_status_logs_application_id 
  ON application_status_logs(application_id);
CREATE INDEX IF NOT EXISTS idx_application_status_logs_created_at 
  ON application_status_logs(created_at);

-- ============================================================
-- 7. EMAIL_VERIFICATION_TOKENS TABLE - Mail doğrulama
-- ============================================================
CREATE TABLE IF NOT EXISTS email_verification_tokens (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token VARCHAR(255) UNIQUE NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_email_verification_tokens_user_id 
  ON email_verification_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_email_verification_tokens_token 
  ON email_verification_tokens(token);

-- ============================================================
-- 8. PASSWORD_RESET_TOKENS TABLE - Şifre sıfırlama
-- ============================================================
CREATE TABLE IF NOT EXISTS password_reset_tokens (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token VARCHAR(255) UNIQUE NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_password_reset_tokens_user_id 
  ON password_reset_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_password_reset_tokens_token 
  ON password_reset_tokens(token);

-- ============================================================
-- INITIAL DATA - Temel veriler
-- ============================================================

-- Rolleri ekle
INSERT INTO roles (name, display_name, description) VALUES
  ('admin', 'Yönetici', 'Sistem yöneticisi - tüm işlemlere erişim'),
  ('applicant', 'Başvuru Sahibi', 'Etik kurul başvurusu yapan akademisyen'),
  ('president', 'Başkan', 'Etik kurulu başkanı'),
  ('vice_president', 'Başkan Yardımcısı', 'Etik kurulu başkan yardımcısı'),
  ('rapporteur', 'Raportör', 'Etik kurulu raportörü'),
  ('member', 'Üye', 'Etik kurulu üyesi'),
  ('external_member', 'Fakülte Dışı Üye', 'Fakülte dışından kurul üyesi'),
  ('secretary', 'Sekreter', 'Etik kurulu sekreteri')
ON CONFLICT (name) DO NOTHING;

-- Admin kullanıcı oluştur
-- Şifre: admin123 (bcrypt hash - production'da değiştirilmeli)
INSERT INTO users (title, full_name, email, phone, university, department, password_hash, email_verified_at, is_active)
VALUES (
  'Prof.Dr.',
  'Sistem Yöneticisi',
  'admin@etikkurul.com',
  '5550000000',
  'Kafkas Üniversitesi',
  'Rektörlük',
  '$2b$10$dXJ6SVZuYzNXSzRQVEswLuG5S5/rKEKJ.8FYzF5KYK9.2q1q8K9Ra',
  CURRENT_TIMESTAMP,
  TRUE
)
ON CONFLICT (email) DO NOTHING;

-- Admin kullanıcıya admin rolü ata
INSERT INTO user_roles (user_id, role_id)
SELECT u.id, r.id FROM users u, roles r
WHERE u.email = 'admin@etikkurul.com' AND r.name = 'admin'
ON CONFLICT (user_id, role_id) DO NOTHING;

-- ============================================================
-- Tablo özetleri
-- ============================================================
-- Total: 8 tablo
-- users: Tüm kullanıcılar (yönetici, hoca, kurul üyeleri)
-- roles: Sistem rolleri (8 rol tanımı)
-- user_roles: Kullanıcı-rol ilişkisi (N-to-M)
-- applications: Başvurular (4 türde)
-- application_change_details: Değişiklik bilgileri
-- application_status_logs: Durum geçmişi (denetim izi)
-- email_verification_tokens: Mail doğrulama
-- password_reset_tokens: Şifre sıfırlama
