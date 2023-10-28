import 'package:pigu/shared/color_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CardMesa extends StatelessWidget {
  var primaryColor = Color.fromRGBO(254, 132, 0, 1);
  final String background_image;
  final String avatar;

  CardMesa({Key key, this.background_image, this.avatar}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 130,
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            image: new DecorationImage(
              image: new NetworkImage(background_image),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned(
          child: Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              border: Border.all(width: 3.0, color: ColorTheme.primaryColor),
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
                imageUrl: avatar,
                placeholder: (context, url) => CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          top: 10,
          left: 10,
        ),
      ],
    );
  }
}
