# Peace Valley Radiant Mission — Flutter Android app starter

## Included in this increment
- PIN/password-style local admin gate (first launch: create a 4–12 digit PIN; stored as SHA-256 hash, not plain text)
- SQLite local database
- Add/list students, mark daily attendance, record fee payments, record teacher salary payments
- Bengali/English toggle
- Basic PDF fee receipt generation/print/share using `pdf` + `printing`
- Dashboard and report summary

## Run/build (requires a computer with Flutter SDK and Android SDK)
1. Extract this ZIP.
2. In the extracted folder run `flutter create . --platforms=android`
3. Run `flutter pub get`
4. Run `flutter run` to test, or `flutter build apk --debug` to build a test APK.
5. APK path: `build/app/outputs/flutter-apk/app-debug.apk`

## Important security/production notes
- This is an early local/offline implementation, not a production-audited system.
- The PIN gate is local-only. It does not provide remote identity verification or recovery. Keep device access protected and make backups.
- Cloud sync is not connected yet; the Sync screen explicitly shows this.
- PDF receipt Bengali font embedding may require adding a Bengali TTF font asset before Bengali glyphs render correctly in PDFs.
- Test on a real Android device before using real student/financial records. No APK is included because this environment has no Flutter/Android build toolchain.
