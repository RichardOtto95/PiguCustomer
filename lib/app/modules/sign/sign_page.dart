import 'dart:async';

import 'package:pigu/app/modules/home/home_widget.dart';
import 'package:pigu/shared/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigu/app/core/modules/root/root_controller.dart';
import 'package:pigu/app/core/services/auth/auth_controller.dart';
import 'package:pigu/app/modules/sign/enter_code_wiget.dart';
import 'package:pigu/app/modules/sign/signup_validation.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pigu/app/core/services/auth/auth_service_interface.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'sign_controller.dart';

class SignPage extends StatefulWidget {
  final String title;
  const SignPage({Key key, this.title = "Sign"}) : super(key: key);

  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends ModularState<SignPage, SignController> {
  //use 'controller' variable to access controller
  final authController = Modular.get<AuthController>();
  final rootController = Modular.get<RootController>();
  AuthServiceInterface authService = Modular.get();
  bool secondResend = false;
  bool loadCircular = false;
  bool loginClicked = true;
  FocusNode phoneFocusNode;
  FocusNode firstNode;
  FocusNode secondFocusNode;
  FocusNode thirdFocusNode;
  FocusNode fouthFocusNode;
  FocusNode fiveFocusNode;
  FocusNode sixFocusNode;
  // TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";

  @override
  void initState() {
    super.initState();
    firstNode = FocusNode();
    secondFocusNode = FocusNode();
    thirdFocusNode = FocusNode();
    fouthFocusNode = FocusNode();
    fiveFocusNode = FocusNode();
    sixFocusNode = FocusNode();
    phoneFocusNode = FocusNode();

    // textEditingController = TextEditingController();

    FirebaseAuth.instance.onAuthStateChanged.listen((firebaseUser) async {
      // do whatever you want based on the firebaseUser state
      // Modular.to.pushNamed('/');
      // //print'firebaseUser : ============ ${firebaseUser}');
      if (firebaseUser != null) {
        // valueUser = value;
        // //print'MANDOU A SMS: ${firebaseUser}');
        var _user = (await Firestore.instance
                .collection('users')
                .document(firebaseUser.uid)
                .get())
            .data;
        // //print'tem user $_user');

        if (_user != null) {
          // //print'tem user if $_user');
          Modular.to.pushNamed('/');
          rootController.setSelectedTrunk(2);
          rootController.setSelectIndexPage(1);

          // Modular.to.pushNamed('/');
        } else {
          // //print'tem user else $_user');
          // //print'user AUTH:: $_user');

          controller.user.mobile_region_code =
              firebaseUser.phoneNumber.substring(3, 5);
          controller.user.mobile_phone_number =
              firebaseUser.phoneNumber.substring(5, 14);

          // //print
          //     'controller.user.region_phone_code : ${controller.user.mobile_region_code}');
          // //print
          //     'controller.user.mobile_phone_number: ${controller.user.mobile_phone_number}');

          await authService.handleSignup(controller.user);
          await authService.handleGetUser();
          // await authController.getUser();
          // //print'selectedTrunk ANTES : ${rootController.selectedTrunk}');
          Modular.to.pushNamed('/');

          rootController.setSelectedTrunk(2);
          rootController.setSelectIndexPage(1);
          // //print'selectedTrunk DEPOIS : ${rootController.selectedTrunk}');
        }
      }
    });

    // .onAuthStateChanged( (user) => {
    //     if (user) {
    //         // Obviously, you can add more statements here,
    //         //       e.g. call an action creator if you use Redux.

    //         // navigate the user away from the login screens:
    //         props.navigation.navigate("PermissionsScreen");
    //     }
    //     else
    //     {
    //         // reset state if you need to
    //         dispatch({ type: "reset_user" });
    //     }
    // });
  }

  Timer _timer;
  int _start = 60;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            controller.authController.verifyNumber(controller.tel);
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    // textEditingController.dispose();
    // Clean up the focus node when the Form is disposed.
    print('%%%%%%%% TIMER $_timer ');
    if (_timer != null) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    }

    phoneFocusNode.dispose();
    firstNode.dispose();
    secondFocusNode.dispose();
    thirdFocusNode.dispose();
    fouthFocusNode.dispose();
    fiveFocusNode.dispose();
    sixFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('%%%%%%%%% sign paaaaaage');

    // List<Widget> _signPages = [
    //   // SigninEmailModule(),
    //   // SignupModule(),
    // ];
    // PageController _pageSignController = PageController(
    //   initialPage: controller.selectedPage,
    //   keepPage: true,
    // );
    // void bottomTapped(int index) {
    //   setState(() {
    //     _pageSignController.animateToPage(index,
    //         duration: Duration(milliseconds: 500), curve: Curves.ease);
    //   });
    // }
    // int selectPage = 0;
    var maskFormatter = new MaskTextInputFormatter(
        mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

    onEntry() {
      if (controller.authController.codeSent == true) {
        if (controller.val1 != null &&
            controller.val1 != '' &&
            controller.val2 != null &&
            controller.val2 != '' &&
            controller.val3 != null &&
            controller.val3 != '' &&
            controller.val4 != null &&
            controller.val4 != '' &&
            controller.val5 != null &&
            controller.val5 != '' &&
            controller.val6 != null &&
            controller.val6 != '') {
          controller.setUserCode(controller.val1 +
              controller.val2 +
              controller.val3 +
              controller.val4 +
              controller.val5 +
              controller.val6);
          // //printcontroller.code);
          controller.signinPhone(
            controller.code,
            controller.authController.userVerifyId,
          );
        } else {
          Fluttertoast.showToast(
              msg: "Digite o Codigo enviado!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: ColorTheme.yellow,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        if (controller.tel != null && controller.tel != '') {
          controller.authController.verifyNumber(controller.tel);
        } else {
          Fluttertoast.showToast(
              msg: "Digite o numero do telefone!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: ColorTheme.yellow,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    }

    onConfirm() {
      if (currentText.length == 6 && currentText.isNotEmpty) {
        setState(() {
          loadCircular = true;
        });
        controller.setUserCode(currentText);
        // //print
        //     'CODE : ${controller.code}');
        controller.signinPhone(
          controller.code,
          controller.authController.userVerifyId,
        );
      } else {
        Fluttertoast.showToast(
            msg: "Digite o Codigo enviado!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: ColorTheme.yellow,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }

    return Observer(
      builder: (_) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        return SingleChildScrollView(
          child: Container(
            height: maxHeight(context) - hXD(30, context),
            width: maxWidth(context),
            child: authController.codeSent
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(flex: 1),
                      Container(
                        width: wXD(343, context),
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            authController.setCodeSent(false);
                            // textEditingController.dispose();
                          },
                          child: Icon(
                            Icons.arrow_back,
                            size: wXD(27, context),
                            color: ColorTheme.primaryColor,
                          ),
                        ),
                      ),
                      Spacer(flex: 1),
                      Image.asset(
                        'assets/img/PIGU-Logotipo-Principal-Colorido.png',
                        height: wXD(61, context),
                      ),
                      Spacer(flex: 1),
                      Text(
                        'Código enviado',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 36),
                      ),
                      Spacer(flex: 1),
                      Text(
                        'Insira o código\nenviado',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Color(0xff2C3E50),
                          fontWeight: FontWeight.w300,
                          fontSize: 36,
                        ),
                      ),
                      Spacer(flex: 1),
                      Container(
                        width: wXD(260, context),
                        child: PinCodeTextField(
                          cursorColor: ColorTheme.primaryColor,
                          onSubmitted: (value) => onConfirm(),
                          keyboardType: TextInputType.number,
                          length: 6,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                              shape: PinCodeFieldShape.underline,
                              fieldHeight: wXD(50, context),
                              fieldWidth: wXD(35, context),
                              inactiveColor: Colors.grey[400], //
                              activeColor: Color(0xFFF6B72A),
                              selectedColor: Colors.yellow),
                          backgroundColor: ColorTheme.white,
                          animationDuration: Duration(milliseconds: 300),
                          errorAnimationController: errorController,
                          onCompleted: (v) {},
                          onChanged: (value) {
                            setState(() {
                              currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            //print
                            // "Allowing to paste $text");
                            return true;
                          },
                          appContext: context,
                        ),
                      ),
                      Spacer(flex: 1),
                      Container(
                        height: wXD(30, context),
                        width: wXD(120, context),
                        child: FlatButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            startTimer();
                            setState(() {
                              secondResend = true;
                            });
                            /*...*/
                          },
                          child: Text(
                            "Reenviar código",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.normal),
                          ),
                          shape: Border(
                              bottom: BorderSide(
                                  width: 3.0, color: Color(0xFFF6B72A))),
                        ),
                      ),
                      Spacer(flex: 1),
                      secondResend
                          ? Text(
                              "Reenviando código em ${_start} segundos",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.normal),
                            )
                          : Container(),
                      Spacer(flex: 1),
                      loadCircular
                          ? Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(ColorTheme.yellow),
                              ),
                            )
                          : Container(
                              width: wXD(300, context),
                              height: 60,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: ColorTheme.primaryColor)),
                                child: Text(
                                  'Validar',
                                  style: TextStyle(fontSize: 20),
                                ),
                                color: ColorTheme.primaryColor,
                                textColor: Colors.white,
                                onPressed: () => onConfirm(),
                              ),
                            ),
                      Spacer(flex: 2),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Spacer(flex: 1),
                      Image.asset(
                        'assets/img/PIGU-Logotipo-Principal-Colorido.png',
                        height: wXD(61, context),
                        width: wXD(283, context),
                      ),
                      Spacer(flex: 1),
                      Text(
                        'Bem vindo!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 36),
                      ),
                      Spacer(flex: 1),
                      Text(
                        'Cadastre-se\npare entrar',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Color(0xff2C3E50),
                          fontWeight: FontWeight.w300,
                          fontSize: 36,
                        ),
                      ),
                      Spacer(flex: 1),
                      Container(
                        width: wXD(207, context),
                        child: TextField(
                          onSubmitted: (value) => onEntry(),
                          inputFormatters: [maskFormatter],
                          onChanged: (text) {
                            text = maskFormatter.getUnmaskedText();
                            // //print'Telefone: value: $text');
                            controller.setUserTel(text);
                          },
                          keyboardType: TextInputType.number,
                          maxLength: 15,
                          cursorColor: ColorTheme.primaryColor,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.yellow)),
                              contentPadding: EdgeInsets.only(
                                left: wXD(10, context),
                              ),
                              hintText: '(61)99999-9999',
                              hintStyle: TextStyle(
                                color: Color(0xFF707070).withOpacity(.4),
                                fontSize: 16,
                              ),
                              counterText: "",
                              labelText: 'Telefone',
                              labelStyle: TextStyle(
                                color: ColorTheme.textGrey,
                                fontSize: 16,
                              )),
                        ),
                      ),
                      Spacer(flex: 1),
                      Container(
                        height: wXD(61, context),
                        width: wXD(283, context),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: ColorTheme.primaryColor,
                            ),
                          ),
                          child: Text(
                            'Entrar',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          color: ColorTheme.primaryColor,
                          textColor: Colors.white,
                          onPressed: () => onEntry(),
                        ),
                      ),
                      Spacer(flex: 2),
                    ],
                  ),
          ),
        );
      },
    );
  }

  // concludedInput() {}
}
