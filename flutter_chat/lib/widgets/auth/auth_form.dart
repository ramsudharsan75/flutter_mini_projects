import 'dart:io';

import 'package:flutter/material.dart';

import '../../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
      {required String email,
      required String password,
      String? username,
      File? image,
      required bool isLogin}) submitFn;
  final bool isLoading;

  const AuthForm(this.submitFn, this.isLoading, {super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please pick an image'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        email: _userEmail.trim(),
        isLogin: _isLogin,
        password: _userPassword.trim(),
        username: _userName.trim(),
        image: _userImageFile,
      );
      // Use those values to send our auth request to firebase
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (!_isLogin)
                UserImagePicker(
                  imagePickFn: _pickedImage,
                ),
              TextFormField(
                key: const ValueKey('email'),
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                enableSuggestions: false,
                onSaved: (newValue) {
                  _userEmail = newValue!;
                },
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                ),
              ),
              TextFormField(
                key: const ValueKey('password'),
                onSaved: (newValue) {
                  _userPassword = newValue!;
                },
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return 'Password must be atleast 7 characters long.';
                  }
                  return null;
                },
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              if (!_isLogin)
                TextFormField(
                  key: const ValueKey('username'),
                  enableSuggestions: false,
                  onSaved: (newValue) {
                    _userName = newValue!;
                  },
                  validator: (value) {
                    if (value == null || value.length < 4) {
                      return 'Please enter atleast 4 characters';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                ),
              const SizedBox(
                height: 12,
              ),
              if (widget.isLoading) const CircularProgressIndicator(),
              if (!widget.isLoading)
                ElevatedButton(
                  onPressed: _trySubmit,
                  child: _isLogin ? const Text('Login') : const Text('Signup'),
                ),
              if (!widget.isLoading)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: _isLogin
                      ? const Text('Create new account')
                      : const Text('I already have an account'),
                )
            ]),
          ),
        ),
      ),
    ));
  }
}
