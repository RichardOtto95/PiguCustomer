import 'package:pigu/app/modules/table_opening/widgets/person_photo.dart';
import 'package:pigu/shared/utilities.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';

class PersonContainer extends StatelessWidget {
  final Function onTap;
  final String name;
  final String tel;
  final String avatar;
  final bool selected;
  const PersonContainer({
    Key key,
    this.onTap,
    this.tel,
    this.avatar,
    this.name,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8, left: 30),
      // height: 80,
      // decoration: BoxDecoration(
      //   border: Border(
      //       // bottom: BorderSide(width: 1, color: Color(0xffBDAEA7)),
      //       ),
      // ),
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PersonPhoto(
                avatar: avatar == null
                    ? 'https://firebasestorage.googleapis.com/v0/b/ayou-4d78d.appspot.com/o/defaut%2FdefaultUser.png?alt=media&token=33daa153-d1f8-4d92-9afe-30e3f646a8fd'
                    // 'https://www.level10martialarts.com/wp-content/uploads/2017/04/default-image.jpg'
                    : avatar,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 16,
                      ),
                      Container(
                        width: wXD(200, context),
                        child: Text(
                          '$name',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
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
                        '$tel',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: ColorTheme.textColor,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
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
}
