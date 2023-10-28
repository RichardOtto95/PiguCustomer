import 'package:flutter/material.dart';

class FavButton extends StatefulWidget {
  @override
  _FavButtonState createState() => _FavButtonState();
}

class _FavButtonState extends State<FavButton> {
  var stateButton = false;
  var accentColor = Color.fromRGBO(114, 74, 134, 1);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          stateButton = !stateButton;
        });
      },
      child: stateButton
          ? Icon(
              Icons.favorite_border,
              color: accentColor,
              size: 32,
            )
          : Icon(Icons.favorite, color: accentColor, size: 32),
    );
  }
}
