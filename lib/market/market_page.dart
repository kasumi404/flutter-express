import 'package:flutter/material.dart';
import '../global_config.dart';

class GetExpressPage extends StatefulWidget {

  final Map<String, dynamic> todos;
  GetExpressPage(this.todos);

  @override
  _GetExpressPageState createState() => new _GetExpressPageState(todos);

}

class _GetExpressPageState extends State<GetExpressPage> {

  final Map<String, dynamic> todos;
  _GetExpressPageState(this.todos);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text('收快递'),
          ),
          body: new Center(
              child: null
          ),
        ),
        theme: GlobalConfig.themeData
    );
  }

}