import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu/app/core/models/user_model.dart';
import 'package:pigu/app/core/modules/root/root_controller.dart';
import 'package:pigu/app/core/services/auth/auth_controller.dart';
import 'package:pigu/app/core/services/auth/auth_service_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'sign_controller.g.dart';

@Injectable()
class SignController = _SignControllerBase with _$SignController;

abstract class _SignControllerBase with Store {
  final authController = Modular.get<AuthController>();
  final rootController = Modular.get<RootController>();
  AuthServiceInterface authService = Modular.get();

  final UserModel user;
  FirebaseUser valueUser;

  @observable
  int value = 0;
  @observable
  int selectedPage = 0;
  @observable
  String code;
  @observable
  String val1;
  @observable
  String val2;
  @observable
  String val3;
  @observable
  String val4;
  @observable
  String val5;
  @observable
  String val6;

  @observable
  String tel;

  _SignControllerBase(this.user);

  @action
  setUserTel(String telephone) => tel = telephone;

  @action
  setUserCode(String _userd) => code = _userd;
  @action
  setFirstVal(String _val1) => val1 = _val1;
  @action
  setSecondVal(String _val2) => val2 = _val2;
  @action
  setThirdVal(String _val3) => val3 = _val3;
  @action
  setfourthVal(String _val4) => val4 = _val4;
  @action
  setFiveCode(String _val5) => val5 = _val5;
  @action
  setSixCode(String _val6) => val6 = _val6;

  @action
  setSelectedPage(int selected) => selectedPage = selected;

  @action
  loginApp() {
    Modular.to.pushNamed('/home');
  }

  @action
  void signinPhone(String code, String verifyId) {
    authController.handleSmsSignin(code, verifyId).then((value) async {
      if (value != null) {
        valueUser = value;
        // //print'MANDOU A SMS: $valueUser');
        var _user = (await Firestore.instance
                .collection('users')
                .document(value.uid)
                .get())
            .data;
        // //print'tem user $_user');

        if (_user != null) {
          // //print'tem user $_user');
          Modular.to.pushNamed('/');
          rootController.setSelectedTrunk(2);
          rootController.setSelectIndexPage(1);

          // Modular.to.pushNamed('/');
        } else {
          // //print'tem user $_user');
          // //print'user AUTH:: $_user');

          user.mobile_region_code = value.phoneNumber.substring(3, 5);
          user.mobile_phone_number = value.phoneNumber.substring(5, 14);

          // //print'create');
          // //print'user create:: $user');

          await authService.handleSignup(user);
          // await authController.getUser();
          // //print'selectedTrunk ANTES : ${rootController.selectedTrunk}');
          Modular.to.pushNamed('/');

          rootController.setSelectedTrunk(2);
          rootController.setSelectIndexPage(1);
          // //print'selectedTrunk DEPOIS : ${rootController.selectedTrunk}');
        }
      }
    });
  }

  @action
  void increment() {
    value++;
  }
}
