import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> user;

  EditProfilePage({required this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _userNameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _mobileController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user['name']);
    _userNameController = TextEditingController(text: widget.user['username']);
    _emailController = TextEditingController(text: widget.user['email']);
    _addressController = TextEditingController(text: widget.user['address']);
    _mobileController = TextEditingController(text: widget.user['mobile']);
  }

  void _updateUser() async {
    if (_formKey.currentState!.validate()) {
      // Map<String, dynamic> row = {
      //   DatabaseHelper.columnId: widget.user['id'],
      //   DatabaseHelper.columnName: _nameController.text,
      //   DatabaseHelper.columnUserName: _userNameController.text,
      //   DatabaseHelper.columnEmail: _emailController.text,
      //   DatabaseHelper.columnAddress: _addressController.text,
      //   DatabaseHelper.columnMobile: _mobileController.text,
      // };
      // await DatabaseHelper.instance.update(row);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profile updated successfully'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
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
                    return 'Please enter your username';
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUser,
                child: Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
