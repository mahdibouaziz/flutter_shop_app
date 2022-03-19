import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/http_exception.dart';

import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expireDate;
  String? _userId;

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

  String get userId {
    return _userId as String;
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
      notifyListeners();
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
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
