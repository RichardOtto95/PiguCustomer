import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'invite_to_share_controller.g.dart';

@Injectable()
class InviteToShareController = _InviteToShareControllerBase
    with _$InviteToShareController;

abstract class _InviteToShareControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
