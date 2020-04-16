import 'package:coupon_app/src/resources/blocProvider.dart';
import 'package:coupon_app/src/resources/firebaseRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc implements BlocBase{
  FirebaseRepository _repository;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // Stream Controller
  BehaviorSubject<FirebaseUser> _google = BehaviorSubject<FirebaseUser>();

  // Stream
  Stream<FirebaseUser> get googleAccount => _google.stream;

  LoginBloc(){
    _repository = FirebaseRepository();
    _firebaseAuth.currentUser().then((FirebaseUser user){
      _google.sink.add(user);
    });
  }

  googleSignIn() async {
    _repository.gogleSignIn().then((FirebaseUser authUser){
      _google.sink.add(authUser);
    });
  }

  googleLogOut(){
    _repository.googleSignOut().then(_google.sink.add);
  }

  dispose(){
    _google.close();
  }
}