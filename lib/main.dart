import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'core/app_theme.dart';

void main() {
  runApp(const GlobyApp());
}

class GlobyApp extends StatelessWidget {
  const GlobyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Globy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.getRoutes(),
    );
  }
}
