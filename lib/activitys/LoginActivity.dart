import 'dart:convert';

import 'package:earthworm_needle/activitys/MainActivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:earthworm_needle/coustomViews/LoadingDialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:earthworm_needle/common/Global.dart';
import 'package:earthworm_needle/common/NetworkUtil.dart';

class LoginActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginActivityState();
  }
}

class LoginActivityState extends State<LoginActivity> {
  bool isChecked = false;
  TextEditingController phoneControll = new TextEditingController();
  TextEditingController passwordControll = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAccount();
  }

  void initAccount() async {
    Global.preferences = await SharedPreferences.getInstance();
    setState(() {
      phoneControll.text = Global.preferences.get("userName");
      passwordControll.text = Global.preferences.get("password");
      isChecked = Global.preferences.getBool("isAdmin") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            child: Image.asset("images/login_bg.png",
                width: double.infinity, height: 500, fit: BoxFit.fitWidth),
            alignment: Alignment.topCenter,
          ),
          Container(
            margin: EdgeInsets.only(left: 50, top: 220, right: 50, bottom: 0),
            child: TextField(
                keyboardType: TextInputType.phone,
                controller: phoneControll,
                cursorColor: Colors.white,
                style: new TextStyle(fontSize: 16, color: Colors.white),
                decoration: new InputDecoration(
                    hintText: "请输入手机号",
                    hintStyle: new TextStyle(fontSize: 13, color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)))),
          ),
          Container(
            margin: EdgeInsets.only(left: 50, top: 300, right: 50, bottom: 0),
            child: Offstage(
              offstage: !isChecked,
              child: TextField(
                  keyboardType: TextInputType.text,
                  controller: passwordControll,
                  cursorColor: Colors.white,
                  style: new TextStyle(fontSize: 16, color: Colors.white),
                  decoration: new InputDecoration(
                      hintText: "请输入密码",
                      hintStyle:
                          new TextStyle(fontSize: 13, color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)))),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 50, top: 360, right: 50, bottom: 0),
            height: 40,
            child: MaterialButton(
              onPressed: () {},
              child: Text("忘记密码"),
              textColor: Colors.white,
              color: Color(0xff54CDBA),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
            alignment: Alignment.topRight,
          ),
          Container(
            margin: EdgeInsets.only(left: 50, top: 500, right: 50, bottom: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                    child: Image.asset(
                        isChecked
                            ? "images/selected.png"
                            : "images/no-select.png",
                        width: 40,
                        height: 40),
                  ),
                ),
                Text(
                  "我是管理员",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 50, top: 550, right: 50, bottom: 0),
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
                "登录",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              color: Colors.transparent,
              elevation: 0,
              highlightElevation: 0,
              onPressed: () {
                doLogin();
              },
            ),
          )
        ],
      ),
    );
  }

  void doLogin() async {
    print("doLogin");
    if (phoneControll.text.isEmpty) {
      Fluttertoast.showToast(msg: "先输入手机号");
      return;
    }
    if (isChecked && passwordControll.text.isEmpty) {
      Fluttertoast.showToast(msg: "先输入密码");
      return;
    }
    showDialog(
        context: context, builder: (context) => new LoadingDialog("登录中..."));
    String dataURL = "";
    Map<String, String> bodys;
    if (isChecked) {
      //管理員
      dataURL = "/api/rest-auth/login/";
      bodys = {
        "username": phoneControll.text,
        "password": passwordControll.text
      };
    } else {
      //普通員工
      bodys = {"username": phoneControll.text};
      dataURL = "/api/user/login";
    }
    try {
      http.Response response = await NetworkUtil.post(dataURL, bodys, false);
      if (response != null && response.statusCode == 200) {
        Global.preferences.setString("userName", phoneControll.text);
        Global.preferences.setString("password", passwordControll.text);
        Global.preferences.setBool("isAdmin", isChecked);
        Global.API_TOKEN = "Token " + json.decode(response.body)["key"];
        print(Global.API_TOKEN);
      } else {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: "登录失败");
        return;
      }
    } catch (e) {
      print(e);
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "登录失败");
      return;
    }
    Navigator.of(context).pop();
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (context) => MainActivity()),
        (rount) => rount == null);
  }
}
