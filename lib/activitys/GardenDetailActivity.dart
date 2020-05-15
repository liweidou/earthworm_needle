import 'dart:convert';

import 'package:earthworm_needle/activitys/AddNeedleActivity.dart';
import 'package:earthworm_needle/activitys/ChartDatasActivity.dart';
import 'package:earthworm_needle/activitys/CompanyActivity.dart';
import 'package:earthworm_needle/activitys/EditNeedleActivity.dart';
import 'package:earthworm_needle/beans/Graden.dart';
import 'package:earthworm_needle/beans/NeedleEntity.dart';
import 'package:earthworm_needle/common/Global.dart';
import 'package:earthworm_needle/common/NetworkUtil.dart';
import 'package:earthworm_needle/coustomViews/FourDatasView.dart';
import 'package:earthworm_needle/coustomViews/LoadingDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class GardenDetailActivity extends StatefulWidget {
  Results graden;

  GardenDetailActivity(Results results) {
    graden = results;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GardenDetailActivityState();
  }
}

class GardenDetailActivityState extends State<GardenDetailActivity> {
  List<String> menuList;
  List<NeedleResult> needleList = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    menuList = ["聯絡綠化牆 (弗蘭特)"];
    getNeedles();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Color(Global.colorAccent),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              bool hasAdded = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => AddNeedleActivity(widget.graden)));
              if (hasAdded) getNeedles();
            },
            icon: Icon(
              Icons.add,
              color: Color(Global.colorAccent),
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.view_list,
              color: Color(Global.colorAccent),
            ),
            onSelected: (title) => Navigator.push(context,
                CupertinoPageRoute(builder: (context) => CompanyActivity())),
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
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 25, top: 20, right: 25, bottom: 20),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: Text(widget.graden.name),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(""),
                  ),
                  Container(
                    child: new GestureDetector(
                        onTap: () async {
                          String url = 'tel:' + widget.graden.subuser.mobile;
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw '手机号异常，不能拨打电话';
                          }
                        },
                        child: Image.asset(
                          "images/phone.png",
                          width: 24,
                          height: 24,
                        )),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 5),
                alignment: Alignment.topLeft,
                child: Text(widget.graden.address),
              ),
              Image.network(
                widget.graden.image.image,
                width: double.infinity,
                height: 200,
                fit: BoxFit.fitWidth,
              ),
              FourDatasView(
                state: FourDatasViewState(-1),
                garden: widget.graden,
                isGarden: true,
                onClick1: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => ChartDatasActivity(
                            widget.graden, NeedleResult(), true, 1))),
                onClick2: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => ChartDatasActivity(
                            widget.graden, NeedleResult(), true, 2))),
                onClick3: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => ChartDatasActivity(
                            widget.graden, NeedleResult(), true, 3))),
                onClick4: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => ChartDatasActivity(
                            widget.graden, NeedleResult(), true, 4))),
              ),
              Container(
                margin: EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 0),
                child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) => NeedleListItemView(
                            needleList[i], widget.graden, () async {
                          bool hasEdit = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      EditNeedleActivity(needleList[i])));
                          if (hasEdit) getNeedles();
                        }, () => deleteOneNeedle(i)),
                    separatorBuilder: (context, i) => Divider(height: 1),
                    itemCount: needleList.length),
              )
            ],
          ),
        ),
      ),
    );
  }

  void getNeedles() async {
    Response response = await NetworkUtil.get(
        "/api/probe/list?location__id=" + widget.graden.id.toString(), true);
    try {
      print(response.body);
      NeedleEntity needle = NeedleEntity.fromJson(
          jsonDecode(Utf8Decoder().convert(response.bodyBytes)));
      needleList.clear();
      setState(() {
        needleList.addAll(needle.results);
      });
    } catch (e) {}
  }

  void deleteOneNeedle(int needleIndex) async {
    showDialog(
        context: context, builder: (context) => new LoadingDialog("删除中..."));
    Response response = await NetworkUtil.delete(
        "/api/probe/" + needleList[needleIndex].id.toString() + "/delete",
        true);
    Navigator.pop(context);
    if (response != null && response.statusCode == 200) {
      needleList.removeAt(needleIndex);
      setState(() => needleList = needleList);
      Fluttertoast.showToast(msg: "刪除蚯蚓針成功！");
    } else {
      Fluttertoast.showToast(msg: "刪除蚯蚓針失敗！");
    }
  }

  onClickDataView(int i) {}
}

class NeedleListItemView extends StatelessWidget {
  NeedleResult needle;
  Results garden;
  Function doEdit, doDelete;
  ScrollController controller = new ScrollController();

  NeedleListItemView(NeedleResult entity, Results results, Function doEditF,
      Function doDeleteF) {
    needle = entity;
    garden = results;
    doDelete = doDeleteF;
    doEdit = doEditF;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      controller: controller,
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {
              controller.animateTo(0,
                  duration: Duration(milliseconds: 300), curve: Curves.linear);
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) =>
                          ChartDatasActivity(garden, needle, false, 1)));
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 50,
              height: 60,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 16, top: 0, right: 0, bottom: 0),
                      child: Text(needle.name),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Image.asset(
                      needle.moisture.color == 'red'
                          ? "images/water-red-small.png"
                          : needle.moisture.color == 'yellow'
                              ? "images/water-yellow-small.png"
                              : "images/water-green-small.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Image.asset(
                      needle.fertility.color == 'red'
                          ? "images/fertility-red-small.png"
                          : needle.fertility.color == 'yellow'
                              ? "images/fertility-yellow-small.png"
                              : "images/fertility-green-small.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Image.asset(
                      needle.power.color == 'red'
                          ? "images/power-red-small.png"
                          : needle.power.color == 'yellow'
                              ? "images/power-yellow-small.png"
                              : "images/power-green-small.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 60,
            height: 60,
            child: RaisedButton(
              onPressed: () {
                controller.animateTo(0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear);
                doEdit();
              },
              color: Color(0xff4EBDB3),
              textColor: Colors.white,
              child: Text("編輯"),
            ),
          ),
          SizedBox(
            width: 60,
            height: 60,
            child: RaisedButton(
              onPressed: () {
                controller.animateTo(0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear);
                showIsDeleteDialog(context);
              },
              color: Color(0xffBDBABA),
              textColor: Colors.white,
              child: Text("刪除"),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> showIsDeleteDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("提示"),
            content: Text("确认要删除该蚯蚓针吗？"),
            actions: <Widget>[
              FlatButton(
                child: Text("取消"),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text("確定"),
                onPressed: () {
                  Navigator.pop(context);
                  doDelete();
                },
              )
            ],
          );
        });
  }
}
