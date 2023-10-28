import 'table_info_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'table_info_page.dart';

class TableInfoModule extends ChildModule {
  @override
  List<Bind> get binds => [
      
        Bind((i) => TableInfoController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => TableInfoPage()),
      ];

  static Inject get to => Inject<TableInfoModule>.of();
}
