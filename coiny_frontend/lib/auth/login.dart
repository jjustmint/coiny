import 'dart:convert';
import 'package:coiny_frontend/auth/signup.dart';
import 'package:coiny_frontend/components/addMoney.dart';
import 'package:coiny_frontend/main.dart';
import 'package:coiny_frontend/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;

  @override
  void initState() {
    super.initState();
  }

  String parseToken(String responseBody) {
    try {
      var jsonResponse = jsonDecode(responseBody);
      if (jsonResponse['token'] != null) {
        return jsonResponse['token'];
      } else {
        return '';
      }
    } catch (e) {
      print('Error parsing JSON: $e');
      return '';
    }
  }

  void login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final apiURL = 'http://10.0.2.2:4000/auth/login';
        if (usernameController.text.isNotEmpty &&
            passwordController.text.isNotEmpty) {
          var response = await http.post(Uri.parse(apiURL),
              headers: <String, String>{'Content-Type': 'application/json'},
              body: jsonEncode(<String, dynamic>{
                "username": usernameController.text,
                "password": passwordController.text,
              }));
          if (response.statusCode == 200) {
            print('Login successfully');
            final mytoken = parseToken(response.body);
            print('Token: $mytoken');
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyApp(
                        token: mytoken,
                      )),
            );
          } else {
            setState(() {
              errorMessage = 'Incorrect username or password';
            });
            print('Failed to login: ${response.body}');
          }
        }
      } catch (e) {
        print('ERROR: $e');
        print(usernameController.text);
        print(passwordController.text);
      }
    }
  }

  String? validationPassword(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  String? validationUsername(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your username';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE2D2),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100, bottom: 40),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 170, // Adjust size of the circle
                          height: 170, // Adjust size of the circle
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey
                                .withOpacity(0.5), // Adjust opacity and color
                          ),
                        ),
                        const Icon(
                          Icons.person,
                          size: 150,
                          // Set icon color to white
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Center(
                    child: Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
                  child: TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFFFF3EC),
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Color(0xFFFFF3EC)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 15.0), // Adjust vertical padding
                    ),
                    validator: validationUsername,
                  ),
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFFFF3EC),
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Color(0xFFFFF3EC)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 15.0), // Adjust vertical padding
                  ),
                  validator: validationPassword,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: errorMessage != null
                      ? Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red),
                        )
                      : SizedBox.shrink(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 0.0),
                  child: Center(
                    child: ElevatedButton(
                        onPressed: () {
                          login();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFF5CCB4), // Background color
                        ),
                        child: const Text('Login',
                            style: TextStyle(color: Color(0xFF95491E)))),
                  ),
                ),
                Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SignUpPage();
                        }));
                      },
                      child: const Text('Sign up?')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
