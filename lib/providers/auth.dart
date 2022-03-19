import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/http_exception.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expireDate;
  String? _userId;

  Timer? authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expireDate != null &&
        _expireDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token as String;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> logout() async {
    _token = null;
    _expireDate = null;
    _userId = null;
    if (authTimer != null) {
      authTimer!.cancel();
      authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();

    notifyListeners();
  }

  void _autoLogout() {
    if (authTimer != null) {
      authTimer!.cancel();
    }

    int timeToLogout = _expireDate!.difference(DateTime.now()).inSeconds;
    authTimer = Timer(
      Duration(seconds: timeToLogout),
      logout,
    );
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    // verify we have stored data
    if (!prefs.containsKey("userData")) {
      return false;
    }

    final extractedUserData = json.decode(prefs.getString("userData") as String)
        as Map<String, dynamic>;

    // verify the expire date
    final expireDate = DateTime.parse(extractedUserData['expireDate']);
    if (!expireDate.isAfter(DateTime.now())) {
      return false;
    }

    // re define the data
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expireDate = expireDate;
    notifyListeners();
    _autoLogout();

    return true;
  }

  Future<void> signup(String email, String password) async {
    final uri = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA9bNaNX-Y_S5nVacVWfOluTea1OROVQfM");
    try {
      final response = await http.post(uri,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));

      // print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['errors']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();

      final userData = json.encode({
        "token": _token,
        "userId": _userId,
        "expireDate": _expireDate?.toIso8601String(),
      });

      prefs.setString("userData", userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    final uri = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA9bNaNX-Y_S5nVacVWfOluTea1OROVQfM");
    try {
      final response = await http.post(uri,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));

      // print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['errors']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();

      final userData = json.encode({
        "token": _token,
        "userId": _userId,
        "expireDate": _expireDate?.toIso8601String(),
      });

      prefs.setString("userData", userData);
    } catch (error) {
      rethrow;
    }
  }
}
