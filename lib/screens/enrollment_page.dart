import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/subject.dart';
import '../services/subject_service.dart';
import '../theme/app_theme.dart';

class EnrollmentPage extends StatefulWidget {
  @override
  _EnrollmentPageState createState() => _EnrollmentPageState();
}

class _EnrollmentPageState extends State<EnrollmentPage> {
  final SubjectService _subjectService = SubjectService();
  List<Subject> availableSubjects = [];
  Set<Subject> selectedSubjects = {};
  int totalCredits = 0;
  final int maxCredits = 24;
  bool isLoading = false;
  bool isEnrolled = false;

  @override
  void initState() {
    super.initState();
    selectedSubjects = {};
    totalCredits = 0;
    checkEnrollmentStatus();
  }

  Future<void> checkEnrollmentStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final studentDoc = await FirebaseFirestore.instance
          .collection('students')
          .doc(user.uid)
          .get();

      if (studentDoc.exists) {
        final enrolledSubjects = studentDoc.data()?['enrolledSubjects'] as List<dynamic>?;
        setState(() {
          isEnrolled = enrolledSubjects != null && enrolledSubjects.isNotEmpty;
        });
        if (isEnrolled) {
          loadEnrollmentData(studentDoc.data()!);
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void loadEnrollmentData(Map<String, dynamic> data) {
    setState(() {
      selectedSubjects.clear();
      final List<dynamic> enrolledSubjects = data['enrolledSubjects'] ?? [];
      for (var subjectData in enrolledSubjects) {
        final subject = Subject(
          name: subjectData['name'] ?? '',
          credits: subjectData['credits'] ?? 0,
        );
        if (subject.name.isNotEmpty) {
          selectedSubjects.add(subject);
        }
      }
      totalCredits = data['totalCredits'] ?? 0;
    });
  }

  void toggleSubject(Subject subject) {
    setState(() {
      if (selectedSubjects.contains(subject)) {
        selectedSubjects.remove(subject);
        totalCredits -= subject.credits;
      } else {
        if (totalCredits + subject.credits <= maxCredits) {
          selectedSubjects.add(subject);
          totalCredits += subject.credits;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Maximum credits exceeded'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  Future<void> saveEnrollment() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('students').doc(user.uid).update({
          'enrolledSubjects': selectedSubjects
              .map((subject) => {
                    'name': subject.name,
                    'credits': subject.credits,
                  })
              .toList(),
          'totalCredits': totalCredits,
        });

        setState(() {
          isEnrolled = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Enrollment successful!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to save enrollment',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Widget _buildSubjectCard(Subject subject, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        border: Border.all(
          color: isSelected ? AppTheme.secondaryColor : AppTheme.secondaryColor.withOpacity(0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnrolled ? null : () => toggleSubject(subject),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.secondaryColor.withOpacity(0.2) : AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected ? AppTheme.secondaryColor : AppTheme.secondaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.book,
                    color: isSelected ? AppTheme.secondaryColor : AppTheme.textSecondary,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                          fontFamily: 'Roboto Slab',
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${subject.credits} Credits',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                          fontFamily: 'Roboto Slab',
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: AppTheme.textLight,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          isEnrolled ? 'ENROLLMENT SUMMARY' : 'COURSE ENROLLMENT',
          style: TextStyle(
            color: AppTheme.textLight,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontFamily: 'Playfair Display',
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          if (!isEnrolled && selectedSubjects.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: TextButton(
                onPressed: saveEnrollment,
                child: Text(
                  'SAVE',
                  style: TextStyle(
                    color: AppTheme.textLight,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontFamily: 'Roboto Slab',
                  ),
                ),
              ),
            ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.secondaryColor,
              ),
            )
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    border: Border(
                      bottom: BorderSide(color: AppTheme.secondaryColor, width: 3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'CREDITS: $totalCredits/$maxCredits',
                            style: TextStyle(
                              color: AppTheme.textLight,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontFamily: 'Roboto Slab',
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.textLight, width: 2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isEnrolled ? 'ENROLLED' : 'NOT ENROLLED',
                              style: TextStyle(
                                color: AppTheme.textLight,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                fontFamily: 'Roboto Slab',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!isEnrolled)
                  Expanded(
                    child: FutureBuilder<List<Subject>>(
                      future: _subjectService.getSubjects().first,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.secondaryColor,
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error loading courses',
                              style: TextStyle(
                                color: AppTheme.errorColor,
                                fontFamily: 'Roboto Slab',
                              ),
                            ),
                          );
                        }

                        availableSubjects = snapshot.data ?? [];
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          itemCount: availableSubjects.length,
                          itemBuilder: (context, index) {
                            final subject = availableSubjects[index];
                            final isSelected = selectedSubjects.contains(subject);
                            return _buildSubjectCard(subject, isSelected);
                          },
                        );
                      },
                    ),
                  ),
                if (isEnrolled)
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20),
                      child: Column(
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
                              'ENROLLED SUBJECTS',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                color: AppTheme.primaryColor,
                                fontFamily: 'Playfair Display',
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ...selectedSubjects.map((subject) => Container(
                            margin: EdgeInsets.only(bottom: 16),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.cardColor,
                              border: Border.all(
                                color: AppTheme.secondaryColor.withOpacity(0.5),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.backgroundColor,
                                    border: Border.all(
                                      color: AppTheme.secondaryColor.withOpacity(0.3),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    Icons.book,
                                    color: AppTheme.secondaryColor,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        subject.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.textPrimary,
                                          fontFamily: 'Roboto Slab',
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '${subject.credits} Credits',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.textSecondary,
                                          fontFamily: 'Roboto Slab',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )).toList(),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
