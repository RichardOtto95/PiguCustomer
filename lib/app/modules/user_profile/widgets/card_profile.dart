import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CardProfile extends StatelessWidget {
  var divisorColor = Color.fromRGBO(189, 174, 167, 1);
  var primaryColor = Color.fromRGBO(255, 132, 0, 1);
  final String username;
  final String avatar;
  final id;
  CardProfile({Key key, this.username, this.avatar, this.id, photo})
      : super(key: key);

  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Modular.get<HomeController>();

    return Container(
      height: wXD(230, context),

      // height: MediaQuery.of(context).size.height * .4,
      width: wXD(189, context),
      // height: 240,
      // width: 184,
      // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: new BoxDecoration(
        color: ColorTheme.primaryColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(58),
            bottomLeft: Radius.circular(21),
            bottomRight: Radius.circular(21),
            topRight: Radius.circular(21)),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: wXD(7, context),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0x29000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                )
              ],
            ),
            child: CircleAvatar(
              radius: 75,
              backgroundColor: Color(0xfffafafa),
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection("users")
                      .document(id)
                      .snapshots(),
                  builder: (context, snapshotUser) {
                    if (!snapshotUser.hasData) {
                      return Container();
                    }
                    if (snapshotUser.hasError) {
                      return Center(child: Text('ERRO: ${snapshotUser.error}'));
                    }
                    if (snapshotUser.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: ColorTheme.primaryColor,
                        ),
                      );
                    }
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageBuilder: (context, imageProvider) => Container(
                          // width: 100.0,
                          // height: 100.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        imageUrl: snapshotUser.data['avatar'],
                        placeholder: (context, url) =>
                            CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    );
                  }),

              //  CircleAvatar(
              //   backgroundImage: photo != null
              //       ? NetworkImage(photo)
              //       : AssetImage('assets/img/defaultUser.png'),
              //   backgroundColor: Colors.white,
              //   // child: ,
              //   radius: 72,
              // ),
            ),
          ),
          SizedBox(
            height: wXD(9, context),
          ),
          Container(
            width: wXD(180, context),
            child: Text(
              "$username",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xfffafafa),
                  fontSize: MediaQuery.of(context).size.width * .05),
              maxLines: 2,
            ),
          )
        ],
      ),
    );
  }
}
