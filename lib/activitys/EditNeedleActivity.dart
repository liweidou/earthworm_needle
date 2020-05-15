import 'package:earthworm_needle/beans/NeedleEntity.dart';
import 'package:earthworm_needle/common/Global.dart';
import 'package:earthworm_needle/common/NetworkUtil.dart';
import 'package:earthworm_needle/coustomViews/LoadingDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class EditNeedleActivity extends StatefulWidget {
  EditNeedleActivityState editNeedleActivityState;

  EditNeedleActivity(NeedleResult needle) {
    editNeedleActivityState = EditNeedleActivityState(needle);
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return editNeedleActivityState;
  }
}

class EditNeedleActivityState extends State<EditNeedleActivity> {
  TextEditingController idController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  bool isSandy = false;
  NeedleResult needle;

  EditNeedleActivityState(NeedleResult needleResult) {
    needle = needleResult;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idController.text = needle.serialno;
    nameController.text = needle.name;
    isSandy = needle.sandy;
    print("needle:" + needle.toString());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context, false),
          icon: Icon(
            Icons.arrow_back,
            color: Color(Global.colorAccent),
          ),
        ),
        title: Text(
          "編輯蚯蚓針",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.bottomLeft,
                width: 100,
                height: 30,
                margin:
                    EdgeInsets.only(left: 50, top: 25, right: 10, bottom: 20),
                child: Text(
                  "蚯蚓針ID",
                  style: TextStyle(fontSize: 17),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                width: 200,
                height: 30,
                child: TextField(
                  controller: idController,
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.bottomLeft,
                width: 100,
                height: 30,
                margin:
                    EdgeInsets.only(left: 50, top: 15, right: 10, bottom: 30),
                child: Text(
                  "名稱",
                  style: TextStyle(fontSize: 17),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                width: 200,
                height: 30,
                margin: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 20),
                child: TextField(
                  controller: nameController,
                ),
              )
            ],
          ),
          Divider(height: 1),
          Container(
            margin: EdgeInsets.only(left: 35, top: 0, right: 0, bottom: 0),
            child: Row(
              children: <Widget>[
                Checkbox(
                  value: isSandy,
                  onChanged: (isChecked) {
                    setState(() {
                      isSandy = isChecked;
                    });
                  },
                ),
                Text("沙質土壤")
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 50, top: 50, right: 50, bottom: 0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff15BBAD), Color(0xff27DD8F)]),
                borderRadius: BorderRadius.circular(5)),
            width: double.infinity,
            height: 50,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                "確定",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              color: Colors.transparent,
              elevation: 0,
              highlightElevation: 0,
              onPressed: () {
                doEdit();
              },
            ),
          )
        ],
      ),
    );
  }

  void doEdit() async {
    if (idController.text.isEmpty) {
      Fluttertoast.showToast(msg: "先输入蚯蚓針ID");
      return;
    }
    if (nameController.text.isEmpty) {
      Fluttertoast.showToast(msg: "先输入蚯蚓針名稱");
      return;
    }
    showDialog(
        context: context, builder: (context) => new LoadingDialog("保存中..."));
    Map<String, Object> bodys = {
      "serialno": idController.text,
      "name": nameController.text,
      "location": needle.location.toString(),
      "sandy": isSandy.toString(),
      "warningitem": [].toString()
    };
    Response respone = await NetworkUtil.putWithParams(
        "/api/probe/" + needle.id.toString() + "/update", bodys, true);
    Navigator.pop(context);
    print(respone);
    if (respone != null && respone.statusCode == 200) {
      Fluttertoast.showToast(msg: "保存成功");
      Navigator.pop(context, true);
    } else {
      Fluttertoast.showToast(msg: "保存失败");
    }
  }
}
