import 'package:pigu/shared/color_theme.dart';
import 'package:flutter/material.dart';

class ItemOrderCommission extends StatelessWidget {
  final bool enableCheck;
  const ItemOrderCommission({
    Key key,
    this.enableCheck = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 3, color: ColorTheme.textGrey),
        ),
      ),
      child: Row(
        children: [
          StatefulBuilder(
            builder: (context, setState) {
              bool value = false;
              return Checkbox(
                  value: value,
                  checkColor: Colors.white, // color of tick Mark
                  activeColor:
                      enableCheck ? ColorTheme.primaryColor : Colors.grey,
                  onChanged: (bool value) {
                    setState(() {
                      value != value;
                    });
                  });
            },
          ),
          SizedBox(
            width: 0,
          ),
          Text(
            'Adicionar Comissão',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: ColorTheme.textGrey,
              fontWeight: FontWeight.w300,
            ),
          ),
          Spacer(),
          Icon(
            Icons.add,
            color: ColorTheme.textGrey,
            size: 18,
          ),
          SizedBox(
            width: 14,
          ),
          Text(
            '10',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: ColorTheme.textGrey,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '%',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: ColorTheme.textGrey,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(
            width: 24,
          ),
        ],
      ),
    );
  }
}
