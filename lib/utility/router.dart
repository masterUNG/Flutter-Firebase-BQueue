import 'package:flutter/material.dart';
import 'package:flutter_application_beng_queue_app/screens/restaurant/index_restaurant_nav.dart';
import 'package:flutter_application_beng_queue_app/screens/user/indexUserNav.dart';
import 'package:flutter_application_beng_queue_app/screens/authentication.dart';
import 'package:flutter_application_beng_queue_app/screens/register.dart';

final Map<String, WidgetBuilder> map = {
  '/authen':(BuildContext context) => Authentication(),
  '/register':(BuildContext context) => RegisterApp(),
  '/userNVA':(BuildContext context) => UserNVA(),
  'restaurantNVA':(BuildContext context) => RestaurantNVA(),
};
