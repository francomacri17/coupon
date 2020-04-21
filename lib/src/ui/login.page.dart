import 'package:coupon_app/src/blocs/login.bloc.dart';
import 'package:coupon_app/src/resources/blocProvider.dart';
import 'package:coupon_app/src/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatelessWidget {
  LoginBloc bloc;
  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<LoginBloc>(context);
    StreamBuilder(
        stream: bloc.userStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot != null) {
            _loginWithGoogle(context);
          } else {
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
        });
  }

  _drawLoginForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Stack(
        children: <Widget>[
          _createBackground(context),
          _loginForm(context),
        ],
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
        child: Column(children: <Widget>[
      SafeArea(
        child: Container(
          height: 180.0,
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 50.0),
        width: size.width * 0.85,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: <BoxShadow>[
              (BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(
                    5.0,
                    5.0,
                  ),
                  spreadRadius: 3.0))
            ]),
        child: Column(children: <Widget>[
          Text(
            "Login",
            style: TextStyle(fontSize: 30.0),
          ),
          SizedBox(
            height: 60.0,
          ),
          _createEmailForm(),
          SizedBox(
            height: 30.0,
          ),
          _createPasswordForm(),
          SizedBox(
            height: 60.0,
          ),
          _createButton(),
          SizedBox(
            height: 30.0,
          ),
          _buildSignInGoogleButton(context),
        ]),
      ),
      SizedBox(
        height: 30.0,
      ),
      FlatButton(
          child: Text('You are not registered?'),
          onPressed: () => Navigator.pushReplacementNamed(context, 'signUp')),
    ]));
  }

  Widget _createEmailForm() {
    return StreamBuilder(
        stream: bloc.emailStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
                    hintText: 'expample@email.com',
                    labelText: 'Email',
                    counterText: snapshot.data,
                    errorText: snapshot.error),
                onChanged: bloc.changeEmail,
              ));
        });
  }

  Widget _createPasswordForm() {
    return StreamBuilder(
        stream: bloc.passwordStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                decoration: InputDecoration(
                    icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
                    labelText: 'Password',
                    errorText: snapshot.error),
                onChanged: bloc.changePassword,
              ));
        });
  }

  Widget _createButton() {
    return StreamBuilder(
        stream: bloc.formValidForm,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return RaisedButton(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
              child: Text('Enter'),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 0.0,
            color: Colors.deepPurple,
            textColor: Colors.white,
            onPressed: snapshot.hasData ? () => _loginWithEmail(context) : null,
          );
        });
  }

  _loginWithEmail(BuildContext context) async {
    await bloc.loginWithEmail();
    if (bloc.user != null) {
      Navigator.of(context).pushReplacementNamed('home');
    } else {
      showAlert(context, 'Login failed', 'Login failed');
    }
  }

  _buildSignInGoogleButton(BuildContext context) {
    return StreamBuilder(
        stream: bloc.userStream,
        builder: (BuildContext ctx, AsyncSnapshot<FirebaseUser> snapshot) {
          return SignInButton(
            Buttons.Google,
            text: "Sign up with Google",
            onPressed: () => !snapshot.hasData
                ? () {
                    bloc.loginWithGoogle();
                    if (bloc.user != null) {
                      Navigator.pushReplacementNamed(context, 'home');
                    } else {
                      showAlert(context, 'Error', 'Login failed');
                    }
                  }
                : _loginWithGoogle(context),
          );
        });
  }

  _loginWithGoogle(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('home');
  }

  Widget _createBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final background = Container(
        height: size.height * 0.4,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: <Color>[
          Color.fromRGBO(63, 63, 156, 1.0),
          Color.fromRGBO(90, 70, 178, 1.0)
        ])));
    return Stack(
      children: <Widget>[
        background,
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(children: <Widget>[
            Icon(
              Icons.person_pin_circle,
              color: Colors.white,
              size: 100.0,
            ),
            SizedBox(
              height: 10.0,
              width: double.infinity,
            ),
            Text(
              'Coupon',
              style: TextStyle(color: Colors.white, fontSize: 25.0),
            ),
          ]),
        ),
      ],
    );
  }
}
