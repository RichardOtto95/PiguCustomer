import 'package:cached_network_image/cached_network_image.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PersonPhotoSelectedCreate extends StatelessWidget {
  final Function onTap;
  final String username;
  const PersonPhotoSelectedCreate({
    Key key,
    this.onTap,
    this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          // color: Colors.red,
          height: MediaQuery.of(context).size.height * .097,
          width: MediaQuery.of(context).size.width * .145,
          margin: EdgeInsets.only(right: 6),
        ),
        Positioned(
          top: 5,
          right: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // SizedBox(width: 54),
              StreamBuilder(
                  stream: Firestore.instance
                      .collection('users')
                      .where('username', isEqualTo: username)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else {
                      return InkWell(
                        onTap: onTap,
                        child: Container(
                          width: MediaQuery.of(context).size.width * .137,
                          height: MediaQuery.of(context).size.width * .137,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            border: Border.all(
                                width: 3.0, color: const Color(0xffbdaea7)),
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
                              imageUrl: snapshot.data.documents.first['avatar'],
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(ColorTheme.yellow),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: MediaQuery.of(context).size.width * .05,
              width: MediaQuery.of(context).size.width * .05,
              decoration:
                  BoxDecoration(color: ColorTheme.blue, shape: BoxShape.circle),
              child: Icon(
                Icons.close,
                size: 14,
                color: ColorTheme.textGrey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
