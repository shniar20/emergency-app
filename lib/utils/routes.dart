import 'package:emergency/pages/locations/ambulance.dart';
import 'package:emergency/pages/locations/fire.dart';
import 'package:emergency/pages/locations/police.dart';
import 'package:emergency/pages/activity.dart';
// import 'package:emergency/pages/activity_detail.dart';
import 'package:emergency/pages/category.dart';
import 'package:emergency/pages/component/navigation.dart';
// import 'package:emergency/pages/edit_account.dart';
import 'package:emergency/pages/location.dart';
import 'package:emergency/pages/posts.dart';
import 'package:emergency/pages/registration.dart';
import 'package:emergency/pages/registration_info.dart';
import 'package:emergency/pages/start.dart';
// import 'package:emergency/pages/verfication.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/start_page': (context) => const StartPage(),
  '/registration': (context) => const Registration(),
  '/registration_info': (context) => const RegistrationInfo(),
  // '/verification': (context) => const Verify(),
  '/category': (context) => const Category(),
  '/posts': (context) => const Posts(),
  '/navigation': (context) => const NavigationBottom(),
  '/fire': (context) => const Fire(),
  // '/edit_account': (context) => const EditAccount(),
  '/activity': (context) => const UserActivityPage(),
  '/location': (context) => const Location(),
  '/police': (context) => const Police(),
  '/ambulance': (context) => const Ambulance(),
  // '/activity_detail': (context) => const ActivityDetail(),
};
