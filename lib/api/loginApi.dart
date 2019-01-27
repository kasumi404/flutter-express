import 'dart:convert';
import 'dart:io';
void login(String username,String password) async {
  var responseBody;
  var httpClient = new HttpClient();
  var request = await httpClient.getUrl(
      Uri.parse("http://www.wanandroid.com/project/list/1/json?cid=1"));

  var response = await request.close();
  //判断是否请求成功
  if (response.statusCode == 200) {
    //拿到请求的数据
    responseBody = await response.transform(utf8.decoder).join();
    //解析json，拿到对应的jsonArray数据
    var convertDataToJson = jsonDecode(responseBody)["data"]["datas"];
    //返回数据

  } else {
    print("error");
  }
}