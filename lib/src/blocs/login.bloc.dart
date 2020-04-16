import 'package:coupon_app/src/resources/blocProvider.dart';
import 'package:coupon_app/src/resources/firebaseRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc implements BlocBase{
  FirebaseRepository _repository;
  
  // Stream Controller
  BehaviorSubject<FirebaseUser> _google = BehaviorSubject<FirebaseUser>();

  // Stream
  Stream<FirebaseUser> get googleAccount => _google.stream;

  LoginBloc(){
    _repository = FirebaseRepository();
  }

  googleSignIn() async {
    _repository.gogleSignIn().then((FirebaseUser authUser){
      _google.sink.add(authUser);
    });
  }

  dispose(){
    _google.close();
  }
}