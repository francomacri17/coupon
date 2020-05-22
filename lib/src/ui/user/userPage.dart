import 'package:coupon_app/src/blocs/user/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserPage extends StatelessWidget {
  final FirebaseUser _user;

  UserPage({Key key, @required FirebaseUser user})
      : assert(user != null),
        _user = user,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('User page')),
        body: ListView(
          children: <Widget>[
          Container(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 80.0,
                  backgroundColor: Colors.black,
                  backgroundImage: _user.photoUrl != null
                      ? NetworkImage(_user.photoUrl)
                      : NetworkImage(
                          'https://i.ibb.co/3mPYm2N/Deafult-Profile-Pitcher.png'),
                ),
              )),
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.blue,
            width: double.infinity,
            height: 100,
          ),
          Container(
            color: Colors.red,
            width: double.infinity,
            height: 100,
          ),
          Container(
            color: Colors.greenAccent,
            width: double.infinity,
            height: 100,
          ),
                    Container(
            color: Colors.blue,
            width: double.infinity,
            height: 100,
          ),
                    Container(
            color: Colors.red,
            width: double.infinity,
            height: 100,
          ),
                    Container(
            color: Colors.blue,
            width: double.infinity,
            height: 100,
          ),
        ]));
  }
}
