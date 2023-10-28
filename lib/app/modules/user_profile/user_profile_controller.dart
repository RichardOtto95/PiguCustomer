import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'user_profile_controller.g.dart';

@Injectable()
class UserProfileController = _UserProfileControllerBase
    with _$UserProfileController;

abstract class _UserProfileControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
