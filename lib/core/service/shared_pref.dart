import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart';

class SharedPref {
  SharedPreferences? sharedPref;

  Future<SharedPreferences> get _instance async =>
      sharedPref ??= await SharedPreferences.getInstance();

  Future<SharedPreferences> init() async {
    sharedPref = await _instance;
    return sharedPref!;
  }

  Future<bool> save({required String key, required dynamic value}) async {
    if (sharedPref == null) await init();
    switch (value.runtimeType) {
      case const (String):
        return await sharedPref!.setString(key, value);
      case const (bool):
        return await sharedPref!.setBool(key, value);
      case const (int):
        return await sharedPref!.setInt(key, value);
      case const (double):
        return await sharedPref!.setDouble(key, value);
      default:
        return await sharedPref!.setString(key, jsonEncode(value));
    }
  }   
  Future<bool> saveAccessToken(String token) async {
    if (sharedPref == null) await init();
    accessToken = token;
    return sharedPref!.setString('accessToken', token);
  }

  Future<String?> loadAccessToken() async {
    if (sharedPref == null) await init();
    final token = sharedPref!.getString('accessToken');
    accessToken = token;
    return token;
  }

  Future<bool> removeAccessToken() async {
    if (sharedPref == null) await init();
    accessToken = null;
    return sharedPref!.remove('accessToken');
  }

  logout() async {
    if (sharedPref == null) await init();
    await sharedPref!.clear();
    // userLoginedData = null;
    await Future.delayed(const Duration(milliseconds: 200));
    // Screen.openAsNewPage(LoginView());
  }
}
