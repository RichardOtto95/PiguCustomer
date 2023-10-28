import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'pay_the_bill_controller.g.dart';

@Injectable()
class PayTheBillController = _PayTheBillControllerBase
    with _$PayTheBillController;

abstract class _PayTheBillControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
