import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/components/background.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/Screens/Home/home_screen.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

var _userText;
var _passText;

class Body extends StatefulWidget {
  Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
    _userText = '';
    _passText = '';
  }

  void ingresar(var user, var password) async {
    try {
      var url = 'https://server2-jair-luna.vercel.app/api/auth/login';
      var response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, String> {
            'email': user,
            'password': password,
          })
      ).timeout(const Duration(seconds: 90));

      print(response.body);

      if(response.body == 'Usuario y/o contraseña incorrecta'){
        CupertinoAlertDialog(
            title: Text("Usuario o Contraseña Incorrectos"),
            content:Text("Intente Otra Vez")
        );
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return HomeScreen();
        }));
      }

    } on TimeoutException catch (e) {
      print('Tiempo de conexión tardado');
    } on Error catch(e) {
      CupertinoAlertDialog(
          title: Text("Usuario o Contraseña Incorrectos"),
          content:Text("Intente Otra Vez")
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "EMAIL",
              onChanged: (value) {
                setState(() {
                  _userText = value;
                });
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                setState(() {
                  _passText = value;
                });
              },
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                if (_userText != '' && _passText != '') {
                  ingresar(_userText, _passText);
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );

  }
}
