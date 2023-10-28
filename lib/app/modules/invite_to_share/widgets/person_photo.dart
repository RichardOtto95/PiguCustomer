import 'package:pigu/shared/color_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PersonPhoto extends StatelessWidget {
  const PersonPhoto({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64.0,
      height: 64.0,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(90),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: "https://i.pravatar.cc/150?img=30",
          placeholder: (context, url) => CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
