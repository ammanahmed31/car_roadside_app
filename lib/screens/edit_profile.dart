// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:car_roadsside_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import '../widgets/custom_textfeild.dart';
import '../widgets/gradient_background.dart';

class EditProfilePage extends StatefulWidget {
  final String userName;
  const EditProfilePage({Key? key, required this.userName}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  bool isDetailsLoading = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  late SharedPreferences sp;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      sp = await SharedPreferences.getInstance();
      await _getUserDetails();
    });
  }

  void _updateUser() async {
    if (_formKey.currentState!.validate()) {
      String username = _userNameController.text;
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
      };
      print('url: ${APIConstants.updateUserURL}');
      try {
        final response = await http.put(
          Uri.parse(APIConstants.updateUserURL),
          body: requestBody,
          headers: {"Authorization": 'Bearer ${sp.getString('token')}'},
        );
        if (response.statusCode == 200) {
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

  Future<void> _getUserDetails() async {
    setState(() {
      isDetailsLoading = true;
    });
    print('url: ${APIConstants.getUserDetailsURL}/${widget.userName}');
    try {
      final response = await http.get(
        Uri.parse('${APIConstants.getUserDetailsURL}/${widget.userName}'),
        headers: {"Authorization": 'Bearer ${sp.getString('token')}'},
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print('Parsed data: $data');
        User user = User.fromMap(data);
        sp.setString('user', user.toJson());
        _nameController = TextEditingController(text: user.name);
        _userNameController = TextEditingController(text: user.userName);
        _emailController = TextEditingController(text: user.email);
        _addressController = TextEditingController(text: user.address);
        _mobileController = TextEditingController(text: user.mobileNumber);
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
    } finally {
      setState(() {
        isDetailsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackgroundScreen(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 1.8),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: isDetailsLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: _nameController,
                      labelText: 'Name',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
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
                      controller: _emailController,
                      labelText: 'Email',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: _addressController,
                      labelText: 'Address',
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: _mobileController,
                      labelText: 'Mobile Number',
                    ),
                    SizedBox(height: 20),
                    SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: _updateUser,
                      child: Text(
                        'Update Profile',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, letterSpacing: 1.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
