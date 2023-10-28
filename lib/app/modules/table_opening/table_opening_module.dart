import 'package:pigu/app/modules/chat/chat_controller.dart';
import 'package:pigu/app/modules/chat/chat_page.dart';

import 'table_opening_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'table_opening_page.dart';

class TableOpeningModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => TableOpeningController()),
        Bind((i) => ChatController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => TableOpeningPage()),
        // ModularRouter('/chat',
        //     child: (_, args) => ChatPage(
        //         // groupId: ,
        //         // group: args.data,
        //         // msgType: 'create-table',
        //         )),
        ModularRouter('/chat/:groupId',
            child: (_, args) => ChatPage(
                  groupId: args.params['groupId'],
                  // group: args.data,
                  // msgType: 'view-chat',
                )),
      ];

  static Inject get to => Inject<TableOpeningModule>.of();
}
