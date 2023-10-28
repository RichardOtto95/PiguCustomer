import 'package:flutter/material.dart';

class PhoneChatButton extends StatelessWidget {
  PhoneChatButton({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PhoneButton(),
        SizedBox(width: 25,),
        ChatButton(),
      ],
    );
  }
}

class ChatButton extends StatelessWidget {
  const ChatButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 24,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(21.0),
          topRight: Radius.circular(21.0),
          bottomRight: Radius.circular(58.0),
          bottomLeft: Radius.circular(21.0),
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
      child: Container(
        child: Image.asset(
          'assets/icon/chat.png',
          height: 20,
          width: 20,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
class PhoneButton extends StatelessWidget {
  const PhoneButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 24,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(21.0),
          topRight: Radius.circular(21.0),
          bottomRight: Radius.circular(21.0),
          bottomLeft: Radius.circular(58.0),
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
      child: Container(
        child: Image.asset(
          'assets/icon/phone.png',
          height: 20,
          width: 20,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
