import 'package:earthworm_needle/common/Global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompanyActivity extends StatelessWidget {
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
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 800,
              child: Image.asset("images/company-bg.png",
                  width: MediaQuery.of(context).size.width, height: 500, fit: BoxFit.fitWidth),
              alignment: Alignment.center,
            ),
            Container(
              margin: EdgeInsets.only(left: 100,top: 280,right: 0,bottom: 0),
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text("蚯蚓针系统",style: TextStyle(fontSize: 23),),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 0,top: 10,right: 0,bottom: 0),
                    alignment: Alignment.topLeft,
                    child: Text("绿化墙设计有限公司（弗兰特)",style: TextStyle(fontSize: 16),),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 0,top: 10,right: 0,bottom: 0),
                    alignment: Alignment.topLeft,
                    child: Text("营业时间：8:30 -- 18:30 PM",style: TextStyle(fontSize: 16),),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 0,top: 10,right: 0,bottom: 0),
                    alignment: Alignment.topLeft,
                    child: Text("联络电话：6663 6648",style: TextStyle(fontSize: 16),),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
