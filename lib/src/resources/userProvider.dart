import 'dart:convert';

import 'package:http/http.dart' as http;
class UserProvider{

String _firebaseToken = 'AIzaSyDaToikvzqRTxlWW1meXoLM828ilYNFD6U';

  Future newUser (String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final response = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodeResponse = json.decode(response.body);
      print(decodeResponse.toString());
    if(decodeResponse.containsKey('idToken')){
      //TODO: save token in storage
      return {'ok': true, 'token': decodeResponse['idToken']};
    }else{
      return {'ok': false, 'message': decodeResponse['error']['message']};
    }


  }

}