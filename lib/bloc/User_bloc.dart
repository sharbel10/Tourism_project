import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:comeback/bloc/UserList_Event.dart';
import 'package:comeback/bloc/User_State.dart';
class User_bloc extends Bloc<UserList_Event,User_State> {
  User_bloc() : super(Initial_User_State(users: [])) {
    on<Add_User>(add_user);
    on<Delete_User>(delete_user);
    on<Update_User>(update_user);
  }
  void add_user(Add_User event, Emitter<User_State> emit) {
    state.users.add(event.user);
    emit(Changed_User_State(users: state.users));
  }

  void delete_user(Delete_User event, Emitter<User_State> emit) {
    state.users.remove(event.user);
    emit(Changed_User_State(users: state.users));
  }

  void update_user(Update_User event, Emitter<User_State> emit) {
    for (int i = 0; i < state.users.length; i++) {
      if (event.user.id==state.users[i].id){
        state.users[i]=event.user;
      }
    }
    emit(Changed_User_State(users: state.users));
  }
}