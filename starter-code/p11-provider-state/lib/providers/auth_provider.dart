import 'package:flutter/foundation.dart';

/// Sesi pengguna — contoh provider kedua (state lintas screen).
///
/// Di app nyata: hasil signIn dari API (P09) disimpan di sini,
/// token di-restore saat app restart (lihat modul bab 7).
class AuthProvider extends ChangeNotifier {
  String? _email;

  String? get userEmail => _email;

  bool get isSignedIn => _email != null;

  /// Simulasi signIn — tanpa backend.
  Future<bool> signIn(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!email.contains('@') || password.length < 6) return false;
    _email = email;
    notifyListeners();
    return true;
  }

  void signOut() {
    _email = null;
    notifyListeners();
  }
}
