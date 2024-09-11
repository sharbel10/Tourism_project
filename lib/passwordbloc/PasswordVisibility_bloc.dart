// Define the events
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PasswordVisibilityEvent {}
class ToggleLoginPasswordVisibility extends PasswordVisibilityEvent {}
class ToggleSignupPasswordVisibility extends PasswordVisibilityEvent {}
class ToggleConfirmPasswordVisibility extends PasswordVisibilityEvent {}

// Define the BLoC
class PasswordVisibilityBloc extends Bloc<PasswordVisibilityEvent, Map<String, bool>> {
  PasswordVisibilityBloc() : super({'login': true, 'signup': true,'confirm':true}) { // Initially password is obscured for both
    on<ToggleLoginPasswordVisibility>((event, emit) {
      emit({...state, 'login': !state['login']!}); // Toggle the login password visibility
    });
    on<ToggleSignupPasswordVisibility>((event, emit) {
      emit({...state, 'signup': !state['signup']!}); // Toggle the signup password visibility
    });
    on<ToggleConfirmPasswordVisibility>((event, emit) {
      emit({...state, 'confirm': !state['confirm']!}); // Toggle the confirm password visibility
    });
  }
}