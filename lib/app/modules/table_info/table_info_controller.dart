import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'table_info_controller.g.dart';

@Injectable()
class TableInfoController = _TableInfoControllerBase with _$TableInfoController;

abstract class _TableInfoControllerBase with Store {
  @observable
  int value = 0;

  @observable
  String clickLabel;

   
  void increment() {
    value++;

    
  }
}
