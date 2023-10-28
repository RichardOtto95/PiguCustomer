import 'package:pigu/app/modules/user_profile/user_profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pigu/app/modules/menu/menu_controller.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SlideMenuMockup extends StatelessWidget {
  final String name;
  final String note;
  final bool clickItem;
  final String price;
  final num preparation;
  final double addOrder;
  final Function plus;
  final Function remove;
  final Function confirmOrder;
  final Function goToInvited;
  final menuController = Modular.get<MenuController>();

  final String image;
  SlideMenuMockup({
    this.plus,
    this.goToInvited,
    this.confirmOrder,
    this.remove,
    this.addOrder,
    this.name,
    this.note,
    this.image,
    this.price,
    Key key,
    this.clickItem,
    this.preparation,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // return Observer(builder: (_) {
    return Stack(children: [
      AnimatedContainer(
        duration: Duration(seconds: 2),
        curve: Curves.ease,
        color: Colors.black.withOpacity(.3),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: InkWell(onTap: () {
          menuController.setclickItem(false);
        }),
      ),
      Positioned(
          bottom: 0,
          child: Container(
              height: MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              color: Colors.black.withOpacity(.2),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(26),
                        topRight: Radius.circular(26)),
                  ),
                  child: ListView(children: [
                    Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.002,
                          width: MediaQuery.of(context).size.width * 0.50,
                          margin: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.02,
                          ),
                          decoration: BoxDecoration(
                              color: ColorTheme.textGrey,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.22,
                          width: MediaQuery.of(context).size.width * 0.87,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x29000000),
                                offset: Offset(0, 3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: image,
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: Text(
                                "$name",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  color: ColorTheme.textColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: wXD(20, context)),
                          child: Text(
                            "${note}",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              color: ColorTheme.textGrey,
                              fontWeight: FontWeight.w300,
                            ),
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * .005,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: Text(
                                "Tempo de Médio de Preparação:",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  color: ColorTheme.textGrey,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              child: Text(
                                "$preparation min",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  color: ColorTheme.textColor,
                                  fontWeight: FontWeight.w700,
                                ),
                                // overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .05,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                      ],
                    ),
                  ]))))
    ]);
    // });
  }
}
