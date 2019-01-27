import 'package:flutter/material.dart';
import 'Login/Login.dart';

void main() => runApp(new ZhiHu());

class ZhiHu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "快递",
      home: new Login(),
    );
  }

}
