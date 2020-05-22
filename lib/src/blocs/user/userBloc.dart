import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:coupon_app/src/blocs/user/userEvent.dart';
import 'package:coupon_app/src/blocs/user/userState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:coupon_app/src/utils/validators.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseUser _user;

  FirebaseUser get getUser => _user;

  UserBloc({@required FirebaseUser user})
      : assert(user != null),
        _user = user;

  @override
  UserState get initialState => UserState.empty();

  @override
  Stream<Transition<UserEvent, UserState>> transformEvents(
    Stream<UserEvent> events,
    TransitionFunction<UserEvent, UserState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(event.email, event.password);
    }
  }

  Stream<UserState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<UserState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<UserState> _mapFormSubmittedToState(
    String email,
    String password,
  ) async* {
    yield UserState.loading();
    try {
      // await _userRepository.signUp(
      //   email: email,
      //   password: password,
      // );
      yield UserState.success();
    } catch (_) {
      yield UserState.failure();
    }
  }
}