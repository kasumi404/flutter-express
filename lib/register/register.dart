import 'package:flutter/material.dart';
import 'package:zhihu/Login/Login.dart';
import 'package:zhihu/api/ip.dart';
import '../index/index.dart';
import 'dart:convert';
import 'dart:io';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  var leftRightPadding = 30.0;
  var topBottomPadding = 4.0;
  var textTips = new TextStyle(fontSize: 16.0, color: Colors.black);
  var hintTips = new TextStyle(fontSize: 15.0, color: Colors.black26);
  static const LOGO = "images/1.png";

  var _adminNameController = new TextEditingController();
  var _userPassController = new TextEditingController();
  var _userNameController = new TextEditingController();
  var _userRepassController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("注册", style: new TextStyle(color: Colors.white)),
          iconTheme: new IconThemeData(color: Colors.white),
        ),
        body: new Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.fromLTRB(
                  leftRightPadding, 50.0, leftRightPadding, 10.0),
              child: new Image.asset(LOGO),
            ),
            new Padding(
              padding: new EdgeInsets.fromLTRB(
                  leftRightPadding, 30.0, leftRightPadding, topBottomPadding),
              child: new TextField(
                style: hintTips,
                controller: _userNameController,
                decoration: new InputDecoration(hintText: "请输入用户名"),
                obscureText: false,
              ),
            ),

            new Padding(
              padding: new EdgeInsets.fromLTRB(
                  leftRightPadding, 30.0, leftRightPadding, topBottomPadding),
              child: new TextField(
                style: hintTips,
                controller: _adminNameController,
                decoration: new InputDecoration(hintText: "请输入姓名"),
                obscureText: false,
              ),
            ),
            new Padding(
              padding: new EdgeInsets.fromLTRB(
                  leftRightPadding, 30.0, leftRightPadding, topBottomPadding),
              child: new TextField(
                style: hintTips,
                controller: _userPassController,
                decoration: new InputDecoration(hintText: "请输入用户密码"),
                obscureText: true,
              ),
            ),
            new Padding(
              padding: new EdgeInsets.fromLTRB(
                  leftRightPadding, 30.0, leftRightPadding, topBottomPadding),
              child: new TextField(
                style: hintTips,
                controller: _userRepassController,
                decoration: new InputDecoration(hintText: "请再次输入密码"),
                obscureText: true,
              ),
            ),
            new Container(
              width: 360.0,
              margin: new EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
              padding: new EdgeInsets.fromLTRB(leftRightPadding,
                  topBottomPadding, leftRightPadding, topBottomPadding),
              child: new Card(
                color: Colors.green,
                elevation: 6.0,
                child: new FlatButton(
                    onPressed: pushRegister,
                    child: new Padding(
                      padding: new EdgeInsets.all(10.0),
                      child: new Text(
                        '注册',
                        style:
                        new TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    )),
              ),
            )
          ],
        ));
  }

  void register(String username, String password, String rePassword,String adminName) async {
    if(username.trim().length < 3 || password.trim().length< 3 || rePassword.trim().length < 3 || adminName.trim().length < 3 || password.compareTo(rePassword) != 0){
      print("no");
      showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('提示'),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text('注册失败，请检查输入'),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('确定'),
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
    var responseBody;
    var url = "http://"+ip()+":8080/admin/register?username=" + username + "&password=" + password + "&adminName=" + adminName;
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
      //return convertDataToJson;
      if (convertDataToJson["result"] == 200) {
        showDialog<Null>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: new Text('提示'),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    new Text('注册成功'),
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('立即登陆'),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        new MaterialPageRoute(
                            builder: (context) => new Login()),
                            (route) => route == null);
                  },
                ),
              ],
            );
          },
        ).then((val) {
          print(val);
        });

      } else {
        showDialog<Null>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: new Text('提示'),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    new Text('注册失败'+convertDataToJson["message"]),
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('返回'),
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

  void pushRegister() {
    register(_userNameController.text, _userPassController.text,_userRepassController.text,_adminNameController.text);
  }
}
