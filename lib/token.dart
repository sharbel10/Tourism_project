import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  String? _token;

  factory TokenManager() {
    return _instance;
  }

  TokenManager._internal();

  Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('login_token');
  }

  String? get token => _token;
}
