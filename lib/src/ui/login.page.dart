import 'package:coupon_app/src/blocs/login.bloc.dart';
import 'package:coupon_app/src/resources/blocProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatelessWidget {
  LoginBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<LoginBloc>(context);
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Color.fromRGBO(70, 0, 0, 0), BlendMode.darken),
                image: new NetworkImage(
                    'https://i.etsystatic.com/10951470/r/il/0e9685/869999991/il_fullxfull.869999991_4ubt.jpg'))),
        child: _drawLoginForm(context),
      ),
    );
  }

  _drawLoginForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildUserInfo(context),
          _buildSignInButton(context)
        ],
      ),
    );
  }

  _buildSignInButton(BuildContext context) {
    return StreamBuilder(
        stream: bloc.googleAccount,
        builder: (BuildContext ctx, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            return Container();
          } else {
            return SignInButton(
              Buttons.Google,
              text: "Sign up with Google",
              onPressed: () {
                bloc.googleSignIn();
              },
            );
          }
        });
  }

  _buildUserInfo(BuildContext context) {
    return StreamBuilder(
      stream: bloc.googleAccount,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          return Column(children: <Widget>[
            Container(
              width: 100.0,
              height: 100.0,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    image: new NetworkImage(snapshot.data.photoUrl.toString()),
                    fit: BoxFit.fill),
              ),
              margin: EdgeInsets.only(bottom: 10.0),
            ),
            Text(
              "Hola ${snapshot.data.displayName}",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
            ),
            RaisedButton(
              child: Text('Entrar'),
            )
          ]);
        }
      },
    );
  }
}
