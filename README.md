# Etik Kurul Yönetim Sistemi

Etik Kurul Yönetim Sistemi, akademik kuruluşlarda etik onay başvurularını ve karar yönetimini kolaylaştıran kapsamlı bir web uygulamasıdır.

## 🎯 Proje Amacı

- Etik kurul başvurularının sistematik yönetimi
- Başvuru durumunun gerçek zamanlı takibi
- Kurul kararlarının belge haline getirilmesi
- İşlemlerin denetim izinin tutulması
- Yönetici ve başvurucu arayüzlerinin ayrı yapılandırılması

---

## 📊 Teknoloji Stack

| Bileşen | Teknoloji |
|---------|-----------|
| **Frontend** | Next.js 14 + TypeScript + React 18 |
| **Backend** | Next.js API Routes |
| **Database** | PostgreSQL 15 |
| **Styling** | Tailwind CSS + shadcn/ui |
| **Authentication** | JWT + Email Verification |
| **Container** | Docker + Docker Compose |
| **Runtime** | Node.js 18+ |

---

## 🚀 Hızlı Başlangıç

### Gereksinimler

- Docker & Docker Compose
- Node.js 18+ (lokal geliştirme için)
- Git

### Adım 1: Repository'i Klonla

```bash
git clone https://github.com/erkantan36-arch/etik-kurul-yonetim-sistemi.git
cd etik-kurul-yonetim-sistemi
```

### Adım 2: Ortam Dosyasını Hazırla

```bash
cp .env.example .env.local
```

### Adım 3: Docker Compose ile Başlat

```bash
docker-compose up -d
```

Bu komut:
- PostgreSQL veritabanını başlatır
- pgAdmin (veritabanı yönetimi) başlatır
- Next.js uygulamasını başlatır

### Adım 4: Erişim Bilgileri

```
Uygulama: http://localhost:3000
pgAdmin: http://localhost:5050

Default Login:
Email: admin@etikkurul.com
Password: admin123
```

### Adım 5: Veritabanını Kontrol Et

```bash
# pgAdmin'e giriş yap
# New → Server
# Host: postgres
# Username: etik_user
# Password: etik_password
# Database: etik_kurul_db
```

---

## 📁 Proje Yapısı

```
etik-kurul-yonetim-sistemi/
├── app/                          # Next.js App Router
│   ├── api/                      # API Routes
│   ├── (auth)/                   # Authentication pages
│   ├── (dashboard)/              # Authenticated pages
│   └── layout.tsx
│
├── components/                   # React Components
│   ├── ui/                       # shadcn/ui components
│   ├── auth/                     # Auth components
│   ├── dashboard/                # Dashboard components
│   └── admin/                    # Admin components
│
├── lib/                          # Utilities & Helpers
│   ├── db.ts                     # Database connection
│   ├── auth.ts                   # Auth utilities
│   └── api-client.ts             # API client
│
├── styles/                       # Global styles
│
├── types/                        # TypeScript types
│   ├── user.ts
│   ├── application.ts
│   └── index.ts
│
├── public/                       # Static files
│
├── database/
│   └── init.sql                  # Database schema
│
├── docs/                         # Documentation
│   ├── DATABASE_DESIGN.md
│   ├── API_ENDPOINTS.md
│   ├── USER_ROLES.md
│   └── APPLICATION_FLOW.md
│
├── .env.example                  # Environment variables
├── docker-compose.yml            # Docker configuration
├── Dockerfile                    # Next.js container
├── package.json
├── tsconfig.json
└── README.md
```

---

## 👥 Kullanıcı Rolleri

### 1. **Yönetici (Admin)**
- Tüm başvuruları yönetir
- Başvuruları onaylar/reddeder
- Kullanıcı yönetimi
- Rol atama

### 2. **Başvuru Sahibi (Applicant)**
- Yeni başvuru oluşturur
- Başvurularını takip eder
- Değişiklik başvurusu yapar
- Profil güncellemesi

### 3. **Kurul Üyeleri**
- **Başkan:** Kurul başkanlığı
- **Başkan Yardımcısı:** Başkan yardımcılığı
- **Raportör:** Belge hazırlama
- **Üye:** İnceleme ve oy
- **Fakülte Dışı Üye:** Harici üye
- **Sekreter:** İdari işler

---

## 📊 Başvuru Türleri

1. **Yeni Başvuru**
   - İlk kez başvuru yapma

2. **İsim Değişikliği**
   - Başvuru sahibinin adını değiştirme

3. **Konu Başlığı Değişikliği**
   - Araştırma konusu değişikliği

4. **İçerik Değişikliği**
   - Araştırma metodolojisi vb. değişiklikler

---

## 🔄 Başvuru Durumları

```
pending (Beklemede)
    ↓
[Admin Karar]
    ├→ approved (Onaylandı)
    ├→ rejected (Red)
    └→ revision (Değişiklik)
         ↓
       [Hoca Revize]
         ↓
       pending (Tekrar Beklemede)
```

---

## 📈 Yıllık Sayı Üretimi

- **Her yıl sayaç sıfırlanır**
- Onay verilirken oturum tarihi + oturum numarası kaydedilir
- Sistem otomatik sayı üretir: `2026/1`, `2026/2`, vb.
- Örnek: 2025'te 300. başvuru → 2026'da tekrar 1. başvurudan başlar

---

## 🔐 Güvenlik

### Authentication
- JWT token tabanlı
- Email doğrulaması zorunlu
- Şifre bcrypt ile hash'lenir

### Authorization
- Role-based access control (RBAC)
- Her endpoint izin kontrol eder
- Audit trail (denetim izi) tutulur

### Veri Güvenliği
- HTTPS gerekli (production)
- SQL injection koruması
- CSRF token kullanımı
- XSS koruması

---

## 📖 Dokümantasyon

Proje dokümantasyonunda aşağıdakiler bulunur:

### 1. [DATABASE_DESIGN.md](./docs/DATABASE_DESIGN.md)
- 8 tablo yapısı
- ER diagram
- İlişkiler ve indeksler
- Veri örneği

### 2. [API_ENDPOINTS.md](./docs/API_ENDPOINTS.md)
- 24+ API endpoint detayı
- Request/Response örnekleri
- Error handling
- Rate limiting

### 3. [USER_ROLES.md](./docs/USER_ROLES.md)
- 8 rol tanımı
- İzin matrisi
- Rol kombinasyonları
- Güvenlik kontrol örnekleri

### 4. [APPLICATION_FLOW.md](./docs/APPLICATION_FLOW.md)
- 7 detaylı senaryo
- Adım adım işlem akışı
- Veritabanı state değişimleri
- Email bildirimler

---

## 🛠️ Geliştirme

### Lokal Kurulum (Docker olmadan)

```bash
# Dependencies yükle
npm install

# PostgreSQL'e bağlan
createdb etik_kurul_db -U etik_user

# Veritabanını başlat
psql etik_kurul_db -U etik_user < database/init.sql

# .env.local oluştur
cp .env.example .env.local

# Development server başlat
npm run dev
```

### Ortam Değişkenleri

`.env.local` dosyasını oluştur:

```env
DATABASE_URL=postgresql://etik_user:etik_password@localhost:5432/etik_kurul_db
NEXTAUTH_SECRET=your-secret-key
NEXTAUTH_URL=http://localhost:3000
JWT_SECRET=your-jwt-secret
```

### Development Script'leri

```bash
# Development server
npm run dev

# Production build
npm run build

# Production server
npm start

# Linter kontrol
npm run lint

# Database migration (gelecek)
npm run migrate

# Tests (gelecek)
npm test
```

---

## 🐳 Docker Komutları

### Başlat
```bash
docker-compose up -d
```

### Durdur
```bash
docker-compose down
```

### Logları Görüntüle
```bash
docker-compose logs -f nextjs
```

### Veritabanına Erişim
```bash
docker-compose exec postgres psql -U etik_user -d etik_kurul_db
```

### Reset (Tüm verileri sil)
```bash
docker-compose down -v
docker-compose up -d
```

---

## 📱 API Kullanım Örneği

### Giriş Yap

```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@etikkurul.com",
    "password": "admin123"
  }'
```

### Başvuru Oluştur

```bash
curl -X POST http://localhost:3000/api/applications \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "subject": "Başvuru Konusu",
    "helperResearchers": "Yardımcı 1, Yardımcı 2",
    "studyYear": 2026
  }'
```

Daha fazla örnek için [API_ENDPOINTS.md](./docs/API_ENDPOINTS.md) dosyasına bakın.

---

## 🚀 Deployment

### Production Checklist

- [ ] `.env.local` dosyasını özel değerlerle güncelle
- [ ] `NEXTAUTH_SECRET` güçlü bir key olarak ayarla
- [ ] Database backup sistemi kur
- [ ] HTTPS sertifikası kur
- [ ] Güvenlik duvarı ayarlarını kontrol et
- [ ] Log monitoring kur
- [ ] Email servisi konfigüre et

### Heroku Deployment (Örnek)

```bash
heroku create etik-kurul
heroku addons:create heroku-postgresql:standard-0

git push heroku main
```

---

## 🐛 Troubleshooting

### Veritabanı bağlantı hatası

```bash
# PostgreSQL çalışıyor mu kontrol et
docker-compose logs postgres

# Bağlantı stringini kontrol et
# .env.local'daki DATABASE_URL
```

### Port zaten kullanımda

```bash
# Port'u değiştir
docker-compose.yml içinde 3000:3000 → 3001:3000
```

### Email gönderimi çalışmıyor

```bash
# SMTP ayarlarını kontrol et
# .env.local'daki SMTP_* değerlerini
```

---

## 📞 Destek

Sorun veya soru için:

1. GitHub Issues'de sorun oluştur
2. Dokümantasyonu kontrol et
3. API_ENDPOINTS.md'de örnek bak

---

## 📄 Lisans

Bu proje [MIT License](LICENSE) altında lisanslanmıştır.

---

## 👨‍💼 Katkıda Bulunanlar

- **Geliştirici:** Erkan TAN

---

## 🗓️ Versiyon

**Versiyon:** 1.0.0  
**Son Güncelleme:** 2026-05-12  
**Durum:** Alpha (Geliştirme aşaması)

---

## 📋 Yapılacak İşler (Roadmap)

- [ ] Frontend sayfaları kodla
- [ ] Backend API'sini kodla
- [ ] Email şablonları hazırla
- [ ] PDF rapor oluşturma
- [ ] Excel export
- [ ] İstatistik dashboard'u
- [ ] Bildirim sistemi
- [ ] Unit testler
- [ ] Integration testler
- [ ] Performance optimization
- [ ] Docker production image

---

Başlamaya hazırsan: `docker-compose up -d` 🚀
