import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:zhihu/api/ip.dart';

class BanPage extends StatefulWidget {


  @override
  _BanPageState createState() => new _BanPageState();

}

class _BanPageState extends State<BanPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            title:  new Text('禁寄物品'),
          ),
          body:new Container(
          margin: EdgeInsets.all(10.0),
          child: Form(
            //绑定状态属性
            key: _formKey,
            child: ListView(
              children: <Widget>[
                new Text(
                  '一、禁寄物品是指国家法律、法规禁止寄递的物品，主要包括：',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),
                  maxLines: 2,
                ),
                new Text(
                  '（一）各类武器、弹药。如枪支、子弹、炮弹、手榴弹、地雷、炸弹等。',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),
                  maxLines: 2,
                ),
                new Text(
                  '（二）各类易爆炸性物品。如雷管、炸药、火药、鞭炮等。',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),
                  maxLines: 2,
                ),
                new Text(
                  '（三）各类易燃烧性物品，包括液体、气体和固体。如汽油、煤油、桐油、酒精、生漆、柴油、气雾剂、气体打火机、瓦斯气瓶、磷、硫磺、火柴等。',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),
                  maxLines: 2,
                ),
                new Text(
                  '（四）各类易腐蚀性物品。如火硫酸、盐酸、硝酸、有机溶剂、农药、双氧水、危险化学品等。',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),
                  maxLines: 2,
                ),
                new Text(
                  '（五）各类放射性元素及容器。如铀、钴、镭、钚等。',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),
                  maxLines: 2,
                ),
                new Text(
                  '（六）各类烈性毒药。如铊、氰化物、砒霜等。',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),
                  maxLines: 2,
                ),
                new Text(
                  '（七）各类麻醉药物。如鸦片（包括罂粟壳、花、苞、叶）、吗啡、可卡因、海洛因、大麻、冰毒、麻黄素及其它制品等。',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),
                  maxLines: 2,
                ),
                new Text(
                  '（八）各类生化制品和传染性物品。如炭疽、危险性病菌、医药用废弃物等。',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),
                  maxLines: 2,
                ),
                new Text(
                  '（九）各种危害国家安全和社会政治稳定以及淫秽的出版物、宣传品、印刷品等。',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),
                  maxLines: 2,
                ),
                new Text(
                  '（十）各种妨害公共卫生的物品。如尸骨、动物器官、肢体、未经硝制的兽皮、未经药制的兽骨等。',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),
                  maxLines: 2,
                ),
                new Text(
                  '（十一）国家法律、法规、行政规章明令禁止流通、寄递或进出境的物品，如国家秘密文件和资料、国家货币及伪造的货币和有价证券、仿真武器、管制刀具、珍贵文物、濒危野生动物及其制品等。',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),
                  maxLines: 2,
                ),
                new Text(
                  '（十二）包装不妥，可能危害人身安全、污染或者损毁其他寄递件、设备的物品等。',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),
                  maxLines: 2,
                ),
                new Text(
                  '（十三）各寄达国（地区）禁止寄递进口的物品等。',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),
                  maxLines: 2,
                ),
                _buildNameText()
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
      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),
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