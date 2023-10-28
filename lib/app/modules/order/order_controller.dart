import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'order_controller.g.dart';

@Injectable()
class OrderController = _OrderControllerBase with _$OrderController;

abstract class _OrderControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
