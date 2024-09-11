import 'package:flutter/foundation.dart';

import 'UserClass.dart';

@immutable
abstract class UserList_Event{}
class Add_User extends UserList_Event{
final User user;
  Add_User({required this.user});
}
class Delete_User extends UserList_Event{
  final User user;

  Delete_User({required this.user});
}
class Update_User extends UserList_Event{
  final User user;

  Update_User({required this.user});

}