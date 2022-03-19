import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/http_exception.dart';

import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expireDate;
  String? _userID;

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
    } catch (error) {
      rethrow;
    }
  }
}
