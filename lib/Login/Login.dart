import 'package:flutter/material.dart';
import 'package:zhihu/global_config.dart';
import '../index/index.dart';
import '../register/register.dart';
import 'dart:convert';
import 'dart:io';
import '../api/ip.dart';
class Login extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new _LoginState();
  }
}

class _LoginState extends State<Login> {
  var leftRightPadding = 30.0;
  var topBottomPadding = 4.0;
  var textTips = new TextStyle(fontSize: 16.0, color: Colors.black);
  var hintTips = new TextStyle(fontSize: 15.0, color: Colors.black26);
  static const LOGO = "images/1.png";

  var _userPassController = new TextEditingController();
  var _userNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("登录", style: new TextStyle(color: Colors.white)),
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
                  leftRightPadding, 50.0, leftRightPadding, topBottomPadding),
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
                controller: _userPassController,
                decoration: new InputDecoration(hintText: "请输入用户密码"),
                obscureText: true,
              ),
            ),
            new Container(
              width: 360.0,
              margin: new EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
              padding: new EdgeInsets.fromLTRB(leftRightPadding,
                  topBottomPadding, leftRightPadding, topBottomPadding),
              child: new Card(
                color: Colors.blueAccent,
                elevation: 6.0,
                child: new FlatButton(
                    onPressed: pushLogin,
                    child: new Padding(
                      padding: new EdgeInsets.all(10.0),
                      child: new Text(
                        '马上登录',
                        style:
                        new TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    )),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.fromLTRB(
                  leftRightPadding, 30.0, leftRightPadding, topBottomPadding),
              child: new Card(
                color: Colors.green,
                elevation: 6.0,
                child: new FlatButton(
                    onPressed: toRegister,
                    child: new Padding(
                      padding: new EdgeInsets.all(10.0),
                      child: new Text(
                        '马上注册',
                        style: new TextStyle(color: Colors.blue, fontSize: 16.0),
                      ),
                    )),
              ),
            )
          ],
        ));
  }
  void login(String username,String password) async {
    var responseBody;
    var url = "http://"+ip()+":8080/admin/login?username="+username+"&password="+password;
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
//      return convertDataToJson;
      if (convertDataToJson["adminInfo"]!=null&&convertDataToJson["result"]==200){
        if (convertDataToJson["adminInfo"]["adminRoot"]=="1"){
          Navigator.of(context).pushAndRemoveUntil(
              new MaterialPageRoute(builder: (context) => new Index(convertDataToJson)
              ), (route) => route == null);
        }else{
          print(convertDataToJson["adminInfo"]["adminRoot"]);
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
                    new Text('登陆失败'+convertDataToJson["message"],style: new TextStyle(color: GlobalConfig.fontColor, fontSize: 14.0)),
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
  }

  void toRegister(){
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (context) => new Register()
        ));
  }

  void pushLogin(){
    login(_userNameController.text,_userPassController.text);
  }
}