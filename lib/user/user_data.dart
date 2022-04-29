import 'dart:convert';

import 'user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  static  SharedPreferences _preferences;
  static const _keyUser = 'user';

  static User myUser = User(
    image:
        "https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png",
    name: 'Name',
    email: 'Email ID',
    phone: 'Phone number',
    department: 'Department',
    designation: 'Designation',
    otherrole: 'HOD/Class Teacher',
  );

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(User user) async {
    final json = jsonEncode(user.toJson());

    await _preferences.setString(_keyUser, json);
  }

  static User getUser() {
    final json = _preferences.getString(_keyUser);

    return json == null ? myUser : User.fromJson(jsonDecode(json));
  }
}
