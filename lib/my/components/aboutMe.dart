import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:zhihu/api/ip.dart';

class AboutMePage extends StatefulWidget {


  @override
  _AboutMePageState createState() => new _AboutMePageState();

}

class _AboutMePageState extends State<AboutMePage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            title:  new Text('关于我们'),
          ),
          body:new Container(
          margin: EdgeInsets.all(10.0),
          child: Form(
            //绑定状态属性
            key: _formKey,
            child: ListView(
              children: <Widget>[
                new Text(
                  '姓名：梁子康',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),
                  maxLines: 2,
                ),
                new Text(
                  '学号：123',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),
                  maxLines: 2,
                ),
                new Text(
                  '开发题目：快递',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildNameText() {
    return new Text(
      '（十四）其他禁止寄递的物品。',
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),
      maxLines: 2,
    );
  }
  }
  void edit(Map todos)async{
    var responseBody;
    var url = "http://"+ip()+":8080/admin/edit?";
    todos.forEach((k, v)=> url=(url+k+"="+v.toString()+"&"));
    url.substring(0,url.length-1);
    print(todos);
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
    } else {
      print("error");
    }
  }
// ignore: expected_executable
}