import 'package:pigu/shared/color_theme.dart';
import 'package:pigu/shared/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class chatVirtualQueue extends StatelessWidget {
  final Timestamp date;
  final Timestamp queuedUntil;
  final num position;
  final String seller;
  final String uid;

  const chatVirtualQueue({
    Key key,
    this.date,
    this.queuedUntil,
    this.position,
    this.seller,
    this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.height * .8,
      height: MediaQuery.of(context).size.height * .20,
      padding: EdgeInsets.all(wXD(5, context)),
      margin: EdgeInsets.fromLTRB(
          wXD(15, context), wXD(8, context), wXD(42, context), wXD(8, context)),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff95A5A6)),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
          bottomLeft: Radius.circular(8.0),
        ),
        color: Color(0xfffafafa),
        boxShadow: [
          BoxShadow(
            color: const Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: wXD(10, context),
          ),
          Row(
            children: [
              SizedBox(
                width: wXD(15, context),
              ),
              Flexible(
                child: Text(
                  'Aguardando na fila virtual!',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: wXD(18, context),
                    color: ColorTheme.textColor,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          SizedBox(
            height: wXD(10, context),
          ),
          Flexible(
            child: Row(
              children: [
                SizedBox(
                  width: wXD(15, context),
                ),
                Flexible(
                  child: Text(
                    'Posição na fila ',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: wXD(18, context),
                      color: ColorTheme.textColor,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Text(
                  '$position',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: wXD(18, context),
                    color: ColorTheme.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          SizedBox(
            height: wXD(10, context),
          ),
          Flexible(
            child: Row(
              children: [
                SizedBox(
                  width: wXD(15, context),
                ),
                Flexible(
                  child: Text(
                    'Previsão estimada ',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: wXD(18, context),
                      color: ColorTheme.textColor,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Text(
                  '${DateFormat(DateFormat.HOUR_MINUTE, 'pt_Br').format(queuedUntil.toDate())}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: wXD(18, context),
                    color: ColorTheme.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                // "${date.toDate().hour}:${date.toDate().minute}",
                "${DateFormat(DateFormat.HOUR_MINUTE, 'pt_Br').format(date.toDate())}",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: wXD(10, context),
                  color: ColorTheme.white,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ],
      ),
    );
  }
}
