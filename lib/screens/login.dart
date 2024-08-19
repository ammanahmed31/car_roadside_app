import 'dart:convert';
import 'dart:developer';

import 'package:car_roadsside_app/screens/edit_profile.dart';
import 'package:car_roadsside_app/screens/registration.dart';
import 'package:car_roadsside_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/custom_textfeild.dart';
import '../widgets/gradient_background.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences sp;
  bool hidePassword = true;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      sp = await SharedPreferences.getInstance();
    });
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String username = _userNameController.text;
      String password = _passwordController.text;
      Map<String, String> requestBody = {"username": username, "password": password};
      print('url: ${APIConstants.loginURL}');
      print('body: $requestBody');
      inspect(requestBody);
      try {
        final response = await http.post(
          Uri.parse(APIConstants.loginURL),
          body: requestBody,
        );
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          print('Parsed data: $data');
          sp.setString('token', data['token']);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              showCloseIcon: true,
              duration: Duration(seconds: 1),
              content: Text(data['message']),
            ),
          );
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return EditProfilePage(userName: username);
          }));
        } else {
          print('Request failed with status: ${response.statusCode}');
          log('ressponce: ${response.body}');
          var errorMap = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              showCloseIcon: true,
              content: Text(errorMap["error"]),
            ),
          );
        }
      } catch (e, s) {
        print('Error occurred: $e, stackTrace: $s');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackgroundScreen(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 1.8),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 30),
              CustomTextField(
                controller: _userNameController,
                labelText: 'Username',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: hidePassword,
                suffixIcon: IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 50),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, letterSpacing: 1.8),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'OR',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 1.8),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return RegistrationPage();
                        },
                      ),
                    );
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, letterSpacing: 1.8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
