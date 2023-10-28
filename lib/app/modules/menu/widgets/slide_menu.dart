import 'package:pigu/app/modules/order/widgets/item_order_with_person.dart';
import 'package:pigu/app/modules/user_profile/user_profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pigu/app/modules/menu/menu_controller.dart';
import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'slide_note.dart';

class SlideMenu extends StatefulWidget {
  final String name;
  final String note;
  final double price;
  final bool clickItem;
  final num preparation;
  final Function plus;
  final Function remove;
  final Function confirmOrder;
  final Function goToInvited;
  final String image;
  final String noteInput;
  SlideMenu({
    this.plus,
    this.goToInvited,
    this.confirmOrder,
    this.remove,
    // this.addOrder,
    this.name,
    this.note,
    this.image,
    this.price,
    Key key,
    this.noteInput,
    this.clickItem,
    this.preparation,
  }) : super(key: key);

  @override
  _SlideMenuState createState() => _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu> {
  final menuController = Modular.get<MenuController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    menuController.setClickNote(false);
    menuController.setNoteInput('');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool clickNote = false;

    return Observer(builder: (_) {
      return Stack(
        children: [
          AnimatedContainer(
            duration: Duration(seconds: 2),
            curve: Curves.ease,
            color: Colors.black.withOpacity(.3),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: InkWell(onTap: () {
              setState(() {
                menuController.setClickNote(false);
                menuController.setclickItem(false);
              });
            }),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: InkWell(
                onTap: () => menuController.setclickItem(true),
                child: menuController.clickNote != true
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: SingleChildScrollView(
                            reverse: true,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(26),
                                    topRight: Radius.circular(26)),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.002,
                                      width: MediaQuery.of(context).size.width *
                                          0.50,
                                      margin: EdgeInsets.symmetric(
                                        vertical:
                                            MediaQuery.of(context).size.height *
                                                0.018,
                                      ),
                                      decoration: BoxDecoration(
                                          color: ColorTheme.textGrey,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      width: MediaQuery.of(context).size.width *
                                          0.87,
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
                                          imageUrl: widget.image,
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                ColorTheme.yellow),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Container(
                                      width: wXD(375, context),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: wXD(17, context)),
                                      child: Text(
                                        "${widget.name}",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: wXD(16, context),
                                          color: ColorTheme.textColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.005,
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Text(
                                        "${widget.note}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: wXD(16, context),
                                          color: ColorTheme.textGrey,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.65,
                                          child: Text(
                                            "Tempo de Médio de Preparação:",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04,
                                              color: ColorTheme.textGrey,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          child: Text(
                                            "${widget.preparation} min",
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04,
                                              color: ColorTheme.textColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            // overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .05,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Container(
                                      height: 1,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: wXD(16, context)),
                                      decoration: BoxDecoration(
                                          color: ColorTheme.textGrey,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: widget.goToInvited,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                              ),
                                              Image.asset(
                                                'assets/icon/addPeople.png',
                                                height: wXD(36, context),
                                                width: wXD(36, context),
                                                fit: BoxFit.contain,
                                              ),
                                              SizedBox(
                                                width: wXD(6, context),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.001,
                                                  ),
                                                  Text(
                                                    'Dividir',
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize:
                                                          wXD(16, context),
                                                      color:
                                                          ColorTheme.textColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  Text(
                                                    'com alguém',
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto',
                                                      fontSize:
                                                          wXD(16, context),
                                                      color:
                                                          ColorTheme.textColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Stack(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  clickNote = !clickNote;
                                                });
                                                menuController.setClickNote(
                                                    !menuController.clickNote);
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.06,
                                                margin: EdgeInsets.only(
                                                    top: wXD(7, context)),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(21.0),
                                                    topRight:
                                                        Radius.circular(21.0),
                                                    bottomRight:
                                                        Radius.circular(21.0),
                                                    bottomLeft:
                                                        Radius.circular(58.0),
                                                  ),
                                                  color: ColorTheme.blueCyan,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(
                                                          0x29000000),
                                                      offset: Offset(0, 3),
                                                      blurRadius: 6,
                                                    ),
                                                  ],
                                                ),
                                                child: Container(
                                                  child: Center(
                                                    child: Text(
                                                      'Obs.',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize:
                                                            wXD(16, context),
                                                        color: ColorTheme.white,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            menuController.noteInput != ''
                                                ? Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      height: wXD(23, context),
                                                      width: wXD(23, context),
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              ColorTheme.blue),
                                                      child: Center(
                                                        child: Text(
                                                          '!',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: wXD(
                                                                  16, context),
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox()
                                          ],
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                            onTap: widget.remove,
                                            child: Container(
                                              height: wXD(40, context),
                                              width: wXD(40, context),
                                              child: Icon(
                                                Icons.remove,
                                                size: wXD(16, context),
                                                color: ColorTheme.brown,
                                              ),
                                            )),
                                        SizedBox(
                                          width: wXD(25, context),
                                        ),
                                        Text(
                                          '${menuController.qtdOrder.toInt()}',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: wXD(16, context),
                                            color: ColorTheme.textColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          width: wXD(25, context),
                                        ),
                                        InkWell(
                                            onTap: widget.plus,
                                            child: Container(
                                              height: wXD(40, context),
                                              width: wXD(40, context),
                                              child: Icon(
                                                Icons.add,
                                                size: wXD(18, context),
                                                color: ColorTheme.brown,
                                              ),
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01),
                                    InkWell(
                                      onTap: widget.confirmOrder,
                                      child: Container(
                                          height: wXD(42, context),
                                          width: wXD(350, context),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: ColorTheme.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(21)),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: wXD(31, context),
                                              ),
                                              Text(
                                                'Adicionar ao pedido',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: wXD(16, context),
                                                  color: ColorTheme.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Spacer(),
                                              Text(
                                                'R\$',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: wXD(16, context),
                                                  color: ColorTheme.white,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(
                                                width: wXD(4, context),
                                              ),
                                              Text(
                                                '${formatedCurrency(widget.price * menuController.qtdOrder)}',
                                                // '${double.parse(widget.price) * menuController.qtdOrder}',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: wXD(16, context),
                                                  color: ColorTheme.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(
                                                width: wXD(16, context),
                                              )
                                            ],
                                          )),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                              ),
                            )),
                      )
                    : SlideMenuNote(
                        noteInpunt: (val) {
                          menuController.setNoteInput(val);
                        },
                        okButtom: () {
                          setState(() {
                            menuController.clickNote = !clickNote;
                          });
                          menuController
                              .setClickNote(!menuController.clickNote);
                        },
                      )),
          )
        ],
      );
    });
  }
}
