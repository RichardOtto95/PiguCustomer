import 'package:pigu/app/modules/home/home_widget.dart';
import 'package:pigu/app/modules/restaurant_selected/restaurant_selected_controller.dart';
import 'package:pigu/app/modules/restaurant_selected/restaurant_selected_page.dart';
import 'package:pigu/app/modules/user_profile/user_profile_module.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'home_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';

class HomeModule extends WidgetModule {
  @override
  List<Bind> get binds => [
        Bind((i) => HomeController()),
        Bind((i) => RestaurantSelectedController())
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => HomeWidget()),
        // ModularRouter('/categories', module: CategoryModule()),
        // ModularRouter('/restaurant-selected/:seller', child: (_, args) => RestaurantSelectedPage(seller:args.params['seller'])),
        ModularRouter(
          '/restaurant-selected',
          child: (_, args) => RestaurantSelectedPage(
            seller: args.data,
          ),
        ),

        // ModularRouter('/restaurant-selected/:sellerId',
        //     child: (_, args) => RestaurantSelectedPage(
        //           seller: args.params['sellerId'],
        //           // group: args.data,
        //           // msgType: 'view-chat',
        //         )),
      ];

  static Inject get to => Inject<HomeModule>.of();

  @override
  // TODO: implement view
  Widget get view => HomeWidget();
}
