

import 'package:flutter/material.dart';
import '../view/detail_pages/select_time_page.dart';

class DetailPageController {
  void pop(BuildContext context) {
    Navigator.pop(context);
  }
  void navigateToSelectTimePage(BuildContext context) {
    Navigator.pushNamed(context, SelectTimePage.id);
  }
}