import 'package:pigu/app/modules/chat/chat_page.dart';

import 'add_participant_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'add_participant_page.dart';

class AddParticipantModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => AddParticipantController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => AddParticipantPage()),
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

  static Inject get to => Inject<AddParticipantModule>.of();
}
