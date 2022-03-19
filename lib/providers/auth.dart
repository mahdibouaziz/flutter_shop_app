import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expireDate;
  String? _userID;

  Future<void> signup(String email, String password) async {
    final uri = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA9bNaNX-Y_S5nVacVWfOluTea1OROVQfM");

    final response = await http.post(uri,
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }));

    print(json.decode(response.body));
  }
}
