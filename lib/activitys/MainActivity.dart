import 'dart:convert';

import 'package:earthworm_needle/activitys/AddGardenActivity.dart';
import 'package:earthworm_needle/activitys/CompanyActivity.dart';
import 'package:earthworm_needle/activitys/EditGardenActivity.dart';
import 'package:earthworm_needle/activitys/GardenDetailActivity.dart';
import 'package:earthworm_needle/activitys/LoginActivity.dart';
import 'package:earthworm_needle/activitys/UserManageActivity.dart';
import 'package:earthworm_needle/beans/Graden.dart';
import 'package:earthworm_needle/common/Global.dart';
import 'package:earthworm_needle/common/NetworkUtil.dart';
import 'package:earthworm_needle/coustomViews/FourDatasView.dart';
import 'package:earthworm_needle/coustomViews/LoadingDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class MainActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MainActivityState();
  }
}

class MainActivityState extends State<MainActivity> {
  List<Results> datalist = new List();
  ScrollController scrollController = new ScrollController();
  bool isPerformingRequest = false;
  int page = 1;
  List<String> menuList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Global.preferences.getBool("isAdmin")) {
      menuList = ["聯絡綠化牆 (弗蘭特)", "用戶管理", "登出"];
    } else {
      menuList = ["聯絡綠化牆 (弗蘭特)", "登出"];
    }
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadMoreDatas();
      }
    });
    onRefreshDatas();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () async {
            bool hasAdded = await Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => new AddGardenActivity()));
            if (hasAdded) onRefreshDatas();
          },
          icon: Icon(Icons.add, color: Color(0xff27DD8F)),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(
              Icons.view_list,
              color: Color(0xff27DD8F),
            ),
            onSelected: (title) {
              if (title == "登出") {
                Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(builder: (context) => LoginActivity()),
                        (route) => route == null);
              } else if (title == "聯絡綠化牆 (弗蘭特)") {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => CompanyActivity()));
              } else {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => UserManageActivity()));
              }
            },
            //Called when the user selects a value from the popup menu created by this button..
            itemBuilder: (BuildContext context) {
              return menuList.map((String choice) {
                return new PopupMenuItem(
                    child: new Text(choice), value: choice);
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        child: new RefreshIndicator(
            child: ListView.builder(
                controller: scrollController,
                itemBuilder: (context, i) {
                  if (i == datalist.length)
                    return buildProgressIndicator();
                  else
                    return new GardenItemView(
                        datalist[i],
                            () =>
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("提示"),
                                    content: Text("確定要删除该花园吗？"),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("取消"),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          doDelete(i);
                                        },
                                        child: Text("確定"),
                                      ),
                                    ],
                                  );
                                }),
                            () async {
                          bool hasEdited = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      EditGardenActivity(datalist[i])));
                          if (hasEdited)
                            onRefreshDatas();
                        });
                },
                itemCount: datalist.length + 1),
            onRefresh: onRefreshDatas),
      ),
    );
  }

  Widget buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> onRefreshDatas() async {
    page = 1;
    datalist.clear();
    Response response = await NetworkUtil.get(
        "/api/location/list?page=" + page.toString(), true);
    if (response != null && response.statusCode == 200) {
      print(response.body);
      Garden garden = Garden.fromJson(
          jsonDecode(Utf8Decoder().convert(response.bodyBytes)));
      setState(() {
        datalist.addAll(garden.results);
      });
    }
  }

  Future<void> loadMoreDatas() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      Response response = await NetworkUtil.get(
          "/api/location/list?page=" + page.toString(), true);
      try {
        Garden garden = Garden.fromJson(
            jsonDecode(Utf8Decoder().convert(response.bodyBytes)));
        setState(() {
          isPerformingRequest = false;
          datalist.addAll(garden.results);
        });
        page++;
      } catch (e) {
        setState(() {
          isPerformingRequest = false;
        });
      }
    }
  }

  void doDelete(int index) async {
    showDialog(
        context: context, builder: (context) => LoadingDialog("正在删除花园..."));
    Response response = await NetworkUtil.delete(
        "/api/location/" + datalist[index].id.toString() + "/delete", true);
    Navigator.pop(context);
    if (response != null && response.statusCode == 200) {
      datalist.remove(datalist[index]);
      setState(() {
        datalist = datalist;
      });
    } else {
      Fluttertoast.showToast(msg: "删除花园失败");
    }
  }
}

class GardenItemView extends StatelessWidget {
  Results garden;
  Function doDelete, doEdit;

  GardenItemView(Results garden, Function doDeletef, Function doEditf) {
    this.garden = garden;
    doDelete = doDeletef;
    doEdit = doEditf;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => new GardenDetailActivity(garden)));
        },
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: Text(garden.name),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(""),
                  ),
                  Container(
                    padding:
                    EdgeInsets.only(left: 0, top: 0, right: 25, bottom: 0),
                    child: new GestureDetector(
                        onTap: () => doEdit(),
                        child: Image.asset(
                          "images/edit.png",
                          width: 24,
                          height: 24,
                        )),
                  ),
                  Container(
                    child: new GestureDetector(
                        onTap: () => doDelete(),
                        child: Image.asset(
                          "images/delete.png",
                          width: 24,
                          height: 24,
                        )),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 5),
                alignment: Alignment.topLeft,
                child: Text(garden.address),
              ),
              Image.network(garden.image.image),
              FourDatasView(
                state: FourDatasViewState(-1),
                garden: garden,
                isGarden: true,
                onClick1: () {},
                onClick2: () {},
                onClick3: () {},
                onClick4: () {},
              )
            ],
          ),
          margin: EdgeInsets.only(left: 25, top: 20, right: 25, bottom: 20),
        ),
      ),
    );
  }
}
