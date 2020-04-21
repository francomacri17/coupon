import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:coupon_app/src/userPreferences/userPreferences.dart';
import 'package:http/http.dart' as http;

class FirebaseProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final _prefs = new UserPreferences();
  String _firebaseKey = 'AIzaSyDaToikvzqRTxlWW1meXoLM828ilYNFD6U';

  Future<AuthResult> getAuthFromGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<FirebaseUser> getUserFromGoogle() async {
    AuthResult authResult = await this.getAuthFromGoogle();
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return user;
  }

  Future<void> googleSignOut() async {
    this._auth.signOut();
    return await this.googleSignOut();
  }

  Future<FirebaseUser> loginWithEmail(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseKey',
        body: json.encode(authData));

    Map<String, dynamic> decodeResponse = json.decode(response.body);

    print(decodeResponse.toString());
    if (decodeResponse.containsKey('idToken')) {
      
      saveToken(decodeResponse['idToken']);

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: decodeResponse['accessToken'],
        idToken: decodeResponse['idToken'],
      );

      var auth = await _auth.signInWithCredential(credential);

      return auth.user;
    }
  }

  Future<FirebaseUser> loginWithGoogle() async {
    FirebaseUser firebaseUser = await getUserFromGoogle();
    var tokenId = await firebaseUser.getIdToken();
    if (tokenId.token != null) {
      _prefs.token = tokenId.token;
    }
    return firebaseUser;
  }

  void saveToken(String token) {
    _prefs.token = token;
  }

  Future<Map<String, dynamic>> newUser(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseKey',
        body: json.encode(authData));

    Map<String, dynamic> decodeResponse = json.decode(response.body);
    print(decodeResponse.toString());
    if (decodeResponse.containsKey('idToken')) {
      _prefs.token = decodeResponse['idToken'];
      return {'ok': true, 'token': decodeResponse['idToken']};
    } else {
      return {'ok': false, 'message': decodeResponse['error']['message']};
    }
  }
}
