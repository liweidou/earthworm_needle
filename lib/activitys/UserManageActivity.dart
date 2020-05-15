import 'dart:convert';

import 'package:earthworm_needle/beans/UserEntity.dart';
import 'package:earthworm_needle/common/Global.dart';
import 'package:earthworm_needle/common/NetworkUtil.dart';
import 'package:earthworm_needle/coustomViews/LoadingDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class UserManageActivity extends StatefulWidget {
  UserManageActivityState activityState;

  UserManageActivity() {
    activityState = UserManageActivityState();
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return activityState;
  }
}

class UserManageActivityState extends State<UserManageActivity> {
  List<UserResult> results = List();
  List<UserResult> deleteList = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserList();
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
        title: Text("用戶管理",style: TextStyle(color: Colors.black,fontSize: 20),),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              List<UserResult> list = List();
              UserResult user = UserResult();
              user.id = -1;
              user.name = "";
              user.mobile = "";
              list.add(user);
              list.addAll(results);
              setState(() {
                results = list;
              });
            },
            icon: Icon(
              Icons.add,
              color: Color(Global.colorAccent),
            ),
          ),
          IconButton(
            onPressed: () async {
              if (containNotFinished()) {
                Fluttertoast.showToast(msg: "資料不能留空");
                return;
              }
              showDialog(
                  context: context,
                  builder: (context) => LoadingDialog("正在保存用戶列表..."));
              List<UserResult> paramsList = List();
              paramsList.addAll(results);
              paramsList.addAll(deleteList);
              var params = {"users": paramsList};
              var body = utf8.encode(json.encode(params));
              Response response = await NetworkUtil.postWithBody(
                  "/api/user/create", body, true);
              Navigator.pop(context);
              if (response != null && response.statusCode == 200) {
                Fluttertoast.showToast(msg: "保存成功");
                Navigator.pop(context);
              } else {
                print(response.body);
                Fluttertoast.showToast(msg: "保存失败");
              }
            },
            icon: Icon(
              Icons.save,
              color: Color(Global.colorAccent),
            ),
          )
        ],
      ),
      body: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, i) => UserListItemView(results[i], () {
                UserResult user = results[i];
                user.is_deleted = true;
                deleteList.add(user);
                results.remove(user);
                setState(() {
                  results = results;
                });
              }),
          separatorBuilder: (context, i) => Divider(
                height: 8,
                color: Color(0x00000000),
              ),
          itemCount: results.length),
    );
  }

  void getUserList() async {
    Response response = await NetworkUtil.get("/api/user/list", true);
    if (response != null && response.statusCode == 200) {
      print("userlist:" + response.body);
      UserEntity userEntity = UserEntity.fromJson(
          jsonDecode(Utf8Decoder().convert(response.bodyBytes)));
      setState(() {
        results = userEntity.results;
      });
    }
  }

  bool containNotFinished() {
    bool result = false;
    results.forEach(
        (item) => {if (item.name == "" || item.mobile == "") result = true});
    return result;
  }
}

class UserListItemView extends StatelessWidget {
  ScrollController scrollController = ScrollController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  Function doDelete;

  UserListItemView(UserResult result, Function doDeletef) {
    nameController.text = result.name;
    phoneController.text = result.mobile;
    doDelete = doDeletef;
    nameController.addListener(() => result.name = nameController.text);
    phoneController.addListener(() => result.mobile = phoneController.text);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 130,
            child: Container(
              margin: EdgeInsets.only(left: 70, top: 10, right: 70, bottom: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("姓名：   ", style: TextStyle(fontSize: 17)),
                      Container(
                        width: 150,
                        child: TextField(
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          style:
                              TextStyle(fontSize: 17, color: Color(0xff666667)),
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    height: 1,
                  ),
                  Row(
                    children: <Widget>[
                      Text("电话：   ", style: TextStyle(fontSize: 17)),
                      Container(
                        width: 150,
                        child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          style:
                              TextStyle(fontSize: 17, color: Color(0xff666667)),
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    height: 1,
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff15BBAD), Color(0xff27DD8F)]),
                borderRadius: BorderRadius.circular(5)),
            width: 100,
            height: 130,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                "删除",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              color: Colors.transparent,
              elevation: 0,
              highlightElevation: 0,
              onPressed: () {
                doDelete();
                scrollController.animateTo(0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear);
              },
            ),
          )
        ],
      ),
    );
  }
}
