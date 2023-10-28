import 'package:cached_network_image/cached_network_image.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';

class PersonPhoto extends StatelessWidget {
  final double width;
  final double height;
  final String avatar;
  const PersonPhoto({
    Key key,
    this.width = 64.0,
    this.height = 64.0,
    this.avatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
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
          imageUrl: avatar,
          placeholder: (context, url) => CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
