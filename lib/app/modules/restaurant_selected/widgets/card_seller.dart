import 'package:cached_network_image/cached_network_image.dart';
import 'package:pigu/app/core/models/seller_model.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardSeller extends StatelessWidget {
  var lightPrimaryColor = Color.fromRGBO(246, 183, 42, 1);
  var accentColor = Color.fromRGBO(114, 74, 134, 1);
  var primaryColor = Color.fromRGBO(254, 214, 165, 1);
  var orientation;
  final SellerModel seller;

  CardSeller(this.orientation, this.seller);

  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Size size = MediaQuery.of(context).size;
        // //print
        //     '%%%%%%% constraints.maxHeight ${constraints.maxHeight} ${constraints.maxWidth}%%%%%%%');

        return Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                    child: Stack(
                  children: <Widget>[
                    Container(
                      height: constraints.maxHeight * .5,
                      // height: size.height,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        image: new DecorationImage(
                          image: new NetworkImage(seller.bg_image),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    // Positioned(
                    //     bottom: 10,
                    //     right: 15,
                    //     child: Container(
                    //       // width: 60,
                    //       // height: 35,
                    //       height: constraints.maxHeight * .088,
                    //       width: constraints.maxWidth * .15,
                    //       child: Icon(Icons.wrap_text),
                    //       decoration: BoxDecoration(
                    //         color: ColorTheme.white,
                    //         borderRadius:
                    //             BorderRadius.all(Radius.circular(9.0)),
                    //       ),
                    //     ))
                  ],
                ))),
            Align(
                alignment: Alignment.center,
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: constraints.maxHeight * .35),
                      height: constraints.maxHeight * .35,
                      width: MediaQuery.of(context).size.width - 70,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        image: new DecorationImage(
                          image: new AssetImage("assets/map.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                            // height: 45,
                            height: constraints.maxHeight * .11,
                            // width: 65,
                            width: constraints.maxWidth * .165,
                            child: FlatButton(
                              onPressed: () {},
                              color: ColorTheme.blueCyan,
                              child: Center(
                                child: Icon(
                                  Icons.send,
                                  size: wXD(20, context),
                                  color: ColorTheme.white,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(18),
                                    topRight: Radius.circular(18),
                                    bottomLeft: Radius.circular(60),
                                    bottomRight: Radius.circular(18)),
                              ),
                            )))
                  ],
                )),
            Align(
                alignment: Alignment.center,
                child: Container(
                    margin: EdgeInsets.only(
                      top: constraints.maxHeight * .38,
                    ),
                    width: constraints.maxWidth * .1,
                    height: constraints.maxHeight * .1,
                    // margin: EdgeInsets.only(bottom: 40),
                    child: Image.asset("assets/icon/mapMarker.png"))),
            Container(
              padding: EdgeInsets.only(left: wXD(0, context)),
              child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Color(0xff707070).withOpacity(.4)))),
                    margin: EdgeInsets.only(
                      top: wXD(336, context),
                      right: wXD(15, context),
                      left: wXD(15, context),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          color: ColorTheme.textGrey,
                          size: constraints.maxHeight * .05,
                        ),
                        SizedBox(
                          width: wXD(5, context),
                        ),
                        Container(
                          width: wXD(310, context),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text("${seller.address}",
                                style: TextStyle(
                                    color: ColorTheme.textGrey, fontSize: 19),
                                overflow: TextOverflow.ellipsis),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
            // Align(
            //     alignment: Alignment.center,
            //     child: Container(
            //         margin: EdgeInsets.only(top: wXD(300, context)),
            //         child: Divider(
            //           endIndent: 30,
            //           indent: 30,
            //           color: ColorTheme.textGrey,
            //         ))),
            Positioned(
              bottom: constraints.maxHeight * .48,
              child: Row(
                children: [
                  InkWell(
                    child: Container(
                      width: constraints.maxWidth * .15,
                      height: constraints.maxWidth * .15,
                      margin: EdgeInsets.only(left: constraints.maxWidth * .04),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        border: Border.all(
                            width: 3.0, color: ColorTheme.primaryColor),
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
                          imageUrl: seller.avatar,
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
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: wXD(290, context),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        '${seller.name}',
                        maxLines: 1,
                        style: TextStyle(
                            color: ColorTheme.white,
                            fontSize: constraints.maxHeight * .1,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
