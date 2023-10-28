import 'package:pigu/app/modules/open_table/open_table_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:pigu/app/modules/open_table/widgets/person_photo.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:pigu/app/modules/home/home_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:image_stack/image_stack.dart';

class PersonContainer extends StatefulWidget {
  final String avatar;
  final String name;
  final Function onTap;
  final Timestamp createAt;
  final String group;
  final int counter;
  // final bool eventVerifier;
  final listMembers;
  final String sellerId;
  const PersonContainer({
    this.createAt,
    this.avatar,
    this.name,
    Key key,
    this.onTap,
    this.group,
    this.counter,
    // this.eventVerifier,
    this.listMembers,
    this.sellerId,
  }) : super(key: key);

  @override
  _PersonContainerState createState() => _PersonContainerState();
}

class _PersonContainerState extends State<PersonContainer> {
  Future<dynamic> task;
  List<String> members = [];

  @override
  void initState() {
    task = getMembersAvatar();
    super.initState();
  }

  Future<dynamic> getMembersAvatar() async {
    QuerySnapshot _members = await Firestore.instance
        .collection('groups')
        .document(widget.group)
        .collection('members')
        .getDocuments();

    _members.documents.forEach((element) async {
      DocumentSnapshot _memberss = await Firestore.instance
          .collection('users')
          .document(element.data['user_id'])
          .get();
      await members.add(_memberss.data['avatar']);
    });

    await Future.delayed(Duration(seconds: 1));

    return members;
  }

  @override
  Widget build(BuildContext context) {
    double wXD(double size, BuildContext context) {
      double finalSize = MediaQuery.of(context).size.width * size / 375;
      return finalSize;
    }

    final homeController = Modular.get<HomeController>();
    final openTableController = Modular.get<OpenTableController>();
    int photoheight;
    String sellerAvatar;

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        height: wXD(100, context),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    StreamBuilder(
                        stream: Firestore.instance
                            .collection('groups')
                            .document(widget.group)
                            .snapshots(),
                        builder: (context, avt) {
                          if (avt.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (avt.hasError) {
                            return Center(
                              child: Text('Erro: ${avt.error}'),
                            );
                          }

                          if (!avt.hasData) {
                            return Container();
                          }
                          String avatar = avt.data['avatar'];
                          return Container(
                              width: 64,
                              height: 64,
                              margin: EdgeInsets.only(
                                  top: 14, right: 12, bottom: 8),
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
                              child: avatar != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(90),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: avatar,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                              ColorTheme.yellow),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(90),
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: Image.asset(
                                            'assets/img/defaultUser.png'),
                                      ),
                                    ));
                        }),
                    StreamBuilder(
                        stream: Firestore.instance
                            .collection('users')
                            .document(homeController.user.uid)
                            .collection('my_group')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            int counter;
                            snapshot.data.documents.forEach((element) {
                              if (element['id'] == widget.group) {
                                counter = element['event_counter'];
                                openTableController.setEventcVerifier(counter);
                              }
                            });
                            return Visibility(
                                visible: openTableController.eventcVerifier !=
                                        0 &&
                                    openTableController.eventcVerifier != null,
                                child: Positioned(
                                    left: wXD(45, context),
                                    top: wXD(10, context),
                                    child: Container(
                                        height: wXD(20, context),
                                        width: wXD(20, context),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: ColorTheme.blue),
                                        child: Text(
                                          '${openTableController.eventcVerifier}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: wXD(16, context),
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300),
                                        ))));
                          }
                        })
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text('${widget.name}',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: wXD(16, context),
                                  color: ColorTheme.textColor,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      Container(
                          width: wXD(185, context),
                          height: wXD(45, context),
                          child: FutureBuilder(
                              future: task,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                } else {
                                  return Container(
                                    padding: snapshot.data.length == 1
                                        ? EdgeInsets.only(left: 0)
                                        : snapshot.data.length == 2
                                            ? EdgeInsets.only(
                                                left: wXD(25, context))
                                            : snapshot.data.length == 3
                                                ? EdgeInsets.only(
                                                    left: wXD(55, context))
                                                : snapshot.data.length == 4
                                                    ? EdgeInsets.only(left: 85)
                                                    : snapshot.data.length > 4
                                                        ? EdgeInsets.only(
                                                            left: wXD(
                                                                90, context))
                                                        : EdgeInsets.all(0),
                                    child: ImageStack(
                                      imageList: snapshot.data,
                                      // showTotalCount: true,
                                      imageCount:
                                          4, // Maximum number of images to be shown in stack
                                      totalCount:
                                          // 2,
                                          widget.listMembers.length,
                                      imageRadius: 40,
                                      // Radius of each images
                                      // imageCount: haha.length / 2,
                                      //     3, // Maximum number of images to be shown in stack
                                      imageBorderWidth:
                                          1, // Border width around the images
                                    ),
                                  );
                                }
                              })),
                      SizedBox(
                        width: wXD(5, context),
                        height: wXD(15, context),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 0, left: wXD(5, context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: wXD(60, context),
                            height: wXD(60, context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                                bottomLeft: Radius.circular(8),
                              ),
                              color: ColorTheme.orange,
                            ),
                          ),
                          Positioned(
                            top: 7,
                            right: 7,
                            child: StreamBuilder(
                                stream: Firestore.instance
                                    .collection('sellers')
                                    .document(widget.sellerId)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                          ColorTheme.yellow),
                                    );
                                  } else {
                                    sellerAvatar = snapshot.data['avatar'];

                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(90),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        width: wXD(40, context),
                                        height: wXD(40, context),
                                        imageUrl: sellerAvatar,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                              ColorTheme.yellow),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    );
                                  }
                                }),
                          )
                        ],
                      ),
                      Container(
                        width: wXD(60, context),
                        child: Text(
                          '${DateFormat(DateFormat.ABBR_WEEKDAY, 'pt_Br').format(widget.createAt.toDate())} ${DateFormat(DateFormat.HOUR_MINUTE, 'pt_Br').format(widget.createAt.toDate())}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: wXD(10, context),
                            color: ColorTheme.textColor,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 0,
                  width: wXD(10, context),
                  child: Container(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
