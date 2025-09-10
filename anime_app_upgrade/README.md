Lann Anime App - Upgrade (Example)
=================================

Fitur:
- Home (Ongoing, Complete, Popular)
- Search
- Detail + Episode list
- Video Player (Chewie)
- Favorites (shared_preferences)
- Watch history & resume (shared_preferences)
- Dark Mode
- Filter by Genre

Cara jalankan:
1. Pastikan Flutter SDK terinstall.
2. Buka folder project (anime_app_upgrade).
3. Jalankan:
   flutter pub get
   flutter run

Build release APK:
   flutter build apk --release

Catatan:
- Player memerlukan URL video langsung (http/https). API harus menyediakan link playable.
- Jika API field beda, sesuaikan di services/api_service.dart
