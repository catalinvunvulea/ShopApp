import 'dart:convert'; //enable us to use json.encode

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../model/http_exception.dart';

class Auth with ChangeNotifier {
  String
      _token; //tokens usually expire; on firebase after 1 h, hence it's good to have a date var'
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token !=
        null; //if token (the getter) is not = null, we return true (we are authenticated) otherwise false
  }
  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token; //if condition is meat, and we return _token, the code stops here
    }
    return null;
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
    // const url =
    //     "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDAqLnPg9f-3aE39w94WIPaX5Wc3gIDIyE"; //url from https://firebase.google.com/docs/reference/rest/auth - signUp email password; link was originally "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key==[API_KEY]" but instead of [api key] we took web API Key from firebase, auth, setting
    // final response = await http.post(
    //   url, //ulr is where we post (add) the data,
    //   body: json.encode(
    //     // body is what we send, a map of, key names are as per on the erver
    //     {
    //       'email': email,
    //       'password': password,
    //       'returnSecureToken': _token,
    //     },
    //   ),
    // );
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
    //if i wouldn't refactor:
    // const url =
    //     'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDAqLnPg9f-3aE39w94WIPaX5Wc3gIDIyE';
    // final response = await http.post(
    //   url, //ulr is where we post (add) the data,
    //   body: json.encode(
    //     // body is what we send, a map of, key names are as per on the erver
    //     {
    //       'email': email,
    //       'password': password,
    //       'returnSecureToken': _token,
    //     },
    //   ),
    // );
  }

  Future<void> _authenticate(
      //used to refactor signUp and login
      String email,
      String password,
      String urlSegmentDifference) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegmentDifference?key=AIzaSyDAqLnPg9f-3aE39w94WIPaX5Wc3gIDIyE';
    try {
      final response = await http.post(
        url, //ulr is where we post (add) the data,
        body: json.encode(
          // body is what we send, a map of, key names are as per on the erver
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      //print(response.body);
      final responseData = json.decode(response.body);
      //print(responseData['error']);
      if (responseData['error'] != null) {
        //check if we receive an error form firebase - only invalidation error (error of invalid user, or incorrect password)
        throw HttpException(responseData['error']
            ['message']); //we throw the message that is received from firebase
      }
      _token = responseData['idToken']; //idToken - name form firebase
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData[
              'expiresIn']), //from firebase, we receive a string of number of seconds untill the token expires; here we use now time to add the no of seconds (convert them to int) and calculate the exact date, time, hour, min, sec when the token will expire
        ),
      );
      notifyListeners(); //we wish to trigger the Consumer from Main, to rebuilt, and chose which screen to show
    } catch (error) {
      throw error;
    }
  }
}