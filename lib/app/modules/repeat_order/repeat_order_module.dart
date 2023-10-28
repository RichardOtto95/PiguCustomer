import 'package:pigu/app/modules/chat/chat_page.dart';

import 'repeat_order_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'repeat_order_page.dart';

class RepeatOrderModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => RepeatOrderController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => RepeatOrderPage()),
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
      ];

  static Inject get to => Inject<RepeatOrderModule>.of();
}
