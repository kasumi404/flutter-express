import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:zhihu/api/ip.dart';

class ComplaintPage extends StatefulWidget {

  Map<String, dynamic> todos;
  ComplaintPage(this.todos);

  @override
  _ComplaintPageState createState() => new _ComplaintPageState(todos);

}

class _ComplaintPageState extends State<ComplaintPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> todos;

  String complaintText;
  _ComplaintPageState(this.todos);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            title:  new Text('我要申述'),
          ),
          body:new Container(
          margin: EdgeInsets.all(10.0),
          child: Form(
            //绑定状态属性
            key: _formKey,
            child: ListView(
              children: <Widget>[
                _buildCellText(),
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
//      decoration: InputDecoration(labelText: '申述内容',hintText: '在这里填写您要提交的申述',),
      validator: (String value) {
        //删除首尾空格^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$
      },
      maxLines: 6,
      onSaved: (String value) {

        complaintText = value;

      },
    );
  }
  Widget _buildIDCardText() {
    return TextFormField(
      controller:new TextEditingController.fromValue(new TextEditingValue(text: todos["adminIDCard"])),
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
      controller:new TextEditingController.fromValue(new TextEditingValue(text: todos["adminPlace"])),
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
  void complaint(Map todos)async{
    var responseBody;
    var url = "http://"+ip()+":8080/complaint/insertComplaint?"+"adminId="+todos['adminId'].toString()+"&context="+complaintText;
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
    } else {
      print("error");
    }
  }
  void _submitValues(){
    _formKey.currentState.save();
    _formKey.currentState.validate();
    complaint(todos);
  }
}