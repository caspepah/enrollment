import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import 'register.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 60),
              // Retro Header
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppTheme.secondaryColor, width: 2),
                    bottom: BorderSide(color: AppTheme.secondaryColor, width: 2),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                        color: AppTheme.primaryColor,
                        fontFamily: 'Playfair Display',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppTheme.textSecondary,
                        fontFamily: 'Roboto Slab',
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email Field
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.5), width: 2),
                      ),
                      child: TextFormField(
                        decoration: AppTheme.inputDecoration('Email', Icons.email),
                        validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) => setState(() => email = val),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Password Field
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.5), width: 2),
                      ),
                      child: TextFormField(
                        decoration: AppTheme.inputDecoration('Password', Icons.lock),
                        obscureText: true,
                        validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                        onChanged: (val) => setState(() => password = val),
                      ),
                    ),
                    SizedBox(height: 30),
                    // Login Button
                    ElevatedButton(
                      style: AppTheme.elevatedButtonStyle,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() => error = 'Invalid credentials');
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage()),
                            );
                          }
                        }
                      },
                      child: Text('LOGIN'),
                    ),
                    if (error.isNotEmpty) ...[
                      SizedBox(height: 20),
                      Text(
                        error,
                        style: TextStyle(
                          color: AppTheme.errorColor,
                          fontSize: 14,
                          fontFamily: 'Roboto Slab',
                        ),
                      ),
                    ],
                    SizedBox(height: 30),
                    // Register Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account? ',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontFamily: 'Roboto Slab',
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterScreen()),
                          ),
                          child: Text(
                            'Register here',
                            style: TextStyle(
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto Slab',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
