import 'package:firebase_auth/firebase_auth.dart';
import 'firebaseProvider.dart';

class FirebaseRepository {
  final _provider = FirebaseProvider();

  Future<FirebaseUser> login(LoginProviders loginProvider, String email, String password) async 
                                          => _provider.login(loginProvider, email, password);
                                          }
