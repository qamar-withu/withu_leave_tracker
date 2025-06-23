import 'package:flutter/material.dart';
import 'package:withu_leave_tracker/main.dart' as app;

void main() async {
  // Set flavor environment variable
  const String.fromEnvironment('FLAVOR', defaultValue: 'qa');

  // Run the main app
  app.main();
}
