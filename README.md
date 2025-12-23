# Deployment ke cPanel

Repository ini siap untuk di-deploy ke cPanel public_html.

## Repository GitHub
https://github.com/asruldev/testing.git

## Metode Deployment

### Metode 1: Menggunakan Script rsync (Recommended)

Script ini menggunakan rsync untuk mentransfer file via SSH ke cPanel.

#### Langkah-langkah:

1. **Setup konfigurasi:**
   ```bash
   cp deploy.conf.example deploy.conf
   nano deploy.conf  # atau gunakan editor favorit Anda
   ```

2. **Isi konfigurasi di deploy.conf:**
   ```conf
   CPANEL_HOST="cpanel.yourdomain.com"  # atau IP server
   CPANEL_USER="your_cpanel_username"
   REMOTE_PATH="~/public_html"
   SSH_PORT="22"  # atau port SSH Anda jika berbeda
   ```

3. **Buat script executable:**
   ```bash
   chmod +x deploy.sh
   ```

4. **Jalankan deployment:**
   ```bash
   ./deploy.sh
   ```

**Catatan:** Pastikan SSH key sudah di-setup atau Anda siap memasukkan password SSH.

---

### Metode 2: Menggunakan Git di cPanel (Paling Mudah)

cPanel memiliki fitur Git Version Control yang bisa langsung pull dari GitHub.

#### Langkah-langkah:

1. **Login ke cPanel**

2. **Buka "Git Version Control"** (di bagian Software)

3. **Klik "Create"** untuk membuat repository baru

4. **Isi form:**
   - **Repository Path:** `public_html` (atau subfolder jika perlu)
   - **Repository URL:** `https://github.com/asruldev/testing.git`
   - **Repository Branch:** `main` (atau branch yang digunakan)
   - **Auto Deploy:** ✅ Centang untuk auto-deploy setiap push

5. **Klik "Create"**

6. Setelah itu, setiap kali Anda push ke GitHub, cPanel akan otomatis pull update (jika Auto Deploy aktif), atau Anda bisa manual klik "Pull or Deploy" di cPanel.

---

### Metode 3: Manual via File Manager atau FTP

1. **Clone repository lokal:**
   ```bash
   git clone https://github.com/asruldev/testing.git
   cd testing
   ```

2. **Upload file ke cPanel:**
   - Via File Manager di cPanel (upload satu per satu)
   - Via FTP client (FileZilla, WinSCP, dll)
   - Upload semua file ke folder `public_html`

---

## File Structure

```
.
├── index.html          # File utama
├── deploy.sh          # Script deployment (metode 1)
├── deploy.conf.example # Template konfigurasi
├── deploy.conf        # Konfigurasi aktual (tidak di-commit)
├── .gitignore
└── README.md
```

## Tips

- **SSH Key Setup:** Untuk deployment via rsync, disarankan setup SSH key agar tidak perlu input password setiap kali
- **Backup:** Selalu backup file di public_html sebelum deployment pertama kali
- **Testing:** Test di localhost atau subdomain terlebih dahulu sebelum deploy ke production

