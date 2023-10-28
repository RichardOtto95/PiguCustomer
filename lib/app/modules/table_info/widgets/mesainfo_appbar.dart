import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/app/modules/user_profile/user_profile_page.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MesainfoAppbar extends StatelessWidget {
  var primaryColor = Color.fromRGBO(254, 132, 0, 1);
  var darkPrimaryColor = Color.fromRGBO(249, 153, 94, 1);
  var lightPrimaryColor = Color.fromRGBO(246, 183, 42, 1);
  var primaryText = Color.fromRGBO(22, 16, 18, 1);
  var secondaryText = Color.fromRGBO(84, 74, 65, 1);
  var accentColor = Color.fromRGBO(114, 74, 134, 1);
  var divisorColor = Color.fromRGBO(189, 174, 167, 1);
  final homeController = Modular.get<HomeController>();
  final String title;
  final String imageURL;
  final Function iconOnTap;
  final Icon iconButton;
  final Function newImage;
  final String host;
  var mesaName = "Gordice";

  MesainfoAppbar(
      {Key key,
      this.title,
      this.imageURL,
      this.iconOnTap,
      this.iconButton,
      this.newImage,
      this.host})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var styleMenu =
        TextStyle(fontSize: wXD(12, context), color: Colors.grey[600]);
    List menuOption = [
      Text('Mudar Anfitrião', style: styleMenu),
      Text('Arquivar mesa', style: styleMenu),
      Text('Remover Participante', style: styleMenu),
      Text('Silenciar Notificações', style: styleMenu),
      Text('Adicionar Participantes', style: styleMenu),
    ];
    var user = homeController.user.uid;
    return Container(
      height: wXD(67, context),
      color: ColorTheme.primaryColor,
      child: Row(
        children: [
          SizedBox(
            width: wXD(16, context),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: ColorTheme.white),
          ),
          SizedBox(
            width: wXD(10, context),
          ),
          InkWell(
            onTap: newImage,
            child: Container(
              width: wXD(50, context),
              height: wXD(50, context),
              margin: EdgeInsets.only(left: wXD(15, context)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                border: Border.all(
                    width: wXD(3, context), color: Color(0xff95A5A6)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x29000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(90),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: imageURL,
                  placeholder: (context, url) => CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ),
          SizedBox(
            width: wXD(10, context),
          ),
          Expanded(
            child: Container(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: wXD(16, context),
                  color: Color(0xfffafafa),
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Visibility(
            visible: host == user,
            child: (iconOnTap != null)
                ? (iconButton != null)
                    ? InkWell(onTap: iconOnTap, child: iconButton)
                    : Icon(
                        Icons.favorite_border,
                        color: Color(0xfffafafa),
                      )
                : Container(),
          ),
          SizedBox(
            width: wXD(30, context),
          ),
        ],
      ),
    );
  }
}
