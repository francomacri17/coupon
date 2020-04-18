import 'package:coupon_app/src/blocs/login.bloc.dart';
import 'package:coupon_app/src/resources/blocProvider.dart';
import 'package:coupon_app/src/resources/userProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignUpPage extends StatelessWidget {
  LoginBloc bloc;
  final userProvider = new UserProvider();
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
        child: _drawSignUpForm(context),
      ),
    );
  }

  _drawSignUpForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Stack(
        //mainAxisAlignment: MainAxisAlignment.end,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _createBackground(context),
          _signUpForm(context),
          //_buildUserInfo(context),
          //_buildSignUpButton(context)
        ],
      ),
    );
  }

  _buildSignUpButton(BuildContext context) {
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
              child: Text('Enter'),
            )
          ]);
        }
      },
    );
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

  Widget _signUpForm(BuildContext context) {
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
            "Register",
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
          _createSignUpButton(),
          SizedBox(
            height: 30.0,
          ),
        ]),
      ),
      SizedBox(
        height: 30.0,
      ),
      FlatButton(
          child: Text('Arledy register?'),
          onPressed: () => Navigator.pushReplacementNamed(context, 'login')),
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
        stream: bloc.passwordSteam,
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

  Widget _createSignUpButton() {
    return StreamBuilder(
        stream: bloc.formValidForm,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return RaisedButton(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
              child: Text('Register'),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 0.0,
            color: Colors.deepPurple,
            textColor: Colors.white,
            onPressed: snapshot.hasData ? () => _register(context) : null,
          );
        });
  }

  _register(BuildContext context) {
    userProvider.newUser(bloc.email, bloc.password);
  }
}
