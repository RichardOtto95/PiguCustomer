import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pigu/app/modules/user_profile/user_profile_controller.dart';
import 'package:pigu/app/modules/user_profile/user_profile_module.dart';

void main() {
  initModule(UserProfileModule());
  // UserProfileController userprofile;
  //
  setUp(() {
    //     userprofile = UserProfileModule.to.get<UserProfileController>();
  });

  group('UserProfileController Test', () {
    //   test("First Test", () {
    //     expect(userprofile, isInstanceOf<UserProfileController>());
    //   });

    //   test("Set Value", () {
    //     expect(userprofile.value, equals(0));
    //     userprofile.increment();
    //     expect(userprofile.value, equals(1));
    //   });
  });
}
