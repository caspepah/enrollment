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
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Color(0xFFF3E5F5) : Colors.white,
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor.withOpacity(0.3) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnrolled ? null : () => toggleSubject(subject),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.book_outlined,
                      color: isSelected ? AppTheme.primaryColor : Colors.grey[400],
                      size: 20,
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
                            fontWeight: FontWeight.w600,
                            color: isSelected ? AppTheme.primaryColor : Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${subject.credits} Credits',
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected ? AppTheme.primaryColor.withOpacity(0.8) : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                ],
              ),
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
          isEnrolled ? 'Enrollment Summary' : 'Course Enrollment',
          style: TextStyle(color: AppTheme.textLight),
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
                  'Save',
                  style: TextStyle(
                    color: AppTheme.textLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            )
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Selected Credits: $totalCredits/$maxCredits',
                            style: TextStyle(
                              color: AppTheme.textLight,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.textLight.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isEnrolled ? 'Enrolled' : 'Not Enrolled',
                              style: TextStyle(
                                color: AppTheme.textLight,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
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
                              color: AppTheme.primaryColor,
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error loading courses',
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        availableSubjects = snapshot.data ?? [];
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 8),
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
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enrolled Subjects',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          SizedBox(height: 16),
                          ...selectedSubjects.map((subject) => Card(
                            margin: EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.book_outlined,
                                      color: AppTheme.primaryColor,
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
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textPrimary,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '${subject.credits} Credits',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
