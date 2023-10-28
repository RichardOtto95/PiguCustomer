import 'package:pigu/app/modules/menu/menu_page.dart';
import 'package:pigu/app/modules/open_table/open_table_detail.dart';
import 'package:pigu/app/modules/table_info/table_info_page.dart';

import 'chat_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'chat_page.dart';

class ChatModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => ChatController()),
      ];

  @override
  List<ModularRouter> get routers => [
        // ModularRouter(Modular.initialRoute, child: (_, args) => ChatPage()),
        ModularRouter('/', child: (_, args) => ChatPage()),
        ModularRouter('/table-info',
            child: (_, args) => TableInfoPage(
                  group: args.data,
                )),
        ModularRouter('/menu',
            child: (_, args) => MenuPage(
                  seller: args.data,
                )),
      ];

  static Inject get to => Inject<ChatModule>.of();
}
