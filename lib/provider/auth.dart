import 'dart:convert'; //enable us to use json.encode

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String
      _token; //tokens usually expire; on firebase after 1 h, hence it's good to have a date var'
  DateTime _expiryDate;
  String _userId;

  Future<void> signUp(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDAqLnPg9f-3aE39w94WIPaX5Wc3gIDIyE"; //url from https://firebase.google.com/docs/reference/rest/auth - signUp email password; link was originally "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key==[API_KEY]" but instead of [api key] we took web API Key from firebase, auth, setting
    final response = await http.post(
      url, //ulr is where we post (add) the data,
      body: json.encode(
        // body is what we send, a map of, key names are as per on the erver
        {
          'email': email,
          'password': password,
          'returnSecureToken': _token,
        },
      ),
    );
    print(json.decode(response.body));
  }
}
