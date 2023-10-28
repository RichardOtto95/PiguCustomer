import 'package:cached_network_image/cached_network_image.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:image_stack/image_stack.dart';
import 'package:pigu/shared/utilities.dart';

class ChatBubblePersonSplit extends StatefulWidget {
  final String title;
  const ChatBubblePersonSplit({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  _ChatBubblePersonSplitState createState() => _ChatBubblePersonSplitState();
}

class _ChatBubblePersonSplitState extends State<ChatBubblePersonSplit> {
  Future<dynamic> task;
  List<String> listAvatar = [];
  @override
  // void initState() {
  //   task = getMembers();

  //   super.initState();
  // }

  // Future<dynamic> getMembers() async {
  //   QuerySnapshot amigos = await Firestore.instance
  //       .collection('orders')
  //       .document(widget.orderID)
  //       .collection('members')
  //       .getDocuments();

  //   amigos.documents.forEach((element) async {
  //     DocumentSnapshot _amigo = await Firestore.instance
  //         .collection('users')
  //         .document(element.data['user_id'])
  //         .get();
  //     await listAvatar.add(_amigo.data['avatar']);
  //   });

  //   await Future.delayed(Duration(seconds: 1));

  //   return listAvatar;
  // }

  // @override
  // void dispose() {
  //   // homeController.setStatusOrder('');
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62.0,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      margin: EdgeInsets.fromLTRB(15, 8, 42, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
          bottomRight: Radius.circular(8.0),
          bottomLeft: Radius.circular(24.0),
        ),
        color: Colors.white,
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
          Row(
            children: [
              Text(
                "Nome do usuário",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: wXD(16, context),
                  color: ColorTheme.textColor,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(
            height: wXD(10, context),
          ),
          Row(
            children: [
              SizedBox(
                width: wXD(14, context),
              ),
              Text(
                "Quer dividir um",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: wXD(16, context),
                  color: ColorTheme.textGrey,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(
            height: wXD(10, context),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Container(
                        width: wXD(204, context),
                        height: wXD(100, context),
                        //margin: EdgeInsets.only(left: 85),
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
                            imageUrl:
                                "https://vivatatuape.com.br/portal/wp-content/uploads/2019/05/starbucks-osasco-2.jpg",
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
                      Positioned(
                        top: 4,
                        right: wXD(104, context),
                        child: Container(
                          width: wXD(54, context),
                          height: wXD(42, context),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(21.0),
                              topRight: Radius.circular(21.0),
                              bottomRight: Radius.circular(21.0),
                              bottomLeft: Radius.circular(58.0),
                            ),
                            color: ColorTheme.blueCyan,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x29000000),
                                offset: Offset(0, 3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Obs.',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: wXD(16, context),
                                color: ColorTheme.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: wXD(10, context),
          ),
          Row(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: wXD(15, context),
                  color: ColorTheme.textColor,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
          SizedBox(
            height: wXD(6, context),
          ),
          Row(
            children: [
              SizedBox(
                width: wXD(15, context),
              ),

              Container(
                width: wXD(180, context),
                height: wXD(36, context),
                child: Row(
                  children: [
                    Text(
                      'com',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: wXD(16, context),
                        color: ColorTheme.textGrey,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // width: 125,
                alignment: Alignment.centerLeft,
                // padding: EdgeInsets.only(left: 50),
                child: FutureBuilder(
                    future: task,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return new Center(
                            child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(ColorTheme.yellow),
                        ));
                      } else {
                        if (snapshot.hasError)
                          return new Text('Error: ${snapshot.error}');
                        else {
                          if (snapshot.hasData) {
                            int photoheight = 0;
                            return Container(
                                padding:
                                    EdgeInsets.only(left: wXD(65, context)),
                                // padding: photoheight ==
                                //         1
                                //     ? EdgeInsets
                                //         .only(
                                //             left:
                                //                 0)
                                //     : photoheight ==
                                //             2
                                //         ? EdgeInsets.only(
                                //             left:
                                //                 25)
                                //         : photoheight ==
                                //                 3
                                //             ? EdgeInsets.only(
                                //                 left: wXD(200, context))
                                //             : photoheight == 4
                                //                 ? EdgeInsets.only(left: wXD(200, context))
                                //                 : photoheight > 4
                                //                     ? EdgeInsets.only(left: 90)
                                //                     : EdgeInsets.all(0),
                                alignment: Alignment.centerLeft,
                                child: ImageStack(
                                  imageList: listAvatar,
                                  imageCount: 4,
                                  totalCount: listAvatar.length,
                                  imageRadius: wXD(30, context),
                                  imageBorderWidth: 1,
                                ));
                          } else
                            return Container();
                        }
                      }
                    }),
              ),
              Text(
                '?',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: wXD(16, context),
                  color: ColorTheme.textGrey,
                  fontWeight: FontWeight.w300,
                ),
              ),
              // for (var i in [2, 1, 0])
              //   Positioned(
              //     left: 28.0 * i,
              //     child: PersonPhoto(),
              //   ),
            ],
          ),
          SizedBox(
            height: wXD(10, context),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  height: wXD(37, context),
                  width: wXD(96, context),
                  margin: EdgeInsets.only(left: wXD(14, context)),
                  decoration: BoxDecoration(
                    color: ColorTheme.white,
                    border: Border.all(color: ColorTheme.primaryColor),
                    borderRadius: BorderRadius.circular(21),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x29000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Não',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: wXD(16, context),
                        color: ColorTheme.textGrey,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )),
              Container(
                  height: wXD(37, context),
                  width: wXD(96, context),
                  margin: EdgeInsets.only(right: wXD(14, context)),
                  decoration: BoxDecoration(
                    color: ColorTheme.primaryColor,
                    borderRadius: BorderRadius.circular(21),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x29000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Sim!',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: wXD(16, context),
                        color: ColorTheme.white,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )),
            ],
          ),
          SizedBox(
            height: wXD(6, context),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "16:45",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 10,
                  color: ColorTheme.orange,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ],
      ),
    );
  }
}
