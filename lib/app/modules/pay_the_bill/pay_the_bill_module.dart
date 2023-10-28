import 'package:flutter/material.dart';

import 'pay_the_bill_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'pay_the_bill_page.dart';

class PayTheBillModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        Bind((i) => PayTheBillController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => PayTheBillPage()),
      ];

  // static Inject get to => Inject<PayTheBillModule>.of();
  Widget get view => PayTheBillPage();
}
