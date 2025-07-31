import 'package:flutter/material.dart';
import 'home_screen.dart';

enum LoginType {
  email,
  phone,
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginType _selectedLoginType = LoginType.email;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final String identifier = _identifierController.text.trim();
    final String password = _passwordController.text.trim();

    if (identifier.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all fields.')),
      );
      return;
    }

    bool isValidIdentifier = false;
    String validationMessage = '';

    if (_selectedLoginType == LoginType.email) {
      if (identifier.contains('@') && identifier.contains('.')) {
        isValidIdentifier = true;
      } else {
        validationMessage = 'Please enter a valid email address.';
      }
    } else {
      if (identifier.length >= 7 && int.tryParse(identifier) != null) {
        isValidIdentifier = true;
      } else {
        validationMessage = 'Please enter a valid phone number.';
      }
    }

    if (isValidIdentifier) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logging in with $_selectedLoginType: $identifier')),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DropdownButtonFormField<LoginType>(
                value: _selectedLoginType,
                decoration: const InputDecoration(
                  labelText: 'Login Method',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.login),
                ),
                onChanged: (LoginType? newValue) {
                  setState(() {
                    _selectedLoginType = newValue!;
                    _identifierController.clear();
                  });
                },
                items: const <DropdownMenuItem<LoginType>>[
                  DropdownMenuItem<LoginType>(
                    value: LoginType.email,
                    child: Text('Login with Email'),
                  ),
                  DropdownMenuItem<LoginType>(
                    value: LoginType.phone,
                    child: Text('Login with Phone Number'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _identifierController,
                decoration: InputDecoration(
                  labelText: _selectedLoginType == LoginType.email ? 'Email' : 'Phone Number',
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(_selectedLoginType == LoginType.email ? Icons.email : Icons.phone),
                ),
                keyboardType: _selectedLoginType == LoginType.email
                    ? TextInputType.emailAddress
                    : TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
