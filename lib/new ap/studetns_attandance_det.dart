// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentAttendance {
  StudentAttendance.fromJson(data);
  // Define your StudentAttendance model here
  // Assuming you have defined it correctly
}

class StudentAttendancePage extends StatefulWidget {
  static String routeName = "/attendance-student";
  final String email;
  const StudentAttendancePage({required this.email});

  @override
  State<StudentAttendancePage> createState() => StudentAttendancePageState();
}

class StudentAttendancePageState extends State<StudentAttendancePage> {
  late Future<List<StudentAttendance>> _fetchAttendanceDetails;

  @override
  void initState() {
    super.initState();
    _fetchAttendanceDetails = fetchAttendanceDetails();
  }

  Future<List<StudentAttendance>> fetchAttendanceDetails() async {
    String email = widget.email;

    final response = await http.get(
      Uri.parse(
          'https://group4attendance.pythonanywhere.com/api/courses/1/classes/1/hours/1/attendance'),
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((data) => new StudentAttendance.fromJson(data))
          .toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Attendance'),
      ),
      body: FutureBuilder<List<StudentAttendance>>(
        future: _fetchAttendanceDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Assuming you have a widget to display attendance details
            return buildAttendanceList(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget buildAttendanceList(List<StudentAttendance> attendanceList) {
    // Implement your UI to display attendance details here
    // Example: return a ListView.builder to display attendance details
    return ListView.builder(
      itemCount: attendanceList.length,
      itemBuilder: (context, index) {
        // Build your attendance list item here
        // Example: return a ListTile with attendance details
        return ListTile(
          title: Text('Attendance ${index + 1}'),
          subtitle: Text('Put your attendance details here'),
        );
      },
    );
  }
}
