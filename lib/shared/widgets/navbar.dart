import 'package:pigu/app/modules/user_profile/user_profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final String title;
  final Function iconOnTap;
  final Function infoOnTap;
  final Function backPage;
  final Icon iconButton;
  const NavBar({
    Key key,
    this.infoOnTap,
    this.backPage,
    this.title = "StarBucks",
    this.iconOnTap,
    this.iconButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(50, context),
      color: ColorTheme.primaryColor,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
          ),
          InkWell(
            onTap: backPage,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Icon(
                Icons.arrow_back,
                color: ColorTheme.white,
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width * .7,
            child: Text(
              title,
              // '',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: Color(0xfffafafa),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(child: SizedBox()),
          (iconOnTap != null)
              ? (iconButton != null)
                  ? InkWell(onTap: iconOnTap, child: iconButton)
                  : Icon(
                      Icons.favorite_border,
                      color: Color(0xfffafafa),
                    )
              : Container(),
          Container(
            width: MediaQuery.of(context).size.width * 0.03,
          ),
        ],
      ),
    );
  }
}

class NavTableBar extends StatelessWidget {
  final String title;
  final Function iconOnTap;
  final Icon iconButton;
  final Function goToTableInfo;
  final Function goBack;
  final String imageURL;
  const NavTableBar({
    Key key,
    this.title,
    this.iconOnTap,
    this.iconButton,
    this.goToTableInfo,
    this.imageURL,
    this.goBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(57, context),
      color: ColorTheme.primaryColor,
      child: Row(
        children: [
          SizedBox(width: wXD(16, context)),
          InkWell(
              onTap: goBack,
              child: Icon(
                Icons.arrow_back,
                color: ColorTheme.white,
              )),
          SizedBox(width: wXD(10, context)),
          InkWell(
            onTap: goToTableInfo,
            child: Container(
              width: wXD(50, context),
              height: wXD(50, context),
              margin: EdgeInsets.only(left: wXD(15, context)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                border: Border.all(
                    width: wXD(3, context), color: Color(0xff95A5A6)),
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
                  imageUrl: imageURL,
                  placeholder: (context, url) => CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ),
          SizedBox(width: wXD(10, context)),
          Expanded(
            child: InkWell(
              onTap: goToTableInfo,
              child: Row(
                children: [
                  Container(
                    width: wXD(210, context),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: Color(0xfffafafa),
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.info_outline,
                    color: Color(0xfffafafa),
                    size: wXD(23, context),
                  ),
                  SizedBox(
                    width: wXD(15, context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
