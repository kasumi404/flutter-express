import 'package:flutter/material.dart';
import 'package:zhihu/Login/Login.dart';
import 'dart:convert';
import 'dart:io';

import 'package:zhihu/api/ip.dart';
import 'package:zhihu/global_config.dart';

class ChangePasswordPage extends StatefulWidget {

  Map<String, dynamic> todos;
  ChangePasswordPage(this.todos);

  @override
  _ChangePasswordPageState createState() => new _ChangePasswordPageState(todos);

}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> todos;

  var _passwordController = new TextEditingController();
  var _newpasswordController = new TextEditingController();
  var _confirmpasswordController = new TextEditingController();
  _ChangePasswordPageState(this.todos);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            backgroundColor: Colors.grey,
            title:  new Text('修改密码'),
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
      controller:new TextEditingController.fromValue(new TextEditingValue(text: todos["userName"])),
      decoration: InputDecoration(labelText: '账号',hintText: '请输入账号', ),
      validator: (String value) {
        //删除首尾空格
        if (value.isEmpty || value.trim().length <= 0) {
          return '账号字数不可为空';
        }
      },
      onSaved: (String value) {
        todos["userName"] = value;

      },
    );
  }
  Widget _buildCellText() {
    return TextFormField(
      decoration: InputDecoration(labelText: '原密码',hintText: '请输入原密码',),
      obscureText: true,
      controller: _passwordController,
      validator: (String value) {
        if (value.isEmpty || value.trim().length <= 2) {
          return '名称字数不可为空';
        }
      },
    );
  }
  Widget _buildIDCardText() {
    return TextFormField(
      decoration: InputDecoration(labelText: '新密码',hintText: '请输入新密码',),
      obscureText: true,
      controller: _newpasswordController,
      validator: (String value) {
        if (value.isEmpty || value.trim().length <= 2) {
          return '新密码字数不可为空';
        }
      },
    );
  }
  Widget _buildPlaceText() {
    return TextFormField(
      decoration: InputDecoration(labelText: '确认新密码',hintText: '请再次输入新密码',),
      obscureText: true,
      controller: _confirmpasswordController,
      validator: (String value) {
        if (value.isEmpty || value.trim().length <= 2) {
          return '确认新密码字数不可为空';
        }
      },
    );
  }
  void edit(String username)async{
    if(_passwordController.text.compareTo(todos['password'] )== 0){
      if(_newpasswordController.text.compareTo(_confirmpasswordController.text) == 0){
        var responseBody;
        print(username);
        var url = "http://"+ip()+":8080/admin/updateAdmin?"+"id="+todos['adminId'].toString()+"&username="+username+"&password="+_newpasswordController.text;
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
                        new Text('修改成功，请重新登陆',style: new TextStyle(color: GlobalConfig.fontColor, fontSize: 14.0)),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text('确定',style: new TextStyle(color: GlobalConfig.fontColor, fontSize: 14.0)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(builder: (context) => new Login()),
                        );
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
                        new Text('修改失败'+convertDataToJson["message"],style: new TextStyle(color: GlobalConfig.fontColor, fontSize: 14.0)),
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
          }
        } else {
          print("error");
        }
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
                    new Text('新密码不正确',style: new TextStyle(color: GlobalConfig.fontColor, fontSize: 14.0)),
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
      }
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
                  new Text('原密码错误',style: new TextStyle(color: GlobalConfig.fontColor, fontSize: 14.0)),
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
    }

  }
  void _submitValues(){
    edit(todos["userName"]);
  }
}