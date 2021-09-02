import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitAuthForm, this.isLoading);
  final Function submitAuthForm;
  final bool isLoading;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _isLogin = true;
  String userEmail = '';
  String userPassword = '';
  String userName = '';
  File pickedImage;

  var _formKey = GlobalKey<FormState>();

  void _pickImage(File image) {
    pickedImage = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (pickedImage == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('No Image Found'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitAuthForm(
        userEmail.trim(),
        userPassword.trim(),
        pickedImage,
        userName,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) UserImagePicker(_pickImage),
                  TextFormField(
                    key: ValueKey('email'),
                    onSaved: (value) {
                      userEmail = value;
                    },
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                    ),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      onSaved: (value) {
                        userName = value;
                      },
                      decoration: InputDecoration(labelText: 'User Name'),
                      validator: (value) {
                        if (value.isEmpty || value.length <= 3) {
                          return 'Please check your Username';
                        } else {
                          return null;
                        }
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                    validator: (value) {
                      if (value.isEmpty || value.length <= 6) {
                        return 'Please check your password';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      userPassword = value;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading)
                    Center(child: CircularProgressIndicator()),
                  if (!widget.isLoading)
                    RaisedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'Sign in to your account'),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
