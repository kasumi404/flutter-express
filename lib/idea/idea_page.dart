import 'package:flutter/material.dart';
import '../global_config.dart';

class SendExpressPage extends StatefulWidget {

  final Map<String, dynamic> todos;
  SendExpressPage(this.todos);

  @override
  _SendExpressPageState createState() => new _SendExpressPageState(todos);

}

class _SendExpressPageState extends State<SendExpressPage> {

  final Map<String, dynamic> todos;
  _SendExpressPageState(this.todos);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text('寄快递'),
            actions: <Widget>[
              new Container(

              )
            ],
          ),
          body: new Center(
              child: null
          ),
        ),
        theme: GlobalConfig.themeData
    );
  }

}