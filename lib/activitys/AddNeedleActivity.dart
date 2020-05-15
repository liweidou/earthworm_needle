import 'package:earthworm_needle/beans/Graden.dart';
import 'package:earthworm_needle/common/Global.dart';
import 'package:earthworm_needle/common/NetworkUtil.dart';
import 'package:earthworm_needle/coustomViews/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class AddNeedleActivity extends StatefulWidget {
  AddNeedleActivityState activityState;

  AddNeedleActivity(Results graden) {
    activityState = AddNeedleActivityState(graden);
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return activityState;
  }
}

class AddNeedleActivityState extends State<AddNeedleActivity> {
  Results graden;
  TextEditingController idController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  bool isSandy = false;

  AddNeedleActivityState(Results graden) {
    this.graden = graden;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
          "增加蚯蚓針",
          style: TextStyle(color: Colors.black,fontSize: 20),
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
                  "花園",
                  style: TextStyle(fontSize: 17),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                width: 200,
                height: 30,
                child: Text(
                  graden.name,
                  style: TextStyle(fontSize: 17),
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
                    EdgeInsets.only(left: 50, top: 15, right: 10, bottom: 20),
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
            margin: EdgeInsets.only(left: 50, top: 20, right: 50, bottom: 0),
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
                doAdd();
              },
            ),
          )
        ],
      ),
    );
  }

  void doAdd() async {
    if (idController.text.isEmpty) {
      Fluttertoast.showToast(msg: "先输入蚯蚓針ID");
      return;
    }
    if (nameController.text.isEmpty) {
      Fluttertoast.showToast(msg: "先输入蚯蚓針名稱");
      return;
    }
    showDialog(
        context: context, builder: (context) => new LoadingDialog("增加中..."));
    Map<String, Object> params = {
      "serialno": idController.text,
      "name": nameController.text,
      "location": graden.id.toString(),
      "sandy": isSandy.toString(),
      "warningitem": [].toString()
    };
    Response response =
        await NetworkUtil.post("/api/probe/create", params, true);
    Navigator.pop(context);
    print(response);
    if (response != null && response.statusCode == 200) {
      Fluttertoast.showToast(msg: "保存成功");
      Navigator.pop(context, true);
    } else {
      Fluttertoast.showToast(msg: "增加失败");
    }
  }
}
