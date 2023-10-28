import 'package:cached_network_image/cached_network_image.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';

class PersonPhoto extends StatelessWidget {
  const PersonPhoto({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 36),
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
          child: Image.asset('assets/img/defaultUser.png')),
    );
  }
}
