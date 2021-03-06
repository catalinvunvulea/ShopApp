import 'dart:convert'; //enable us to use json.encode
import 'dart:async'; //to set a timer

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/http_exception.dart';

class Auth with ChangeNotifier {
  String
      _token; //tokens usually expire; on firebase after 1 h, hence it's good to have a date var'
  DateTime _expiryDate;
  String _userId;

  Timer _authTimer;

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
      _token = responseData['idToken']; //idToken - name from firebase
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData[
              'expiresIn']), //from firebase, we receive a string of number of seconds untill the token expires; here we use now time to add the no of seconds (convert them to int) and calculate the exact date, time, hour, min, sec when the token will expire
        ),
      );
      _autoLogot();
      notifyListeners(); //we wish to trigger the Consumer from Main, to rebuilt, and chose which screen to show
      final prefs = await SharedPreferences
          .getInstance(); //this return a future, hence awiat, as w edon't want to store a future in prefs but a value
      final userData = json.encode({
        //we use json as we wish to store a map
        'token': _token,
        'userId': _userId,
        'exiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData',
          userData); //we store the data on the device (with a key, and as Data we reated a Map using the json)
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences
        .getInstance(); //we fetch the data (it can be empty)
    if (!prefs.containsKey('userData')) {
      //if the prefs don't contain a key with that name, we return false
      return false;
    }
    //if we do get something, we will extract the data
    final extractedUserData = json.decode(prefs.getString('userData'))
        as Map<String, Object>; //prefs.getString('userData') returns a string hence we use json.decode as Map
    final expiryDate = DateTime.parse(extractedUserData['exiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      //check if the token is still valid
      return false;
    }
    //if the token is still valid, we can use the extracted data
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogot(); //to set the timmer
    return true;
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
     
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    //prefs.clear //to delete all stored data, but sometimes we wish to keep something and we should target what to remove, using  prefs.remove('userData'); for us, clear would work fine as we only store one data
  }

  void _autoLogot() {
    if (_authTimer != null) {
      //we verivy if there is alredy a timmer on the screen, and if there is, we cancel it
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
