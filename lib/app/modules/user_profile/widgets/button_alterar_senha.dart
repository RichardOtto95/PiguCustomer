import 'package:flutter/material.dart';

class ButtonAlterarSenha extends StatelessWidget {
  var divisorColor = Color.fromRGBO(189, 174, 167, 1);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.only(left: 0),
          onPressed: () {},
          child: Text("Alterar Senha",
              style: TextStyle(
                  fontSize: 18,
                  color: divisorColor,
                  fontWeight: FontWeight.w400)),
        )
      ],
    );
  }
}
