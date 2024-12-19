import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login.dart';
import 'enrollment_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<Map<String, dynamic>?> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('students')
          .doc(user.uid)
          .get();
      return doc.data();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Retro Header
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  border: Border(
                    bottom: BorderSide(color: AppTheme.secondaryColor, width: 3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'DASHBOARD',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                            color: AppTheme.textLight,
                            fontFamily: 'Playfair Display',
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.logout),
                          color: AppTheme.textLight,
                          onPressed: () async {
                            await _auth.signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      user?.email ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textLight.withOpacity(0.9),
                        fontFamily: 'Roboto Slab',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(24),
                child: FutureBuilder<Map<String, dynamic>?>(
                  future: _getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.secondaryColor,
                        ),
                      );
                    }

                    final userData = snapshot.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AppTheme.secondaryColor, width: 2),
                            ),
                          ),
                          child: Text(
                            'YOUR INFORMATION',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: AppTheme.primaryColor,
                              fontFamily: 'Playfair Display',
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.cardColor,
                            border: Border.all(
                              color: AppTheme.secondaryColor.withOpacity(0.5),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow('Name', userData?['name'] ?? 'Not set'),
                              SizedBox(height: 16),
                              _buildInfoRow('Email', user?.email ?? 'Not set'),
                              SizedBox(height: 16),
                              _buildInfoRow('Status', userData?['status'] ?? 'Not enrolled'),
                            ],
                          ),
                        ),
                        SizedBox(height: 32),
                        ElevatedButton(
                          style: AppTheme.elevatedButtonStyle,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EnrollmentPage()),
                            );
                          },
                          child: Text(
                            'ENROLL NOW',
                            style: TextStyle(
                              letterSpacing: 2,
                              fontFamily: 'Roboto Slab',
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.textSecondary,
              fontFamily: 'Roboto Slab',
              letterSpacing: 1,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textPrimary,
              fontFamily: 'Roboto Slab',
            ),
          ),
        ),
      ],
    );
  }
}
