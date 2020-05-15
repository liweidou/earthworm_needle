import 'package:earthworm_needle/activitys/CompanyActivity.dart';
import 'package:earthworm_needle/activitys/SelectHandlerActivity.dart';
import 'package:earthworm_needle/beans/Graden.dart';
import 'package:earthworm_needle/beans/handler_entity.dart';
import 'package:earthworm_needle/common/Global.dart';
import 'package:earthworm_needle/common/NetworkUtil.dart';
import 'package:earthworm_needle/coustomViews/LoadingDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class EditGardenActivity extends StatefulWidget {
  Results garden;

  EditGardenActivity(Results garden) {
    this.garden = garden;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditGardenActivityState();
  }
}

class EditGardenActivityState extends State<EditGardenActivity> {
  List<String> menuList;
  var imagePath;
  String imageUrl;
  bool hasImage = false;
  String handler = "";
  int handlerId = 0;
  TextEditingController nameControll = new TextEditingController();
  TextEditingController locationControll = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    menuList = ["聯絡綠化牆 (弗蘭特) "];
    nameControll.text = widget.garden.name;
    locationControll.text = widget.garden.address;
    handler = widget.garden.subuser.name;
    handlerId = widget.garden.subuser.id;
    hasImage = true;
    imageUrl = widget.garden.image.image;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Color(Global.colorAccent),
          ),
        ),
        title: Text(
          "编辑花园",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
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
          margin: EdgeInsets.only(left: 20, top: 15, right: 15, bottom: 20),
          child: Column(
            children: <Widget>[
              Card(
                child: InkWell(
                  onTap: () {
                    showSelectGetPhotoTypeDialog();
                  },
                  child: Stack(
                    children: <Widget>[
                      !hasImage
                          ? Container(
                              color: Color(0xffcccccc),
                              child: Image.asset("images/carema.png"),
                              width: double.infinity,
                              height: 200,
                              alignment: Alignment.center,
                            )
                          : Container(
                              color: Color(0xffcccccc),
                              child: imagePath == null
                                  ? Image.network(imageUrl,
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.fitWidth)
                                  : Image.file(
                                      imagePath,
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.fitWidth,
                                    ),
                              width: double.infinity,
                              height: 200,
                              alignment: Alignment.center,
                            )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 5, top: 20, right: 5, bottom: 0),
                child: TextField(
                  controller: nameControll,
                  decoration: InputDecoration(
                      hintText: "請輸入花園名稱",
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffeaeaea))),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffeaeaea)))),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 5, top: 20, right: 5, bottom: 0),
                child: TextField(
                  controller: locationControll,
                  decoration: InputDecoration(
                      hintText: "請輸入花園地址",
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffeaeaea))),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffeaeaea)))),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 5, top: 0, right: 5, bottom: 0),
                height: 70,
                child: InkWell(
                  onTap: () async {
                    HandlerResult result = await Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => SelectHandlerActivity()));
                    if(result != null)
                      setState(() {
                        handler = result.name;
                        handlerId = result.id;
                      });
                  },
                  child: Row(
                    children: <Widget>[
                      Text("負責人："),
                      Expanded(
                        flex: 1,
                        child: Text(handler, textAlign: TextAlign.center),
                      ),
                      Icon(
                        Icons.navigate_next,
                        color: Color(Global.colorAccent),
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                height: 2,
                color: Color(0xffeaeaea),
              ),
              Container(
                margin: EdgeInsets.only(left: 0, top: 50, right: 0, bottom: 0),
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
                    doEditGarden();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showSelectGetPhotoTypeDialog() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    getPhoto(true);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    child: Text(
                      "拍照",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    alignment: Alignment.center,
                  ),
                ),
                Divider(
                  height: 1,
                ),
                InkWell(
                  onTap: () {
                    getPhoto(false);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    child: Text(
                      "相册",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    alignment: Alignment.center,
                  ),
                )
              ],
            ));
  }

  void getPhoto(bool isTake) async {
    Navigator.pop(context);
    var imageFile = await ImagePicker.pickImage(
        source: isTake ? ImageSource.camera : ImageSource.gallery);
    print("getPhoto:" + imageFile.toString());
    if (imageFile != null)
      setState(() {
        hasImage = true;
        imagePath = imageFile;
      });
  }

  void doEditGarden() async {
    if (nameControll.text.isEmpty) {
      Fluttertoast.showToast(msg: "請先輸入花園名稱");
      return;
    }
    if (locationControll.text.isEmpty) {
      Fluttertoast.showToast(msg: "請先輸入花園地址");
      return;
    }
    if (handler.isEmpty) {
      Fluttertoast.showToast(msg: "請先選擇花園負責人");
      return;
    }
    showDialog(
        context: context, builder: (context) => LoadingDialog("提交花園數據中..."));
    if (imagePath != null) {
      await NetworkUtil.uploadFile(
          "http://greenprobe.infitack.net/api/image/upload", imagePath, true);
    }
    Response response = await NetworkUtil.putWithParams(
        "/api/location/" + widget.garden.id.toString() + "/update",
        {
          "name": nameControll.text,
          "image": imagePath != null ? 0.toString() : widget.garden.image.id.toString(),
          "address": locationControll.text,
          "subuser": handlerId.toString()
        },
        true);
    Navigator.pop(context);
    if (response != null && response.statusCode == 200) {
      Fluttertoast.showToast(msg: "修改花園數據成功");
      Navigator.pop(context, true);
    } else {
      Fluttertoast.showToast(msg: "修改花園數據失敗");
    }
  }
}
