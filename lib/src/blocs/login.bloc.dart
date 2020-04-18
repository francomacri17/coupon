import 'dart:async';
import 'package:coupon_app/src/blocs/validators.bloc.dart';
import 'package:coupon_app/src/resources/blocProvider.dart';
import 'package:coupon_app/src/resources/firebaseRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators implements BlocBase{
  
  FirebaseRepository _repository;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Stream Controller
  BehaviorSubject<FirebaseUser> _googleController = BehaviorSubject<FirebaseUser>();
  BehaviorSubject<String> _emailController = BehaviorSubject<String>();
  BehaviorSubject<String> _passwordController = BehaviorSubject<String>();

  // Stream
  Stream<FirebaseUser> get googleAccount => _googleController.stream;
  Stream<String> get emailStream => _emailController.stream.transform(validateEmail);
  Stream<String> get passwordSteam => _passwordController.stream.transform(validatePassword);
  Stream<bool> get formValidForm => 
    Rx.combineLatest2(emailStream, passwordSteam, (e,p) => true);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  String get email => _emailController.value;
  String get password => _passwordController.value;

  LoginBloc(){
    _repository = FirebaseRepository();
    _firebaseAuth.currentUser().then((FirebaseUser user){
      _googleController.sink.add(user);
    });
  }

  googleSignIn() async {
    _repository.gogleSignIn().then((FirebaseUser authUser){
      _googleController.sink.add(authUser);
    });
  }

  googleLogOut(){
    _repository.googleSignOut().then(_googleController.sink.add);
  }

  dispose(){
    _googleController.close();
    _emailController.close();
    _passwordController.close();
  }
}