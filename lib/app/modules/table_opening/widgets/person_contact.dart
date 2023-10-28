import 'package:pigu/app/modules/table_opening/widgets/person_photo.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PersonContact extends StatelessWidget {
  final Function onTap;
  final String username;
  // final String name;
  // final String tel;
  // final String code;
  // final String avatar;
  final bool selected;
  const PersonContact({
    Key key,
    this.onTap,
    // this.tel,
    // this.avatar,
    // this.name,
    this.selected = false,
    this.username,
    // this.code,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double wXD(double size) {
      double finalSize = MediaQuery.of(context).size.width * size / 375;
      return finalSize;
    }

    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .where('username', isEqualTo: username)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            DocumentSnapshot _user = snapshot.data.documents.first;
            return Container(
              margin: EdgeInsets.only(left: wXD(35)),
              // height: 104,
              width: wXD(80),
              height: wXD(104),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: ColorTheme.textGrey),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: wXD(14),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      PersonPhoto(
                        height: wXD(60),
                        width: wXD(60),
                        avatar: _user.data['avatar'],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: wXD(16),
                              ),
                              Container(
                                // color: Colors.red,
                                width: MediaQuery.of(context).size.width * .5,
                                child: Text(
                                  '${_user.data['username']}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: wXD(14),
                                    color: ColorTheme.textColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 34,
                              ),
                              Text(
                                '${_user.data['mobile_full_number']}',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: wXD(14),
                                  color: ColorTheme.textGrey,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: wXD(8),
                          )
                        ],
                      ),
                      Spacer(),
                      InkWell(
                        onTap: onTap,
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          child: selected
                              ? Image.asset(
                                  'assets/icon/addSelected.png',
                                  height: 36,
                                  width: 36,
                                  fit: BoxFit.contain,
                                )
                              : Image.asset(
                                  'assets/icon/addPeople.png',
                                  height: 36,
                                  width: 36,
                                  fit: BoxFit.contain,
                                ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }
        });
  }
}
