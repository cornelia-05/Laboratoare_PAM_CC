
import 'dart:convert';
import 'package:flutter/services.dart';

class CourseService {
  Future<Map<String, dynamic>> loadData() async {
    final String response =
    await rootBundle.loadString('assets/data/courses.json');

    final Map<String, dynamic> data =
    jsonDecode(response) as Map<String, dynamic>;

    return data;
  }
}
