
import 'UserClass.dart';



abstract class User_State{
  List<User> users;
  User_State({ required this.users});
}
class Initial_User_State extends User_State{
  Initial_User_State({required List<User> users }): super (users: users);
}
class Changed_User_State extends User_State{
  Changed_User_State({required List<User> users}): super (users:  users);
}
