import 'package:firebase_auth/firebase_auth.dart';

import 'firebaseProvider.dart';

class FirebaseRepository {
  final _provider = FirebaseProvider();

  Future<FirebaseUser> gogleSignIn() async => _provider.signInWithGoogle();
}