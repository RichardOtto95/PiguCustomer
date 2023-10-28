import 'package:cached_network_image/cached_network_image.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../home_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CompanyContainer extends StatelessWidget {
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  final homeController = Modular.get<HomeController>();

  final String mainImg;
  final String seller_id;
  final String name;
  final String iconImg;
  final String address;
  final bool restaurantFav;
  final double local;
  CompanyContainer({
    Key key,
    this.mainImg,
    this.name,
    this.iconImg,
    this.restaurantFav,
    this.seller_id,
    this.address,
    this.local,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeController = Modular.get<HomeController>();

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(
              left: wXD(20, context),
              right: wXD(20, context),
              bottom: wXD(16, context)),
          // height: 165.0,

          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: const Color(0xfffafafa),
            boxShadow: [
              BoxShadow(
                color: const Color(0x29000000),
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: wXD(108, context),
                    width: double.infinity,
                    margin: EdgeInsets.all(7),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: mainImg,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  Positioned(
                    top: wXD(7, context),
                    right: wXD(7, context),
                    child: Container(
                      width: wXD(110, context),
                      height: wXD(108, context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(14.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.175,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.60,
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: wXD(16, context),
                        color: ColorTheme.textColor,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Image.asset(
                    'assets/icon/sender.png',
                    height: wXD(20, context),
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    width: wXD(22, context),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: wXD(50, context),
                  ),
                  Image.asset(
                    'assets/icon/marker.png',
                    height: wXD(16, context),
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    width: wXD(3, context),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: wXD(4, context)),
                    width: wXD(194, context),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '$address',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: wXD(16, context),
                        color: ColorTheme.textGrey,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '${local.toStringAsFixed(1)}km',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: wXD(16, context),
                      color: ColorTheme.blue,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: wXD(7, context),
                  ),
                ],
              ),
            ],
          ),
        ),
        StatefulBuilder(builder: (context, setState) {
          return StreamBuilder(
              stream: Firestore.instance
                  .collection('users')
                  .document(homeController.user.uid)
                  .collection('favorite_sellers')
                  .where('id', isEqualTo: seller_id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  QuerySnapshot ds = snapshot.data;
                  return ds.documents.isEmpty
                      ? Positioned(
                          top: wXD(16, context),
                          right: wXD(36, context),
                          child: InkWell(
                            onTap: () async {
                              // //print'seller_id: $seller_id');
                              // //print'ds: ${ds.documents.first.data}');
                              //  richard
                              //
                              await Firestore.instance
                                  .collection('users')
                                  .document(homeController.user.uid)
                                  .collection('favorite_sellers')
                                  .add({'id': seller_id});
                            },
                            child: Icon(
                              Icons.favorite_border,
                              color: ColorTheme.white,
                              size: wXD(32, context),
                            ),
                          ),
                        )
                      : ds.documents[0].data['id'] == seller_id
                          ? Positioned(
                              top: wXD(16, context),
                              right: 36,
                              child: InkWell(
                                onTap: () async {
                                  // //print'seller_id: $seller_id');
                                  // //print'ds: ${ds.documents.first.data}');
                                  QuerySnapshot _seller = await Firestore
                                      .instance
                                      .collection('users')
                                      .document(homeController.user.uid)
                                      .collection('favorite_sellers')
                                      .where('id', isEqualTo: seller_id)
                                      .getDocuments();
                                  _seller.documents.first.reference.delete();
                                },
                                child: Icon(Icons.favorite,
                                    color: ColorTheme.white,
                                    size: wXD(32, context)),
                              ))
                          : Positioned(
                              top: wXD(16, context),
                              right: wXD(36, context),
                              child: InkWell(
                                onTap: () async {
                                  // //print'seller_id: $seller_id');
                                  // //print'ds: ${ds.documents.first.data}');
                                  await Firestore.instance
                                      .collection('users')
                                      .document(homeController.user.uid)
                                      .collection('favorite_sellers')
                                      .add({'id': seller_id});
                                },
                                child: Icon(
                                  Icons.favorite_border,
                                  color: ColorTheme.white,
                                  size: wXD(32, context),
                                ),
                              ),
                            );
                }
              });
        }),
        Positioned(
          bottom: wXD(52, context),
          left: wXD(40, context),
          child: Container(
            padding: EdgeInsets.all(4),
            height: wXD(48, context),
            width: wXD(48, context),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Color(0xffF9995E)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                color: Colors.white,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: iconImg,
                  placeholder: (context, url) => CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
