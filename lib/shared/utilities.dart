import 'package:flutter/material.dart';

double wXD(double size, BuildContext context) {
  double finalValue = MediaQuery.of(context).size.width * size / 375;
  return finalValue;
}

double hXD(double size, BuildContext context) {
  double finalValue = MediaQuery.of(context).size.height * size / 667;
  return finalValue;
}

double maxHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double maxWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
