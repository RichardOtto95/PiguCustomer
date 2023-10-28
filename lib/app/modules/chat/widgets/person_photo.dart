import 'package:cached_network_image/cached_network_image.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';

class PersonPhoto extends StatelessWidget {
  final String urlImage;
  const PersonPhoto({
    Key key,
    this.urlImage =
        "https://www.diretoriodigital.com.br/wp-content/uploads/2013/05/765-default-avatar.png",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0),
      width: 36.0,
      height: 36.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
        border: Border.all(width: 3.0, color: ColorTheme.textGrey),
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
          imageUrl: urlImage,
          placeholder: (context, url) => CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
