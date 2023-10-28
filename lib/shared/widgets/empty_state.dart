import 'package:flutter/material.dart';
import 'package:pigu/shared/color_theme.dart';

class EmptyStateList extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const EmptyStateList(
      {Key key, this.image, this.title, this.description, int height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double wXD(double size, BuildContext context) {
      double finalSize = MediaQuery.of(context).size.width * size / 375;
      return finalSize;
    }

    //print'>>>>EmptyStateList > build');
    double maxHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: wXD(20, context)),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width,
          ),
          Image.asset(
            image,
            fit: BoxFit.fill,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: wXD(7, context)),
            child: Text(
              title,
              style: TextStyle(
                  color: ColorTheme.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: wXD(16, context)),
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: wXD(20, context)),
              alignment: Alignment.center,
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ColorTheme.textGrey, fontSize: wXD(14, context)),
              )),
        ],
      ),
    );
  }
}
