import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class FloatMenu extends StatelessWidget {
  final Function changeHoster;
  final group;

  const FloatMenu({Key key, this.changeHoster, this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // //print'group: $group');
    return Container(
        width: 200,
        height: 197,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0x29000000),
              offset: Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FloatMenuButton(
            title: "Mudar Anfitrião",
            onTap: () {
              Modular.to.pushNamed('open-table/table-info', arguments: group);
            },
          ),
          FloatMenuButton(
            title: "Arquivar mesa",
          ),
          FloatMenuButton(
            title: "Remover participante",
          ),
          FloatMenuButton(
            title: "Silenciar notificações",
          ),
          FloatMenuButton(
            title: "Adicionar participante",
          ),
        ]));
  }
}

class FloatMenuButton extends StatelessWidget {
  final String title;
  final Function onTap;
  const FloatMenuButton({
    Key key,
    this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 39,
        padding: EdgeInsets.only(left: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: ColorTheme.textGrey,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
