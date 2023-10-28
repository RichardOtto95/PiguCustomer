import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'virtual_queue_controller.g.dart';

@Injectable()
class VirtualQueueController = _VirtualQueueControllerBase
    with _$VirtualQueueController;

abstract class _VirtualQueueControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
