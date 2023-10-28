import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app/app_module.dart';

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();
  print('teste');

  runApp(ModularApp(module: AppModule()));
}

// => );
