import 'package:pigu/shared/color_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PersonPhotoInTable extends StatelessWidget {
  final String photoUrl;
  final Color color;
  const PersonPhotoInTable({
    Key key,
    this.photoUrl,
    this.color,
  }) : super(key: key);
//
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 36,
        height: 36,
        margin: EdgeInsets.only(right: 22, bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(90),
          border: Border.all(
              width: 3.0, color: (color != null) ? color : Color(0xffbdaea7)),
          boxShadow: [
            BoxShadow(
              color: const Color(0x29000000),
              offset: Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: photoUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(90),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: photoUrl,
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
              ));
  }
}
