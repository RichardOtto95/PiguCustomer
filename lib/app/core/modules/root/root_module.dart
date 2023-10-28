import 'package:pigu/app/core/modules/root/root_controller.dart';
import 'package:pigu/app/core/modules/root/root_page.dart';
import 'package:pigu/app/modules/add_participant/add_participant_module.dart';
import 'package:pigu/app/modules/chat/chat_module.dart';
import 'package:pigu/app/modules/home/home_module.dart';
import 'package:pigu/app/modules/invite_to_share/invite_to_share_module.dart';
import 'package:pigu/app/modules/menu/menu_module.dart';
import 'package:pigu/app/modules/open_table/open_table_module.dart';
import 'package:pigu/app/modules/order/order_module.dart';
import 'package:pigu/app/modules/repeat_order/repeat_order_module.dart';
import 'package:pigu/app/modules/restaurant_selected/restaurant_selected_module.dart';
import 'package:pigu/app/modules/table_info/table_info_module.dart';
import 'package:pigu/app/modules/table_opening/table_opening_module.dart';
import 'package:pigu/app/modules/user_profile/user_profile_module.dart';
import 'package:pigu/app/modules/user_profile_edit/user_profile_edit_module.dart';
import 'package:pigu/app/modules/virtual_queue/virtual_queue_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RootModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => RootController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => RootPage()),
        ModularRouter('/home', module: HomeModule()),
        ModularRouter('/restaurant-selected',
            module: RestaurantSelectedModule()),
        ModularRouter('/menu', module: MenuModule()),
        ModularRouter('/user-profile', module: UserProfileModule()),
        ModularRouter('/open-table', module: OpenTableModule()),
        ModularRouter('/order', module: OrderModule()),
        ModularRouter('/reapeat-order', module: RepeatOrderModule()),
        ModularRouter('/invite-to-share', module: InviteToShareModule()),
        ModularRouter('/table-opening', module: TableOpeningModule()),
        ModularRouter('/user-profile-edit', module: UserProfileEditModule()),
        ModularRouter('/virtual-queue', module: VirtualQueueModule()),
        ModularRouter('/add-participant', module: AddParticipantModule()),
      ];

  static Inject get to => Inject<RootModule>.of();
}
