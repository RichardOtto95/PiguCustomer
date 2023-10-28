import 'package:pigu/app/modules/open_table/open_table_controller.dart';
import 'package:pigu/app/modules/open_table/open_table_page.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import './paid_tables_page.dart';
import 'filed_table_page.dart';
import './refused_table_page.dart';

class FloatMenu extends StatelessWidget {
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  final String click;
  final Function onTapOngoing;
  final Function onTapRefused;
  final Function onTapArquived;
  final Function onTapPaid;

  FloatMenu(
      {Key key,
      this.click,
      this.onTapOngoing,
      this.onTapRefused,
      this.onTapArquived,
      this.onTapPaid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final openTableController = Modular.get<OpenTableController>();
    return Container(
        width: wXD(150, context),
        height: wXD(130, context),
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
          openTableController.clickLabel == 'onGoing'
              ? Container()
              : InkWell(
                  onTap: () {
                    openTableController.setClickLabel('onGoing');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return OpenTablePage();
                    }));
                  },
                  child: FloatMenuButton(
                      title: "Em andamento", onTap: onTapOngoing)),
          openTableController.clickLabel == 'onRefused'
              ? Container()
              : InkWell(
                  onTap: () {
                    openTableController.setClickLabel('onRefused');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RefusedTablePage();
                    }));
                  },
                  child:
                      FloatMenuButton(title: "Recusadas", onTap: onTapRefused)),
          openTableController.clickLabel == 'onPaid'
              ? Container()
              : InkWell(
                  onTap: () {
                    openTableController.setClickLabel('onPaid');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PaidTablePage();
                    }));
                  },
                  child: FloatMenuButton(title: "Quitadas", onTap: onTapPaid)),
          openTableController.clickLabel == 'onFiled'
              ? Container()
              : InkWell(
                  onTap: () {
                    openTableController.setClickLabel('onFiled');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ArquivedTablePage();
                    }));
                  },
                  child: FloatMenuButton(
                      title: "Arquivadas", onTap: onTapArquived))
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
        height: 40,
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
