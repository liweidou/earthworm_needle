import 'dart:convert';

import 'package:earthworm_needle/beans/handler_entity.dart';
import 'package:earthworm_needle/common/Global.dart';
import 'package:earthworm_needle/common/NetworkUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SelectHandlerActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SelectHandlerActivitySate();
  }
}

class SelectHandlerActivitySate extends State<SelectHandlerActivity> {
  TextEditingController handlerController = TextEditingController();
  List<HandlerResult> results = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHandlers();
    handlerController.addListener((){
      getHandlers();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "選擇負責人",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Color(Global.colorAccent),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 30, top: 30, right: 30, bottom: 0),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 30),
              height: 40,
              child: TextField(
                controller: handlerController,
                style: new TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.search,
                      color: Color(Global.colorAccent),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(Global.colorAccent)),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(Global.colorAccent)),
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
            ListView.separated(
                shrinkWrap: true,
                controller: ScrollController(),
                itemBuilder: (context, i) {
                  return Container(
                    height: 60,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context,results[i]);
                      },
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              results[i].name,
                              style:
                                  TextStyle(color: Color(Global.colorAccent)),
                            ),
                            margin: EdgeInsets.only(
                                left: 10, top: 0, right: 0, bottom: 0),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(""),
                          ),
                          Container(
                            child: Text(
                              results[i].mobile,
                              style:
                                  TextStyle(color: Color(Global.colorAccent)),
                            ),
                            margin: EdgeInsets.only(
                                left: 0, top: 0, right: 10, bottom: 0),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, i) => Divider(
                      height: 1,
                    ),
                itemCount: results.length)
          ],
        ),
      ),
    );
  }

  Future getHandlers() async {
    print("getHandlers");
    Response response;
    if (handlerController.text.isEmpty)
      response = await NetworkUtil.get("/api/user/list", true);
    else
      response = await NetworkUtil.get("/api/user/list?search=" + handlerController.text, true);
    if(response != null && response.statusCode == 200){
      print(response.body);
      HandlerEntity handlerEntity = HandlerEntity.fromJson(jsonDecode(Utf8Decoder().convert(response.bodyBytes)));
      setState(() {
        results = handlerEntity.results;
      });
    }else{
      print("null");
    }
  }
}
