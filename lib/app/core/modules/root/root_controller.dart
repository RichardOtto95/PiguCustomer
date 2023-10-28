import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

part 'root_controller.g.dart';

class RootController = _RootControllerBase with _$RootController;

abstract class _RootControllerBase with Store {
  @observable
  int selectedTrunk = 0;
  int pageIndexSelected = 1;

  @observable
  int pageOrderIndexSelected = 1;
  @observable
  String icone = 'assets/icons/magnifyingGlassClicked.svg';
  @action
  setIconData(String iconData) => icone = iconData;
  @action
  setSelectedTrunk(int value) => selectedTrunk = value;

  @action
  setSelectIndexPage(int page) => pageIndexSelected = page;

  @action
  setSelectIndexOrderPage(int page) => pageOrderIndexSelected = page;
  @observable
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  // @action
  // void loadTrunk(int index) {
  //   // setState(() {
  //     pageController.animateToPage(index,
  //         duration: Duration(milliseconds: 500), curve: Curves.ease);
  //   // });
  // }
}
