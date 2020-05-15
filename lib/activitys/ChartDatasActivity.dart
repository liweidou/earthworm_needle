import 'dart:convert';

import 'package:earthworm_needle/activitys/CompanyActivity.dart';
import 'package:earthworm_needle/beans/DaysDataEntity.dart';
import 'package:earthworm_needle/beans/Graden.dart';
import 'package:earthworm_needle/beans/NeedleEntity.dart';
import 'package:earthworm_needle/beans/OneDayDataEntity.dart';
import 'package:earthworm_needle/common/Global.dart';
import 'package:earthworm_needle/common/NetworkUtil.dart';
import 'package:earthworm_needle/coustomViews/FourDatasView.dart';
import 'package:earthworm_needle/coustomViews/HorizontalPickerView.dart';
import 'package:earthworm_needle/coustomViews/LoadingDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:charts_flutter/flutter.dart' as chart;
import 'package:charts_common/common.dart' as common;

class ChartDatasActivity extends StatefulWidget {
  NeedleResult needle;
  Results garden;
  List<String> menuList;
  bool isGarden;
  int selectIndex;

  ChartDatasActivity(
      Results garden, NeedleResult needle, bool isGarden, int select) {
    this.needle = needle;
    this.garden = garden;
    this.isGarden = isGarden;
    menuList = ["聯絡綠化牆 (弗蘭特)"];
    selectIndex = select;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChartDatasActivityState();
  }
}

class ChartDatasActivityState extends State<ChartDatasActivity> {
  String datatype = "1day"; //"7days","1month"
  String selectedYear = "2019", selectedMonth = "10", selectedDay = "10";
  FourDatasView fourDatasView;
  String probetype = "moisture",
      perStr = "",
      fixStr = "%",
      chartColor = "green";
  List<common.Series<LinearSales, int>> seriesList = new List();
  List<HorizontalPickerItemBean> datalist = new List();
  HorizontalPickerView horizontalPickerView;
  bool isShowHorizontalPickerView = true;
  dynamic warning = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime dateTime = DateTime.now();
    selectedYear = dateTime.year.toString();
    selectedMonth = dateTime.month.toString();
    selectedDay = dateTime.day.toString();
    fourDatasView = FourDatasView(
      state: FourDatasViewState(widget.selectIndex),
      garden: widget.garden,
      needle: widget.needle,
      isGarden: widget.isGarden,
      onClick1: () {
        onClicDataItem(1, true);
      },
      onClick2: () {
        onClicDataItem(2, true);
      },
      onClick3: () {
        onClicDataItem(3, true);
      },
      onClick4: () {
        onClicDataItem(4, true);
      },
    );

    setDayList(false);
  }

  setDayList(bool isUpdate) {
    if (selectedMonth.length == 1) selectedMonth = "0" + selectedMonth;
    if (selectedDay.length == 1) selectedDay = "0" + selectedDay;
    String tian = Global.getEndMothFor(
        mothFormart: selectedYear + "-" + selectedMonth + "-" + selectedDay,
        format: "dd");
    datalist.clear();
    for (int i = 1; i <= int.parse(tian); i++) {
      datalist.add(HorizontalPickerItemBean(
          i == int.parse(selectedDay) - 1 ? true : false, i.toString()));
    }
    int size = datatype == "1day" ? 1 : 7;
    onClicDataItem(widget.selectIndex, isUpdate);
    if (isUpdate) {
      horizontalPickerView.setDatas(datalist, size, int.parse(selectedDay) - 1);
      setState(() {
        horizontalPickerView = horizontalPickerView;
      });
    } else {
      horizontalPickerView =
          HorizontalPickerView(datalist, size, int.parse(selectedDay) - 1, () {
        selectedDay = (horizontalPickerView.getSelected() + 1).toString();
        getDataFromSever(true);
      });
    }
    getDataFromSever(isUpdate);
  }

  onClicDataItem(int select, bool isUpdate) {
    if (isUpdate) fourDatasView.setSelected(select);
    widget.selectIndex = select;
    if (select == 1) {
      this.probetype = "moisture";
      this.perStr = "";
      this.fixStr = "%";
      chartColor = widget.isGarden
          ? widget.garden.moisture.color
          : widget.needle.moisture.color;
    } else if (select == 2) {
      this.probetype = "fertility";
      this.perStr = "";
      this.fixStr = "dm/s";
      chartColor = widget.isGarden
          ? widget.garden.fertility.color
          : widget.needle.fertility.color;
    } else if (select == 3) {
      this.probetype = "power";
      this.perStr = "";
      this.fixStr = "%";
      chartColor = widget.isGarden
          ? widget.garden.power.color
          : widget.needle.power.color;
    } else if (select == 4) {
      this.probetype = "temperature";
      this.perStr = "";
      this.fixStr = "℃";
      chartColor = "red";
    }
    if (isUpdate) getDataFromSever(true);
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
          PopupMenuButton<String>(
            icon: Icon(
              Icons.view_list,
              color: Color(Global.colorAccent),
            ),
            onSelected: (title) => Navigator.push(context,
                CupertinoPageRoute(builder: (context) => CompanyActivity())),
            //Called when the user selects a value from the popup menu created by this button..
            itemBuilder: (BuildContext context) {
              return widget.menuList.map((String choice) {
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
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                    widget.isGarden ? widget.garden.name : widget.needle.name),
              ),
              Container(
                padding: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 15),
                alignment: Alignment.topLeft,
                child: Text(widget.garden.address),
              ),
              fourDatasView,
              Container(
                padding:
                    EdgeInsets.only(left: 0, top: 10, right: 0, bottom: 10),
                child: Divider(),
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 35,
                    child: FlatButton(
                      textColor:
                          datatype == "1day" ? Colors.white : Color(0xff4a4a4a),
                      color: datatype == "1day"
                          ? Color(Global.colorAccent)
                          : Colors.transparent,
                      onPressed: () {
                        setState(() {
                          datatype = "1day";
                          isShowHorizontalPickerView = true;
                          setDayList(true);
                        });
                      },
                      child: Text(
                        "1日",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 35,
                    child: FlatButton(
                      textColor: datatype == "7days"
                          ? Colors.white
                          : Color(0xff4a4a4a),
                      color: datatype == "7days"
                          ? Color(Global.colorAccent)
                          : Colors.transparent,
                      onPressed: () {
                        setState(() {
                          datatype = "7days";
                          isShowHorizontalPickerView = true;
                          setDayList(true);
                        });
                      },
                      child: Text("7日"),
                    ),
                  ),
                  Container(
                    width: 70,
                    height: 35,
                    child: FlatButton(
                      textColor: datatype == "1month"
                          ? Colors.white
                          : Color(0xff4a4a4a),
                      color: datatype == "1month"
                          ? Color(Global.colorAccent)
                          : Colors.transparent,
                      onPressed: () {
                        setState(() {
                          isShowHorizontalPickerView = false;
                          datatype = "1month";
                          getDataFromSever(true);
                        });
                      },
                      child: Text("1個月"),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 0, top: 15, right: 0, bottom: 0),
                width: double.infinity,
                height: 35,
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          left: 0, top: 0, right: 10, bottom: 0),
                      padding: EdgeInsets.only(
                          left: 15, top: 0, right: 0, bottom: 0),
                      color: Color(0xfff3f3f3),
                      width: 100,
                      height: 35,
                      child: InkWell(
                        onTap: () {
                          DateTime dt = DateTime.now();
                          final picker = CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            onDateTimeChanged: (date) {
                              dt = date;
                            },
                            initialDateTime: dt,
                          );
                          showCupertinoModalPopup(
                              context: context,
                              builder: (cxt) {
                                return Container(
                                  height: 250,
                                  child: Stack(
                                    children: <Widget>[
                                      picker,
                                      Container(
                                        alignment: Alignment.topRight,
                                        child: FlatButton(
                                          child: Text("確定",
                                              style: TextStyle(
                                                  color: Color(Global.colorAccent),
                                                  fontSize: 16)),
                                          onPressed: () {
                                            setState(() {
                                              selectedYear = dt.year.toString();
                                              selectedMonth =
                                                  dt.month.toString();
                                              selectedDay =
                                                  (horizontalPickerView
                                                              .getSelected() +
                                                          1)
                                                      .toString();
                                              setDayList(true);
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
//                          showDatePicker(
//                                  context: context,
//                                  initialDate: new DateTime.now(),
//                                  firstDate: new DateTime.now()
//                                      .subtract(new Duration(days: 30)),
//                                  // 减 30 天
//                                  lastDate: new DateTime.now()
//                                      .add(new Duration(days: 30)),
//                                  // 加 30 天
//                                  initialDatePickerMode: DatePickerMode.day)
//                              .then((DateTime val) {
//                            setState(() {
//                              selectedYear = val.year.toString();
//                              selectedMonth = val.month.toString();
//                              selectedDay =
//                                  (horizontalPickerView.getSelected() + 1)
//                                      .toString();
//                              setDayList(true);
//                            });
//                            print(selectedMonth);
//                          }).catchError((err) {
//                            print(err);
//                          });
                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                              selectedYear + "-" + selectedMonth,
                              style: TextStyle(color: Color(0xff4a4a4a)),
                            ),
                            Icon(
                              Icons.unfold_more,
                              color: Color(0xff4a4a4a),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Offstage(
                        offstage: !isShowHorizontalPickerView,
                        child: horizontalPickerView,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: chart.LineChart(
                  seriesList,
                  defaultRenderer: chart.LineRendererConfig(
                      includeArea: true, stacked: true),
                  animate: true,
                  behaviors: [
                    chart.RangeAnnotation([
                      chart.LineAnnotationSegment(
                          warning, chart.RangeAnnotationAxisType.measure,
                          startLabel: " ",
                          endLabel: warning.toString() + fixStr,
                          color: chart.MaterialPalette.yellow.shadeDefault)
                    ])
                  ],
                ),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
      ),
    );
  }

  getDataFromSever(bool isShowDialog) async {
    String url = "";
    if (datatype == "1month") {
      if (widget.isGarden) {
        url = "/api/data/list?probetype=" +
            this.probetype +
            "&datetype=" +
            datatype +
            "&year=" +
            this.selectedYear +
            "&month=" +
            this.selectedMonth +
            "&location_id=" +
            widget.garden.id.toString();
      } else {
        url = "/api/data/list?probetype=" +
            this.probetype +
            "&datetype=" +
            this.datatype +
            "&year=" +
            this.selectedYear +
            "&month=" +
            this.selectedMonth +
            "&probe_id=" +
            widget.needle.id.toString();
      }
    } else {
      if (widget.isGarden) {
        url = "/api/data/list?probetype=" +
            this.probetype +
            "&datetype=" +
            this.datatype +
            "&year=" +
            this.selectedYear +
            "&month=" +
            this.selectedMonth +
            "&location_id=" +
            widget.garden.id.toString() +
            "&startday=" +
            this.selectedDay;
      } else {
        url = "/api/data/list?probetype=" +
            this.probetype +
            "&datetype=" +
            this.datatype +
            "&year=" +
            this.selectedYear +
            "&month=" +
            this.selectedMonth +
            "&probe_id=" +
            widget.needle.id.toString() +
            "&startday=" +
            this.selectedDay;
      }
    }
    if (isShowDialog)
      showDialog(
          context: context,
          builder: (context) => new LoadingDialog("正在获取数据..."));
    Response response = await NetworkUtil.get(url, true);
    if (response != null && response.statusCode == 200) {
      List<LinearSales> list = new List();
      if (datatype == "1day") {
        OneDayDataEntity oneDayDataEntity =
            OneDayDataEntity.fromJson(jsonDecode(response.body));
        oneDayDataEntity.data.forEach(
            (data) => {list.add(new LinearSales(data.hour, data.avg))});
        setState(() {
          warning = probetype == "temperature" ? 0 : oneDayDataEntity.warning;
          seriesList = [
            new common.Series<LinearSales, int>(
              id: "hours",
              data: list,
              colorFn: (_, __) => chartColor == "red"
                  ? chart.MaterialPalette.red.shadeDefault
                  : (chartColor == "green"
                      ? chart.MaterialPalette.green.shadeDefault
                      : chart.MaterialPalette.yellow.shadeDefault),
              domainFn: (LinearSales ls, _) => ls.time,
              measureFn: (LinearSales ls, _) => ls.value,
            ),
          ];
        });
      } else {
        DaysDataEntity daysDataEntity =
            DaysDataEntity.fromJson(jsonDecode(response.body));
        daysDataEntity.data
            .forEach((data) => {list.add(new LinearSales(data.day, data.avg))});
        setState(() {
          warning = probetype == "temperature" ? 0 : daysDataEntity.warning;
          seriesList = [
            new common.Series<LinearSales, int>(
              id: "days",
              data: list,
              colorFn: (_, __) => chartColor == "red"
                  ? chart.MaterialPalette.red.shadeDefault
                  : (chartColor == "green"
                      ? chart.MaterialPalette.green.shadeDefault
                      : chart.MaterialPalette.yellow.shadeDefault),
              domainFn: (LinearSales ls, _) => ls.time,
              measureFn: (LinearSales ls, _) => ls.value,
            ),
          ];
        });
      }
      print("url:" + url + " warning:" + warning.toString());
      print(response.body);
    }
    if (isShowDialog) Navigator.of(context).pop();
  }
}

class LinearSales {
  final int time;
  final double value;

  LinearSales(this.time, this.value);
}
