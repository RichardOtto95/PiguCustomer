import 'package:flutter/material.dart';

class EnterCodeWidget extends StatelessWidget {
  final Function val1;
  final int maxLength1;
  final FocusNode focus1;
  final Function setFocus1;
  final String msgError1;

  final Function val2;
  final int maxLength2;
  final FocusNode focus2;
  final Function setFocus2;
  final String msgError2;

  final Function val3;
  final int maxLength3;
  final FocusNode focus3;
  final Function setFocus3;
  final String msgError3;

  final Function val4;
  final int maxLength4;
  final FocusNode focus4;
  final Function setFocus4;
  final String msgError4;

  final Function val5;
  final int maxLength5;
  final FocusNode focus5;
  final Function setFocus5;
  final String msgError5;

  final Function val6;
  final int maxLength6;
  final FocusNode focus6;
  final Function setFocus6;
  final String msgError6;
  const EnterCodeWidget({
    this.val1,
    this.focus1,
    this.maxLength1,
    this.msgError1,
    this.setFocus1,
    this.val2,
    this.focus2,
    this.maxLength2,
    this.msgError2,
    this.setFocus2,
    this.val3,
    this.focus3,
    this.maxLength3,
    this.msgError3,
    this.setFocus3,
    this.val4,
    this.focus4,
    this.maxLength4,
    this.msgError4,
    this.setFocus4,
    this.val5,
    this.focus5,
    this.maxLength5,
    this.msgError5,
    this.setFocus5,
    this.val6,
    this.focus6,
    this.maxLength6,
    this.msgError6,
    this.setFocus6,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
     
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: setFocus1,
              child: Container(
                // height: 52,
                width: 20,
                // padding: EdgeInsets.symmetric(horizontal: 16),
                // alignment: Alignment.bottomCenter,
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   borderRadius: BorderRadius.circular(12),
                // ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextField(
                      onChanged: val1,
                      focusNode: focus1,
                      maxLength: maxLength1,
                      style: TextStyle(
                          color: Color(0xffBDBDBD),
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: EdgeInsets.all(0.0),
                        isDense: true,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffBDBDBD)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffBDBDBD)),
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
            SizedBox(width: 10,),
            InkWell(
              onTap: setFocus2,
              child: Container(
              
                width: 30,
              
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextField(
                      onChanged: val2,
                      focusNode: focus2,
                      maxLength: maxLength1,
                      style: TextStyle(
                          color: Color(0xffBDBDBD),
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: EdgeInsets.all(0.0),
                        isDense: true,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffBDBDBD)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffBDBDBD)),
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
            SizedBox(width: 10,),
            InkWell(
              onTap: setFocus3,
              child: Container(
                width: 30,
          
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextField(
                      onChanged: val3,
                      focusNode: focus3,
                      maxLength: maxLength1,
                      style: TextStyle(
                          color: Color(0xffBDBDBD),
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: EdgeInsets.all(0.0),
                        isDense: true,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffBDBDBD)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffBDBDBD)),
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
            SizedBox(width: 10,),
            InkWell(
              onTap: setFocus4,
              child: Container(
                width: 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextField(
                      onChanged: val4,
                      focusNode: focus4,
                      maxLength: maxLength1,
                      style: TextStyle(
                          color: Color(0xffBDBDBD),
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: EdgeInsets.all(0.0),
                        isDense: true,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffBDBDBD)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffBDBDBD)),
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
            SizedBox(width: 10,),
            InkWell(
              onTap: setFocus5,
              child: Container(
                width: 30,
              
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextField(
                      onChanged: val5,
                      focusNode: focus5,
                      maxLength: maxLength1,
                      style: TextStyle(
                          color: Color(0xffBDBDBD),
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: EdgeInsets.all(0.0),
                        isDense: true,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffBDBDBD)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffBDBDBD)),
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
            SizedBox(width: 10,),
            InkWell(
              onTap: setFocus6,
              child: Container(
                width: 30,
               
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextField(
                      onChanged: val6,
                      focusNode: focus6,
                      maxLength: maxLength1,
                      style: TextStyle(
                          color: Color(0xffBDBDBD),
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: EdgeInsets.all(0.0),
                        isDense: true,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffBDBDBD)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffBDBDBD)),
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
        )
      ],
    );
  }
}

// class InputCodeWidget extends StatelessWidget {
//   final Function val1;
//   final int maxLength1;
//   final FocusNode focus1;
//   final Function setFocus1;
//   final String msgError1;

//   const InputCodeWidget({
//     this.val1,
//     this.focus1,
//     this.maxLength1,
//     this.msgError1,
//     this.setFocus1,
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: setFocus1,
//       child: Container(
//         height: 52,
//         width: 55,
//         padding: EdgeInsets.symmetric(horizontal: 16),
//         alignment: Alignment.bottomCenter,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: <Widget>[
//             TextField(
//               onChanged: val1,
//               focusNode: focus1,
//               maxLength: maxLength1,
//               style: TextStyle(
//                   color: Color(0xffBDBDBD),
//                   fontSize: 16,
//                   fontWeight: FontWeight.w300),
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.all(0.0),
//                 isDense: true,
//                 enabledBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xffBDBDBD)),
//                 ),
//                 focusedBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Color(0xffBDBDBD)),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 8,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
