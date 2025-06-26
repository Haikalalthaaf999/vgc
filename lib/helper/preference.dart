import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const String _tokenKey = 'auth_token';
  static const String _isLoggedInKey = 'is_logged_in';

  // Save login token
  static Future<void> saveLoginToken(String token) async {
    print('Preferences: Saving token: $token');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setBool(_isLoggedInKey, true);
    print('Preferences: Token saved successfully');
  }

  // Get token from preferences
  static Future<String?> getToken() async {
    print('Preferences: Getting token...');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    print('Preferences: Retrieved token: $token');
    return token;
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    print('Preferences: Checking login status...');
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    print('Preferences: Login status: $isLoggedIn');
    return isLoggedIn;
  }

  // Remove token (logout)
  static Future<void> removeToken() async {
    print('Preferences: Removing token...');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.setBool(_isLoggedInKey, false);
    print('Preferences: Token removed successfully');
  }

  // Clear all preferences
  static Future<void> clearAll() async {
    print('Preferences: Clearing all preferences...');
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('Preferences: All preferences cleared');
  }
}
