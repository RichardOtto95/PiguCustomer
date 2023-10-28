import 'package:pigu/app/modules/add_participant/add_participant_module.dart';
import 'package:pigu/app/modules/chat/chat_controller.dart';
import 'package:pigu/app/modules/chat/chat_page.dart';
import 'package:pigu/app/modules/menu/menu_page.dart';
import 'package:pigu/app/modules/open_table/open_table_detail.dart';
import 'package:pigu/app/modules/pay_the_bill/pay_the_bill_module.dart';
import 'package:pigu/app/modules/pay_the_bill/pay_the_bill_page.dart';
import 'package:pigu/app/modules/table_info/table_info_page.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'open_table_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'open_table_page.dart';

class OpenTableModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        Bind((i) => OpenTableController()),
        Bind((i) => ChatController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => OpenTablePage()),
        ModularRouter(
          '/open-table-detail',
          child: (_, args) => OpenTableDetailPage(
            invite: args.data,
          ),
        ),
        ModularRouter('/table-info',
            child: (_, args) => TableInfoPage(
                  group: args.data,
                )),
        ModularRouter('/chat/:groupId',
            child: (_, args) => ChatPage(
                  groupId: args.params['groupId'],
                  // group: args.data,
                  // msgType: 'view-chat',
                )),
        ModularRouter('/add-participant', module: AddParticipantModule()),
        ModularRouter('/pay-the-bill',
            child: (_, args) => PayTheBillPage(
                  group: args.data,
                )),
        ModularRouter('/menu',
            child: (_, args) => MenuPage(
                  seller: args.data,
                )),
      ];

  static Inject get to => Inject<OpenTableModule>.of();
  Widget get view => OpenTableModule();
}
