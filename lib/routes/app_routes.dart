import 'package:flutter/material.dart';
import '../modules/home.dart';

class AppRoutes {
  static const home = '/home';
  static const product = '/product';
  static const cart = '/cart';
  static const payment = '/payment';
  static const map = '/map';
  static const tracking = '/tracking';
  static const profile = '/profile';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeView(),
    };
  }
}
