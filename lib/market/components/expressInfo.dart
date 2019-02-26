import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:zhihu/api/ip.dart';
import 'package:zhihu/global_config.dart';

class ExpressInfoPage extends StatefulWidget {

  final Map<String, dynamic> todos;
  ExpressInfoPage(this.todos);

  @override
  _ExpressInfoPageState createState() => new _ExpressInfoPageState(todos);

}

class _ExpressInfoPageState extends State<ExpressInfoPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> todos;
  _ExpressInfoPageState(this.todos);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.grey,
          title:  new Text('寄件详情'),
        ),
        body:new Container(
          margin: EdgeInsets.all(10.0),
          child: Form(
            //绑定状态属性
            key: _formKey,
            child: ListView(
              children: <Widget>[
                new Text(
                  '快递号:'+todos['expressCode'],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35.0),
                  maxLines: 2,
                ),
                new Text(
                  '   寄件时间:'+todos['expressTime'],
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),
                  maxLines: 2,
                ),
                new Text(
                  '   当前位置:'+todos['expressPlace'],
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),
                  maxLines: 2,
                ),
                new Text(
                  '寄件人:'+todos['expressFromInfo']['adminName'],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35.0),
                  maxLines: 2,
                ),
                new Text(
                  '   电话号:'+todos['expressFromInfo']['adminCell'],
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),
                  maxLines: 2,
                ),
                new Text(
                  '   身份证:'+todos['expressFromInfo']['adminIDCard'],
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),
                  maxLines: 2,
                ),
                new Text(
                  '   地址:'+todos['expressFromInfo']['adminPlace'],
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),
                  maxLines: 2,
                ),
                new Text(
                  '收件人：'+todos['expressToInfo']['adminName'],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35.0),
                  maxLines: 2,
                ),
                new Text(
                  '   电话号:'+todos['expressFromInfo']['adminCell'],
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),
                  maxLines: 2,
                ),
                new Text(
                  '   身份证:'+todos['expressFromInfo']['adminIDCard'],
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),
                  maxLines: 2,
                ),
                new Text(
                  '   地址:'+todos['expressFromInfo']['adminPlace'],
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),
                  maxLines: 2,
                ),
                new Text(
                  '物品:'+todos['gool']['goolName'],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35.0),
                  maxLines: 2,
                ),
                new Text(
                  todos['gool']['goolType']==null?'   类型:未收录':'   类型:'+todos['gool']['goolType'],
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),
                  maxLines: 2,
                ),
                new Text(
                  todos['gool']['goolWeight']==null?'   重量:未收录':'   重量:'+todos['gool']['goolWeight'],
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
        theme: GlobalConfig.themeData
    );
  }
  Widget _buildNameText() {
    return new Text(
      '（十四）其他禁止寄递的物品。',
      textAlign: TextAlign.left,
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
// ignore: expected_executable
}