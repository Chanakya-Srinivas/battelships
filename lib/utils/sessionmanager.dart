import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _sessionKey = 'sessionToken';
  static const String _sessionUserName = 'userName';

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionToken = prefs.getString(_sessionKey);
    return sessionToken != null;
  }

  static Future<String> getSessionToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey) ?? '';
  }

  static Future<void> setSessionToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, token);
  }

  static Future<String> getSessionUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionUserName) ?? '';
  }

  static Future<void> setSessionUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionUserName, userName);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    await prefs.remove(_sessionUserName);
  }
}
