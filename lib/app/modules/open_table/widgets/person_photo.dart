import 'package:pigu/shared/color_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PersonPhoto extends StatelessWidget {
  final double width;
  final double height;
  final double marTop;
  final double marRight;
  final double marLeft;
  final double marBottom;
  final avatar;
  final Function goTo;
  const PersonPhoto({
    this.goTo,
    this.avatar,
    Key key,
    this.width = 64.0,
    this.height = 64.0,
    this.marTop = 14,
    this.marRight = 12,
    this.marLeft = 0,
    this.marBottom = 8,
  }) : super(key: key);
//
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: goTo,
      child: Container(
          width: width,
          height: width,
          margin:
              EdgeInsets.only(top: marTop, right: marRight, bottom: marBottom),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90),
            border: Border.all(width: 3.0, color: const Color(0xffbdaea7)),
            boxShadow: [
              BoxShadow(
                color: const Color(0x29000000),
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: avatar != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: avatar,
                    placeholder: (context, url) => CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image.asset('assets/img/defaultUser.png'),
                  ),
                )),
    );
  }
}
