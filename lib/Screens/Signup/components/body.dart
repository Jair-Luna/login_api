import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/components/background.dart';
import 'package:flutter_auth/Screens/Signup/components/or_divider.dart';
import 'package:flutter_auth/Screens/Signup/components/social_icon.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

var _nameText;
var _lastnameText;
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
    _nameText = '';
    _lastnameText = '';
    _userText = '';
    _passText = '';
  }

  void registrar(var name, var lastname, var user, var password) async {
    try {
      var url = 'https://server2-jair-luna.vercel.app/api/auth/register';
      final response = await http
          .post(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, String>{
              'nombre': name,
              'apellido': lastname,
              'email': user,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 90));

      if (response.statusCode == 200) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return (WelcomeScreen());
        }));
      }
    } catch (e) {
      print('Tiempo de conexión tardado');
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
              "REGISTRAR",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
              hintText: "NOMBRE",
              onChanged: (value) {
                setState(() {
                  _nameText = value;
                });
              },
            ),
            RoundedInputField(
              hintText: "APELLIDO",
              onChanged: (value) {
                setState(() {
                  _lastnameText = value;
                });
              },
            ),
            RoundedInputField(
              hintText: "CORREO ELECTRONICO",
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
              text: "REGISTRAR",
              press: () {
                if (_nameText != '' &&
                    _lastnameText != '' &&
                    _userText != '' &&
                    _passText != '') {
                  registrar(_nameText, _lastnameText, _userText, _passText);
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            OrDivider(),
            Row()
          ],
        ),
      ),
    );
  }
}
