import 'package:pigu/app/modules/menu/menu_controller.dart';
import 'package:pigu/shared/utilities.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SlideMenuNote extends StatelessWidget {
  final Function noteInpunt;
  final menuController = Modular.get<MenuController>();
  final Function okButtom;
  final bool clickItem;

  SlideMenuNote({
    Key key,
    this.noteInpunt,
    this.okButtom,
    this.clickItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        children: [
          AnimatedContainer(
            duration: Duration(seconds: 2),
            curve: Curves.ease,
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: InkWell(onTap: () {
              menuController.setClickNote(false);
              menuController.setclickItem(false);
            }),
          ),
        ],
      ),
      Positioned(
        bottom: 0,
        child: Container(
          height: wXD(300, context),
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(26), topRight: Radius.circular(26)),
            ),
            child: ListView(
              children: [
                Column(
                  children: [
                    Container(
                      height: wXD(4, context),
                      width: wXD(24, context),
                      margin: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          color: ColorTheme.textGrey,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
                SizedBox(
                  height: wXD(10, context),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: wXD(30, context),
                    ),
                    Text(
                      'Observações:',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: wXD(18, context),
                          color: ColorTheme.textColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: wXD(50, context),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: wXD(30, context)),
                  child: TextFormField(
                    onChanged: noteInpunt,
                    initialValue: '${menuController.noteInput}',
                    decoration: InputDecoration(
                      // prefixText: '${menuController.noteInput}',

                      labelText: 'Escreva aqui',
                      labelStyle: TextStyle(
                        fontSize: wXD(18, context),
                        color: ColorTheme.textGrey,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: wXD(15, context),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Container(
                    width: wXD(59, context),
                    height: wXD(47, context),
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(right: wXD(30, context), top: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(21.0),
                        topRight: Radius.circular(21.0),
                        bottomRight: Radius.circular(21.0),
                        bottomLeft: Radius.circular(58.0),
                      ),
                      color: ColorTheme.primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x29000000),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: okButtom,
                      child: Container(
                        child: Center(
                          child: Text(
                            'Ok',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: wXD(16, context),
                              color: ColorTheme.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ])
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
