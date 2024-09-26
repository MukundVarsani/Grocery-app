import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static Future<void> saveToken(String uid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("UID", uid);
  }

  static Future<String> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('UID').toString();
  }

  static Future<bool> removeToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getString('UID').toString();
    return preferences.remove('UID');
  }
}
