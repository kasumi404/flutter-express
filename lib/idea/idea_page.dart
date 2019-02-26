import 'package:flutter/material.dart';
import 'package:zhihu/api/ip.dart';
import 'package:zhihu/idea/components/expressInfo.dart';
import '../global_config.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

class SendExpressPage extends StatefulWidget {

  final Map<String, dynamic> todos;
  SendExpressPage(this.todos);

  @override
  _SendExpressPageState createState() => new _SendExpressPageState(todos);

}

class NewsTab {
  String text;
  NewsList newsList;
  NewsTab(this.text,this.newsList);
}

class _SendExpressPageState extends State<SendExpressPage> with SingleTickerProviderStateMixin{

  final Map<String, dynamic> todos;
  _SendExpressPageState(this.todos);

  TabController _tabController;
  @override

   List<NewsTab> myTabs ;

  void initState() {
    super.initState();
    myTabs = <NewsTab>[
    new NewsTab('全部',new NewsList(newsType: '全部',todos: todos)),    //拼音就是参数值
    new NewsTab('已签收',new NewsList(newsType: '已签收',todos: todos)),    //拼音就是参数值
    new NewsTab('已发货',new NewsList(newsType: '已发货',todos: todos)),    //拼音就是参数值
    new NewsTab('未发货',new NewsList(newsType: '未发货',todos: todos)),    //拼音就是参数值
    new NewsTab('申请中',new NewsList(newsType: '申请中',todos: todos)),    //拼音就是参数值
    ];
    _tabController = new TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            title: new TabBar(
              controller: _tabController,
              tabs: myTabs.map((NewsTab item){      //NewsTab可以不用声明
                return new Tab(text: item.text??'错误');
              }).toList(),
              indicatorColor: Colors.white,
              isScrollable: true,   //水平滚动的开关，开启后Tab标签可自适应宽度并可横向拉动，关闭后每个Tab自动压缩为总长符合屏幕宽度的等宽，默认关闭
            ),
          ),
          body: new TabBarView(
              controller: _tabController,
              children: myTabs.map((item) {
              return item.newsList; //使用参数值
            }).toList(),
          ),
        ),
        theme: GlobalConfig.themeData
    );
  }

}
//新闻列表
class NewsList extends StatefulWidget{
  final String newsType;    //新闻类型
  final Map<String, dynamic> todos;
  @override
  NewsList({Key key, this.newsType,this.todos} ):super(key:key);

  _NewsListState createState() => new _NewsListState(todos);


}
class _NewsListState extends State<NewsList> {

  final Map<String, dynamic> todos;
  _NewsListState(this.todos);
  final String _url = 'http://127.0.0.1:8080/express/getExpressByAdminId?';
//  final String _url = 'http://v.juhe.cn/toutiao/index?';

  List data;


  //HTTP请求的函数返回值为异步控件Future
  Future<String> get(String category) async {
    var httpClient = new HttpClient();

    var request = await httpClient.getUrl(Uri.parse('http://'+ip()+':8080/express/getExpressByAdminId?adminId='+todos["adminId"].toString()+'&expressType='+category+'&flag=1'));

//    var request = await httpClient.getUrl(Uri.parse('${_url}type=$category&key=3a86f36bd3ecac8a51135ded5eebe862'));
    var response = await request.close();


    return await response.transform(utf8.decoder).join();
  }

  Future<Null> loadData() async {
    await get(widget.newsType); //注意await关键字

    if (!mounted) return; //异步处理，防止报错

    setState(() {}); //什么都不做，只为触发RefreshIndicator的子控件刷新

  }


  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(

      child: new FutureBuilder( //用于懒加载的FutureBuilder对象

        future: get(widget.newsType), //HTTP请求获取数据，将被AsyncSnapshot对象监视

        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none: //get未执行时

            case ConnectionState.waiting: //get正在执行时

              return new Center(

                child: new Card(

                  child: new Text('loading...'), //在页面中央显示正在加载

                ),

              );

            default:
              if (snapshot.hasError) //get执行完成但出现异常

                return new Text('Error: ${snapshot.error}');

              else //get正常执行完成

                // 创建列表，列表数据来源于snapshot的返回值，而snapshot就是get(widget.newsType)执行完毕时的快照

                // get(widget.newsType)执行完毕时的快照即函数最后的返回值。

                return createListView(context, snapshot);
          }
        },

      ),

      onRefresh: loadData,

    );
  }


  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    // print(snapshot.data);

    List values;

    values = jsonDecode(snapshot.data)['express'] != null ? jsonDecode(
        snapshot.data)['express'] : [''];

    switch (values.length) {
      case 0: //没有获取到数据，则返回请求失败的原因

        return new Center(

          child: new Card(

            child: new Text("无数据"),

          ),

        );

      default:
        return new ListView.builder(

            physics: const AlwaysScrollableScrollPhysics(),

            padding: const EdgeInsets.all(16.0),

            // itemCount: data == null ? 0 : data.length,

            itemCount: values == null ? 0 : values.length,

            itemBuilder: (context, i) {
              // return _newsRow(data[i]);//把数据项塞入ListView中

              return _newsRow(values[i]);
            }

        );
    }
  }


  //新闻列表单个item

  Widget _newsRow(newsInfo) {
    return new Card(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new ListTile(
              title: new Text(newsInfo["expressCode"], textScaleFactor: 1.5,),),
            margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),),

          new Container(
              padding: const EdgeInsets.fromLTRB(25.0, 10.0, 0.0, 10.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Expanded(
                    child: new Text(newsInfo["expressFrom"]+"-"+newsInfo["expressFromInfo"]["adminName"]),
                  ),
                  new Expanded(
                    child: new Text(newsInfo["expressTo"]+"-"+newsInfo["expressToInfo"]["adminName"]),
                  ),
                ],
              )),
          new Container(
              padding: const EdgeInsets.fromLTRB(25.0, 10.0, 0.0, 10.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Expanded(
                    child: new Text(newsInfo["expressType"]),
                  ),
                  new Expanded(
                    child: new Text(newsInfo["expressTime"]),
                  ),
                ],
              )),
          new FlatButton(
              onPressed: (){openCard(newsInfo['expressCode']);},
              color: Colors.black12,
              child: new Padding(
                padding: new EdgeInsets.all(10.0),
                child: new Text(
                  '详情',
                  style:
                  new TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              )),
        ],
      ),
    );
  }

  void openCard(String code) async{
    var responseBody;
    var url = "http://"+ip()+":8080/express/getExpressByExpressCode?expressCode="+code;
    print(url);
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));

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
      if (convertDataToJson["express"]!=null&&convertDataToJson["result"]==200){
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new ExpressInfoPage(convertDataToJson["express"])),
          );
      }else{
        print(convertDataToJson["message"]);
      }
    } else {
      print("error");
    }
  }
}
