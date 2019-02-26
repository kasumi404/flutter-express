import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zhihu/api/ip.dart';
import '../global_config.dart';

class AddExpressPage extends StatefulWidget {

  Map<String, dynamic> todos;
  AddExpressPage(this.todos);
  @override
  _AddExpressPageState createState() => new _AddExpressPageState(todos);

}

class _AddExpressPageState extends State<AddExpressPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> todos;
  _AddExpressPageState(this.todos);
  String goolName='';
  String expressTo='';
  String expressTime=new DateTime.now().toString();
  String adminName='';
  String adminCell='';
  String expressPlace='';
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text('我要寄件'),
          ),
          body:new Container(
        margin: EdgeInsets.all(10.0),
      child: Form(
        //绑定状态属性
        key: _formKey,
        child: ListView(
          children: <Widget>[
            _buildNameText(),
            _buildCellText(),
            _buildIDCardText(),
            _buildPlaceText(),
            _buildPlaceToText(),
            _buildGoolText(),
            Container(
              padding: EdgeInsets.all(10.0),
              child:
              RaisedButton(child: Text('提交'), onPressed: _submitValues),
            )
          ],
        ),
      ),
    ),
        ),
        theme: GlobalConfig.themeData
    );
  }

  Widget _buildNameText() {
    return TextFormField(
      controller:new TextEditingController.fromValue(new TextEditingValue(text: todos["adminName"]==null?'':todos["adminName"])),
      decoration: InputDecoration(labelText: '寄件人',hintText: '请输入姓名', ),
      validator: (String value) {
        //删除首尾空格
        if (value.isEmpty || value.trim().length <= 0) {
          return '名称字数不可为空';
        }
      },
    );
  }
  Widget _buildCellText() {
    return TextFormField(
      controller:new TextEditingController.fromValue(new TextEditingValue(text: todos["adminCell"]==null?'':todos["adminCell"])),
      decoration: InputDecoration(labelText: '电话号',hintText: '请输入电话号',),
      validator: (String value) {
        //删除首尾空格^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$
        RegExp exp = new RegExp('^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$');
        if (value.isEmpty || !exp.hasMatch(value)) {
          return '请输入正确电话号';
        }
      },
      onSaved: (String value) {

        adminCell = value;

      },
    );
  }
  Widget _buildIDCardText() {
    return TextFormField(
      decoration: InputDecoration(labelText: '收件人姓名',hintText: '请输入收件人姓名',),
      validator: (String value) {
        //删除首尾空格
        if (value.isEmpty ) {
          return '地址不能为空';
        }
      },
      onSaved: (String value) {

        adminName = value;

      },
    );
  }
  Widget _buildPlaceText() {
    return TextFormField(
      decoration: InputDecoration(labelText: '收件人电话号',hintText: '请输入收件人电话号',),
      validator: (String value) {
        //删除首尾空格^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$
        RegExp exp = new RegExp('^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$');
        if (value.isEmpty || !exp.hasMatch(value)) {
          return '请输入正确电话号';
        }
      },
      onSaved: (String value) {

        adminCell = value;

      },
    );
  }
  Widget _buildPlaceToText() {
    return TextFormField(
      decoration: InputDecoration(labelText: '收件人地址',hintText: '请输入收件人地址', ),
      validator: (String value) {
        //删除首尾空格
        if (value.isEmpty || value.trim().length <= 0) {
          return '收件人地址字数不可为空';
        }
      },
      onSaved: (String value) {
        expressTo = value;

      },
    );
  }
  Widget _buildGoolText() {
    return TextFormField(
      decoration: InputDecoration(labelText: '物品',hintText: '请输入物品', ),
      validator: (String value) {
        //删除首尾空格
        if (value.isEmpty || value.trim().length <= 0) {
          return '物品字数不可为空';
        }
      },
      onSaved: (String value) {
        goolName = value;

      },
    );
  }
  void add(Map todos)async{
    var responseBody;
    print(adminName);
    var url = "http://"+ip()+":8080/express/insertExpress?"+"goolName="
        +goolName+"&expressFrom="+(todos["adminPlace"]==null?'':todos["adminPlace"])+"&expressTo="+expressTo
        + "&expressTime="+expressTime+"&expressFromId="+todos['adminId'].toString()+"&adminName="
        +adminName.toString()+"&adminCell="+adminCell+"&expressPlace="+(todos["adminPlace"]==null?'':todos["adminPlace"]);
    url.substring(0,url.length-1);
    print(url);
    var httpClient = new HttpClient();
    var request = await httpClient.postUrl(Uri.parse(url));

    var response = await request.close();
    //判断是否请求成功
    if (response.statusCode == 200) {
      //拿到请求的数据
      responseBody = await response.transform(utf8.decoder).join();
      //解析json，拿到对应的jsonArray数据
      var convertDataToJson = jsonDecode(responseBody);
      //返回数据
      print(convertDataToJson);
      if (convertDataToJson["result"] == 200) {
        showDialog<Null>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new AlertDialog(
              backgroundColor: GlobalConfig.cardBackgroundColor,
              title: new Text('提示',style: new TextStyle(color: GlobalConfig.fontColor, fontSize: 14.0)),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    new Text('申请成功！',style: new TextStyle(color: GlobalConfig.fontColor, fontSize: 14.0)),
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('确定',style: new TextStyle(color: GlobalConfig.fontColor, fontSize: 14.0)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ).then((val) {
          print(val);
        });
      }else{
        showDialog<Null>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new AlertDialog(
              backgroundColor: GlobalConfig.cardBackgroundColor,
              title: new Text('提示',style: new TextStyle(color: GlobalConfig.fontColor, fontSize: 14.0)),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    new Text('申请失败'+convertDataToJson["message"],style: new TextStyle(color: GlobalConfig.fontColor, fontSize: 14.0)),
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('返回',style: new TextStyle(color: GlobalConfig.fontColor, fontSize: 14.0)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ).then((val) {
          print(val);
        });
        print(convertDataToJson["message"]);
      }
    } else {
      print("error");
    }
  }
  void _submitValues(){
    _formKey.currentState.save();
    _formKey.currentState.validate();
    add(todos);
  }
}