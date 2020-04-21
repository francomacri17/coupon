import 'package:firebase_auth/firebase_auth.dart';
import 'firebaseProvider.dart';

class FirebaseRepository {
  final _provider = FirebaseProvider();

  Future<FirebaseUser> loginWithGoogle() async => _provider.loginWithGoogle();

  Future<FirebaseUser> loginWithEmail(
          String email, String password) async =>
      _provider.loginWithEmail(email, password);

  Future<Map<String, dynamic>> newUser(String email, String password) async => _provider.newUser(email, password);
}
