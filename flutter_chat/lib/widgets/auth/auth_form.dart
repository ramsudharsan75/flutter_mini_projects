import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
      {required String email,
      required String password,
      String? username,
      required bool isLogin}) submitFn;

  const AuthForm(this.submitFn, {super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
          email: _userEmail,
          isLogin: _isLogin,
          password: _userPassword,
          username: _userName);
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
              TextFormField(
                key: const ValueKey('email'),
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
              ElevatedButton(
                onPressed: _trySubmit,
                child: _isLogin ? const Text('Login') : const Text('Signup'),
              ),
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
