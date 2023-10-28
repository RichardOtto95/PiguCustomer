import 'invite_to_share_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'invite_to_share_page.dart';

class InviteToShareModule extends ChildModule {
  @override
  List<Bind> get binds => [

        Bind((i) => InviteToShareController()),

      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => InviteToSharePage()),
      ];

  static Inject get to => Inject<InviteToShareModule>.of();
}
