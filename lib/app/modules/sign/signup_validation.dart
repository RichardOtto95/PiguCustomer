import 'package:flutter_modular/flutter_modular.dart';

import 'sign_controller.dart';
import 'package:pigu/app/modules/sign/sign_module.dart';
import 'package:flutter/material.dart';

class SingUpValidation_ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Validation Screen',
      home: SingUpValidation(title: 'Login Screen'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SingUpValidation extends StatefulWidget {
  SingUpValidation({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SingUpValidation createState() => _SingUpValidation();
}

class _SingUpValidation extends ModularState<SingUpValidation, SignController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Text(
                'Código enviado',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0, bottom: 100.0),
              child: Text('Insira o código \n enviado',
                  style: TextStyle(fontSize: 40)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 30.0,
                    child: TextField(
                      onChanged: (text) {
                        // //print'1: value: $text');;
                        controller.setFirstVal(text);
                      },
                    )),
                SizedBox(width: 10),
                Container(
                    width: 30.0,
                    child: TextField(
                      onChanged: (text) {
                        // //print'2: value: $text');
                        controller.setSecondVal(text);
                      },
                    )),
                SizedBox(width: 10),
                Container(
                    width: 30.0,
                    child: TextField(
                      onChanged: (text) {
                        // //print'3: value: $text');
                        controller.setThirdVal(text);
                      },
                    )),
                SizedBox(width: 10),
                Container(
                    width: 30.0,
                    child: TextField(
                      onChanged: (text) {
                        // //print'4: value: $text');
                        controller.setfourthVal(text);
                      },
                    )),
                SizedBox(width: 10),
                Container(
                    width: 30.0,
                    child: TextField(
                      onChanged: (text) {
                        // //print'5: value: $text');
                        controller.setFiveCode(text);
                      },
                    )),
                SizedBox(width: 10),
                Container(
                    width: 30.0,
                    child: TextField(
                      onChanged: (text) {
                        // //print'6: value: $text');
                        controller.setSixCode(text);
                      },
                    )),
              ],
            ),
            SizedBox(height: 20),
            FlatButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                /*...*/
              },
              child: Text(
                "Reenviar código",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
              shape: Border(
                  bottom: BorderSide(width: 3.0, color: Color(0xFFF6B72A))),
            ),
            SizedBox(height: 80),
            Container(
                width: 320,
                height: 60,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Color(0xFFF6B72A))),
                  child: Text(
                    'Validar',
                    style: TextStyle(fontSize: 20),
                  ),
                  color: Color(0xFF8400),
                  textColor: Colors.black,
                  onPressed: () {
                    Modular.to.pushNamed('/home');
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return SignModule();
                    // }
                    // )
                    // );
                  },
                )),
          ],
        ),
      ),
    );
  }
}
