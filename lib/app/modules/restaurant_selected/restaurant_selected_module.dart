import 'package:pigu/app/modules/menu/menu_module.dart';
import 'package:pigu/app/modules/menu/menu_page.dart';
import 'package:pigu/app/modules/open_table/open_table_module.dart';
import 'package:pigu/app/modules/table_opening/table_opening_module.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'restaurant_selected_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'restaurant_selected_page.dart';

class RestaurantSelectedModule extends WidgetModule {
  // RestaurantSelectedModule(data);

  @override
  List<Bind> get binds => [
        Bind((i) => RestaurantSelectedController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => RestaurantSelectedPage()),
        // ModularRouter('/menu', module: MenuModule()),
        ModularRouter('/table-opening', module: TableOpeningModule()),

        ModularRouter('/menu',
            child: (_, args) => MenuPage(
                  seller: args.data,
                )),
      ];

  static Inject get to => Inject<RestaurantSelectedModule>.of();

  @override
  // TODO: implement view
  Widget get view => throw RestaurantSelectedPage();
}
