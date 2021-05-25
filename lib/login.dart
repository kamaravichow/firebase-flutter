import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:crypto/crypto.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  int _pageState = 0;

  // variables for phone auth
  var _verificationId = "";
  int _resendToken;

  var _backgroundColor = Colors.white;
  var _textColor = Colors.black;

  double _loginYOffset = 0;
  double _loginXoffset = 0;
  double _loginWidth = 0;
  double _loginOpacity = 1;

  bool _isImageVisible = true;
  bool _showAppleSignIn = true;
  bool _showGoogleSignIn = true;

  double _signupYOffset = 0;

  double windowWidth = 0;
  double windowHeight = 0;

  double _titlePadding = 60;

  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    if (Platform.isAndroid) {
      _showAppleSignIn = false;
      _showGoogleSignIn = true;
      // enable google sign in
    } else if (Platform.isIOS) {
      // enable apple sign in
      _showGoogleSignIn = false;
      _showAppleSignIn = true;
    }

    switch (_pageState) {
      case 0:
        _backgroundColor = Colors.white;
        _textColor = Colors.black;
        _titlePadding = 60;

        _loginYOffset = windowHeight;
        _loginXoffset = 0;
        _loginOpacity = 1;
        _loginWidth = windowWidth;

        _signupYOffset = windowHeight;

        _isImageVisible = true;
        break;
      case 1:
        _backgroundColor = Colors.lightBlue[500];
        _textColor = Colors.white;
        _titlePadding = 42;

        _loginYOffset = 180;
        _loginXoffset = 0;
        _loginOpacity = 1;
        _loginWidth = windowWidth;

        _signupYOffset = windowHeight;
        _isImageVisible = false;
        break;
      case 2:
        _backgroundColor = Colors.lightBlue[500];
        _textColor = Colors.white;
        _titlePadding = 40;

        _loginYOffset = 160;
        _loginXoffset = 20;
        _loginOpacity = 0.7;
        _loginWidth = windowWidth - 40;

        _signupYOffset = 180;
        _isImageVisible = false;
        break;
    }

    return Stack(
      children: <Widget>[
        AnimatedContainer(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: Duration(milliseconds: 1000),
          color: _backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    _pageState = 0;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.fastLinearToSlowEaseIn,
                    padding: EdgeInsets.all(_titlePadding),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Gratitude",
                          style: TextStyle(
                            color: _textColor,
                            fontSize: 32,
                          ),
                        ),
                        Text(
                          "An antidote of dissatisfaction",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: _textColor),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.fastLinearToSlowEaseIn,
                padding: EdgeInsets.all(_titlePadding),
                child: Center(
                  child: Visibility(
                      visible: _isImageVisible,
                      child: Image.asset("assets/images/getstarted.png")),
                ),
              ),
              Container(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _pageState = 1;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(35),
                    padding: EdgeInsets.all(14),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.lightBlue[500],
                        borderRadius: BorderRadius.circular(50)),
                    child: Center(
                        child: Text(
                      "Get started",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    )),
                  ),
                ),
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _pageState = 2;
            });
          },
          child: AnimatedContainer(
            width: _loginWidth,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(milliseconds: 1000),
            transform:
                Matrix4.translationValues(_loginXoffset, _loginYOffset, 1),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(_loginOpacity),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              // Input column
              child: Column(
                children: <Widget>[
                  Text(
                    "Enter Your Phone Number                    ",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "We'll use it to verify your account, but never to identify you.     \nWe'll also never call you or share your data.           ",
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5)),
                    child: InternationalPhoneNumberInput(
                      ignoreBlank: false,
                      initialValue: number,
                      onInputChanged: (PhoneNumber phoneNumber) {
                        //todo on phone entered
                        print(phoneNumber.phoneNumber);
                        number = phoneNumber;
                      },
                      locale: Platform.localeName,
                      selectorConfig: SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        showFlags: false,
                      ),
                      onSaved: (PhoneNumber pNumber) {
                        number = pNumber;
                        print("saved:" + pNumber.phoneNumber);
                      },
                    ),
                  ),

                  // Continue Button -------------------------
                  Container(
                    child: GestureDetector(
                      onTap: () async {
                        await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: number.phoneNumber,
                            verificationCompleted:
                                (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {
                              print("Failed : " + e.message);
                              if (e.message.contains("cancelled by the use")) {
                                print("dialog now");
                              }
                            },
                            codeSent: (String id, int resendToken) {
                              _verificationId = id;
                              _resendToken = resendToken;
                              setState(() {
                                _pageState = 2;
                              });
                              // enter otp box
                              print("sent");
                            },
                            codeAutoRetrievalTimeout: (String verificationId) {
                              print("timeout :");
                            });
                      },
                      child: Container(
                        margin: EdgeInsets.all(15),
                        padding: EdgeInsets.all(14),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.lightBlue[500],
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                            child: Text(
                          "Continue",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        )),
                      ),
                    ),
                  ),

                  Divider(),

                  // Google Sign in button
                  Visibility(
                    visible: _showGoogleSignIn,
                    child: Container(
                      child: GestureDetector(
                        onTap: () {
                          _signInWithGoogle(context);
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.red[300],
                              borderRadius: BorderRadius.circular(50)),
                          child: Center(
                              child: Row(
                            children: [
                              Image.asset(
                                "assets/images/google.png",
                                width: 28,
                                height: 28,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: Text(
                                  "Sign in with Google",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ),
                      ),
                    ),
                  ),

                  // Apple Sign in button
                  Visibility(
                    visible: false,
                    child: Container(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _pageState = 2;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(50)),
                          child: Center(
                              child: Row(
                            children: [
                              Image.asset(
                                "assets/images/apple.png",
                                width: 28,
                                height: 28,
                                color: Colors.white,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: Text(
                                  "Sign in with Apple",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: AnimatedContainer(
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(milliseconds: 1000),
            transform: Matrix4.translationValues(0, _signupYOffset, 1),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
          ),
        )
      ],
    );
  }
}

Future<void> _signInWithGoogle(BuildContext context) async {
  try {
    UserCredential userCredential;
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final user = userCredential.user;
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('Sign In ${user.uid} with Google'),
    ));
  } catch (e) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('Failed to sign in with Google: $e'),
    ));
  }
}
