import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:zhihu/api/ip.dart';
import 'package:zhihu/global_config.dart';

class EditPage extends StatefulWidget {

  Map<String, dynamic> todos;
  EditPage(this.todos);

  @override
  _EditPageState createState() => new _EditPageState(todos);

}

class _EditPageState extends State<EditPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> todos;
  _EditPageState(this.todos);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.grey,
            title:  new Text('个人信息'),
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
      controller:new TextEditingController.fromValue(new TextEditingValue(text: todos["adminName"])),
      decoration: InputDecoration(labelText: '姓名',hintText: '请输入姓名', ),
      validator: (String value) {
        //删除首尾空格
        if (value.isEmpty || value.trim().length <= 0) {
          return '名称字数不可为空';
        }
      },
      onSaved: (String value) {
        todos["adminName"] = value;

      },
    );
  }
  Widget _buildCellText() {
    return TextFormField(
      controller:new TextEditingController.fromValue(new TextEditingValue(text: todos["adminCell"]==null?"":todos["adminCell"])),
      decoration: InputDecoration(labelText: '电话号',hintText: '请输入电话号',),
      validator: (String value) {
        //删除首尾空格^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$
        RegExp exp = new RegExp('^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$');
        if (value.isEmpty || !exp.hasMatch(value)) {
          return '请输入正确电话号';
        }
      },
      onSaved: (String value) {

        todos["adminCell"] = value;

      },
    );
  }
  Widget _buildIDCardText() {
    return TextFormField(
      controller:new TextEditingController.fromValue(new TextEditingValue(text: todos["adminIDCard"]==null?"":todos["adminIDCard"])),
      decoration: InputDecoration(labelText: '身份证',hintText: '请输入身份证',),
      validator: (String value) {
        //删除首尾空格
        RegExp exp = new RegExp('^\\d{15}|\\d{18}|\\d{17}\\d|X|x\$');
        if (value.isEmpty || !exp.hasMatch(value)) {
          return '请输入正确身份证';
        }
      },
      onSaved: (String value) {

        todos["adminIDCard"] = value;

      },
    );
  }
  Widget _buildPlaceText() {
    return TextFormField(
      controller:new TextEditingController.fromValue(new TextEditingValue(text: todos["adminPlace"]==null?"":todos["adminPlace"])),
      decoration: InputDecoration(labelText: '地址',hintText: '请输入地址',),
      validator: (String value) {
        //删除首尾空格
        if (value.isEmpty ) {
          return '地址不能为空';
        }
      },
      onSaved: (String value) {

        todos["adminPlace"] = value;

      },
    );
  }
  void edit(Map todos)async{
    var responseBody;
    var url = "http://"+ip()+":8080/admin/edit?";
    todos.forEach((k, v)=> url=(url+k+"="+v.toString()+"&"));
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
                    new Text('编程个人信息成功！',style: new TextStyle(color: GlobalConfig.fontColor, fontSize: 14.0)),
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
                    new Text('编辑失败'+convertDataToJson["message"],style: new TextStyle(color: GlobalConfig.fontColor, fontSize: 14.0)),
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
    edit(todos);
  }
}