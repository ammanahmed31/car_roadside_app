import 'dart:convert';
import 'dart:developer';

import 'package:car_roadsside_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      String username = _userNameController.text;
      String password = _passwordController.text;
      String email = _emailController.text;
      String address = _addressController.text;
      String mobile = _mobileController.text;
      String name = _nameController.text;
      Map<String, String> requestBody = {
        "name": name,
        "username": username,
        "email": email,
        "address": address,
        "mobile_no": mobile,
        "password": password,
      };
      print('url: ${APIConstants.registerURL}');
      try {
        final response = await http.post(
          Uri.parse(APIConstants.registerURL),
          body: requestBody,
        );
        if (response.statusCode == 201) {
          print('Response data: ${response.body}');
          var data = json.decode(response.body);
          print('Parsed data: $data');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              showCloseIcon: true,
              duration: Duration(seconds: 1),
              content: Text(data['message']),
            ),
          );
          Navigator.pop(context);
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            showCloseIcon: true,
            content: Text('An Error occured please try again later.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // TextFormFields for name, username, email, address, mobile, and password
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextFormField(
                controller: _mobileController,
                decoration: InputDecoration(labelText: 'Mobile Number'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: _registerUser,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
