import 'package:pigu/app/modules/chat/chat_controller.dart';
import 'package:pigu/app/modules/chat/chat_page.dart';
import 'package:pigu/app/modules/invite_to_share/invite_to_share_module.dart';
import 'package:pigu/app/modules/invite_to_share/invite_to_share_page.dart';
import 'package:pigu/app/modules/menu/menu_controller.dart';
import 'package:pigu/app/modules/order/order_page.dart';
import 'package:pigu/app/modules/table_opening/table_opening_module.dart';
import 'package:pigu/app/modules/table_opening/table_opening_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'menu_page.dart';

class MenuModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => MenuController()),
        Bind((i) => ChatController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => MenuPage()),
        // ModularRouter('/order', module: TableOpeningModule()),
        ModularRouter(
          '/table-opening',
          child: (_, args) => TableOpeningPage(
            seller: args.data,
          ),
        ),
        ModularRouter(
          '/invited-to-share',
          child: (_, args) => InviteToSharePage(
            order: args.data,
          ),
        ),
        // ModularRouter('/chat',
        //     child: (_, args) => ChatPage(
        //         // groupId: ,
        //         // group: args.data,
        //         // msgType: 'create-order',
        //         )),
        ModularRouter('/chat/:groupId',
            child: (_, args) => ChatPage(
                  groupId: args.params['groupId'],
                )),
        // ModularRouter('/chat',
        //     child: (_, args) => OrderPage(
        //           order: args.data,
        //         )),
      ];

  static Inject get to => Inject<MenuModule>.of();
}
