import 'virtual_queue_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'virtual_queue_page.dart';

class VirtualQueueModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => VirtualQueueController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => VirtualQueuePage(
                  seller: args,
                )),
      ];

  static Inject get to => Inject<VirtualQueueModule>.of();
}
