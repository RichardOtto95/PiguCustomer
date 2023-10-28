import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class FormItemWidget extends StatelessWidget {
  final String title;
  final String title2;
  final String msgError1;
  final String msgError2;
  final String hintText;
  final String hintText2;
  final Function val1;
  final Function val2;
  final Function setFocus1;
  final Function setFocus2;
  final Function onEditingComplete;

  final FocusNode focus1;
  final FocusNode focus2;
  final double width;
  final value;
  final int maxLength1;
  final int maxLength2;
  final bool enable1;
  final bool enable2;

  const FormItemWidget({
    Key key,
    this.val1,
    this.hintText2,
    this.onEditingComplete,
    this.maxLength1,
    this.maxLength2,
    this.val2,
    this.focus1,
    this.hintText,
    this.focus2,
    this.title,
    this.msgError1,
    this.msgError2,
    this.value,
    this.title2,
    this.setFocus1,
    this.enable1,
    this.enable2,
    this.setFocus2,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          (width != null)
              ? Container(
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "$title",
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff757575),
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      InkWell(
                        onTap: setFocus1,
                        child: Container(
                          height: 52,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextField(
                                onEditingComplete: onEditingComplete,
                                onChanged: val1,
                                maxLength: maxLength1,
                                focusNode: focus1,
                                enabled: enable1,
                                style: TextStyle(
                                    color: Color(0xffBDBDBD),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                                decoration: InputDecoration(
                                  counterText: "",
                                  // errorText: val1 != null ? '' : msgError1,
                                  contentPadding: EdgeInsets.all(0.0),
                                  hintText: hintText,
                                  isDense: true,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffBDBDBD)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffBDBDBD)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "$title",
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff757575),
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      InkWell(
                        onTap: setFocus1,
                        child: Container(
                          height: 52,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextField(
                                onEditingComplete: onEditingComplete,
                                onChanged: val1,
                                maxLength: maxLength1,
                                focusNode: focus1,
                                enabled: enable1,
                                style: TextStyle(
                                    color: Color(0xffBDBDBD),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                                decoration: InputDecoration(
                                  counterText: '',
                                  errorText: val1 != null ? msgError1 : '',
                                  contentPadding: EdgeInsets.all(0.0),
                                  hintText: hintText,
                                  isDense: true,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffBDBDBD)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffBDBDBD)),
                                  ),
                                ),
                              ),
                              // SizedBox(
                              //   height: 8,
                              // )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
          SizedBox(
            width: 7,
          ),
          (title2 != null)
              ? Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "$title2",
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff757575),
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      InkWell(
                        onTap: setFocus2,
                        child: Container(
                          height: 52,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextField(
                                onChanged: val2,
                                maxLength: maxLength2,
                                focusNode: focus2,
                                enabled: enable2,
                                style: TextStyle(
                                    color: Color(0xffBDBDBD),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                                decoration: InputDecoration(
                                  counterText: '',
                                  errorText: val2 != null ? msgError2 : '',
                                  contentPadding: EdgeInsets.all(0.0),
                                  hintText: hintText2,
                                  isDense: true,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffBDBDBD)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffBDBDBD)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
        ],
      );
    });
  }
}
