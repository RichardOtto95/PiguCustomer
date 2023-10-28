import 'order_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'order_page.dart';

class OrderModule extends ChildModule {
  @override
  List<Bind> get binds => [
       
  Bind((i) => OrderController()),

      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => OrderPage()),
      ];

  static Inject get to => Inject<OrderModule>.of();
}
