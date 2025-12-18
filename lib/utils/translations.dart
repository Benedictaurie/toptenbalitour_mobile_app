class AppTranslations {
  static Map<String, Map<String, String>> translations = {
    'id': {
      // Common
      'app_name': 'TOPTEN BALI TOUR',
      'loading': 'Memuat...',
      'save': 'Simpan',
      'cancel': 'Batal',
      'delete': 'Hapus',
      'edit': 'Edit',
      'close': 'Tutup',
      'ok': 'OK',
      'yes': 'Ya',
      'no': 'Tidak',
      'search': 'Cari',
      'refresh': 'Refresh',
      
      // Auth
      'login': 'Masuk',
      'logout': 'Keluar',
      'register': 'Daftar',
      'email': 'Email',
      'password': 'Kata Sandi',
      'forgot_password': 'Lupa Kata Sandi?',
      
      // Profile
      'profile': 'Profil',
      'profile_user': 'Profil Pengguna',
      'edit_profile': 'Edit Profil',
      'full_name': 'Nama Lengkap',
      'phone_number': 'Nomor Telepon',
      'address': 'Alamat',
      'role': 'Peran',
      'profile_picture': 'Foto Profil',
      'change_photo': 'Ubah Foto',
      'save_changes': 'Simpan Perubahan',
      'profile_updated': 'Profil berhasil diperbarui',
      'photo_selected': 'Foto dipilih. Klik "Simpan Perubahan" untuk upload',
      'new_photo_selected': 'Foto baru dipilih',
      'email_cannot_changed': 'Email tidak dapat diubah',
      'not_filled': 'Belum diisi',
      'profile_info': 'Informasi Profil',
      
      // Settings
      'settings': 'Pengaturan',
      'notification': 'Notifikasi',
      'notification_enabled': 'Notifikasi diaktifkan',
      'notification_disabled': 'Notifikasi dinonaktifkan',
      'activate_notification': 'Aktifkan Notifikasi',
      'language': 'Bahasa',
      'language_region': 'Bahasa & Wilayah',
      'app_language': 'Bahasa Aplikasi',
      'choose_language': 'Pilih Bahasa',
      'about_app': 'Tentang Aplikasi',
      'version': 'Versi',
      'reset_settings': 'Reset Pengaturan',
      'reset_to_default': 'Kembalikan ke pengaturan default',
      'reset_confirm': 'Apakah Anda yakin ingin mengembalikan semua pengaturan ke default?',
      'settings_reset': 'Pengaturan direset',
      'language_changed': 'Bahasa diubah ke',
      'others': 'Lainnya',
      
      // Dashboard
      'dashboard': 'Dashboard',
      'booking': 'Booking',
      'driver': 'Driver',
      
      // Messages
      'try_again': 'Coba Lagi',
      'failed_load_profile': 'Gagal memuat profil',
      'logout_confirm': 'Konfirmasi Logout',
      'logout_message': 'Apakah Anda yakin ingin keluar?',
      
      // Gallery/Camera
      'choose_profile_photo': 'Pilih Foto Profil',
      'from_gallery': 'Pilih dari Galeri',
      'take_photo': 'Ambil Foto',
      'upload_feature_coming': 'Fitur upload foto akan segera hadir',
    },
    'en': {
      // Common
      'app_name': 'TOPTEN BALI TOUR',
      'loading': 'Loading...',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'close': 'Close',
      'ok': 'OK',
      'yes': 'Yes',
      'no': 'No',
      'search': 'Search',
      'refresh': 'Refresh',
      
      // Auth
      'login': 'Login',
      'logout': 'Logout',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'forgot_password': 'Forgot Password?',
      
      // Profile
      'profile': 'Profile',
      'profile_user': 'User Profile',
      'edit_profile': 'Edit Profile',
      'full_name': 'Full Name',
      'phone_number': 'Phone Number',
      'address': 'Address',
      'role': 'Role',
      'profile_picture': 'Profile Picture',
      'change_photo': 'Change Photo',
      'save_changes': 'Save Changes',
      'profile_updated': 'Profile updated successfully',
      'photo_selected': 'Photo selected. Click "Save Changes" to upload',
      'new_photo_selected': 'New photo selected',
      'email_cannot_changed': 'Email cannot be changed',
      'not_filled': 'Not filled',
      'profile_info': 'Profile Information',
      
      // Settings
      'settings': 'Settings',
      'notification': 'Notification',
      'notification_enabled': 'Notification enabled',
      'notification_disabled': 'Notification disabled',
      'activate_notification': 'Activate Notification',
      'language': 'Language',
      'language_region': 'Language & Region',
      'app_language': 'App Language',
      'choose_language': 'Choose Language',
      'about_app': 'About App',
      'version': 'Version',
      'reset_settings': 'Reset Settings',
      'reset_to_default': 'Reset to default settings',
      'reset_confirm': 'Are you sure you want to reset all settings to default?',
      'settings_reset': 'Settings reset',
      'language_changed': 'Language changed to',
      'others': 'Others',
      
      // Dashboard
      'dashboard': 'Dashboard',
      'booking': 'Booking',
      'driver': 'Driver',
      
      // Messages
      'try_again': 'Try Again',
      'failed_load_profile': 'Failed to load profile',
      'logout_confirm': 'Logout Confirmation',
      'logout_message': 'Are you sure you want to logout?',
      
      // Gallery/Camera
      'choose_profile_photo': 'Choose Profile Photo',
      'from_gallery': 'From Gallery',
      'take_photo': 'Take Photo',
      'upload_feature_coming': 'Upload photo feature coming soon',
    },
  };

  static String translate(String key, String languageCode) {
    final lang = languageCode == 'English' ? 'en' : 'id';
    return translations[lang]?[key] ?? key;
  }
}
