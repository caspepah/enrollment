import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String name = '';
  String error = '';
  bool loading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      dynamic result = await _auth.registerWithEmailAndPassword(
        email,
        password,
        name,
      );

      setState(() {
        loading = false;
      });

      if (result == null) {
        setState(() {
          error = 'Registration failed. Please try again.';
        });
      } else {
        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: AppTheme.successColor,
                        size: 40,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Registration Successful!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Your account has been created successfully. Please login to continue.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        'Go to Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    }
  }

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
              SizedBox(height: 40),
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
                      'REGISTER',
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
                      'Create Your Account',
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
              SizedBox(height: 40),
              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Name Field
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.5), width: 2),
                      ),
                      child: TextFormField(
                        decoration: AppTheme.inputDecoration('Full Name', Icons.person),
                        validator: (val) => val!.isEmpty ? 'Enter your name' : null,
                        onChanged: (val) => setState(() => name = val),
                      ),
                    ),
                    SizedBox(height: 20),
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
                    // Register Button
                    ElevatedButton(
                      style: AppTheme.elevatedButtonStyle,
                      onPressed: loading ? null : _register,
                      child: loading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: AppTheme.textLight,
                                strokeWidth: 2,
                              ),
                            )
                          : Text('REGISTER'),
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
                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontFamily: 'Roboto Slab',
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          ),
                          child: Text(
                            'Login here',
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
