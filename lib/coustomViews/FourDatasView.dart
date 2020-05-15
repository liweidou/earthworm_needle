import 'package:earthworm_needle/beans/Graden.dart';
import 'package:earthworm_needle/beans/NeedleEntity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FourDatasView extends StatefulWidget {
  final Results garden;
  final NeedleResult needle;
  final bool isGarden;
  final Function onClick1, onClick2, onClick3, onClick4;
  final FourDatasViewState state;

  const FourDatasView(
      {Key key,
      @required this.state,
      this.garden,
      this.needle,
      @required this.isGarden,
      @required this.onClick1,
      @required this.onClick2,
      @required this.onClick3,
      @required this.onClick4})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return state;
  }

  setSelected(int select) {
    state.setState(() => state.selectedIndex = select);
  }
}

class FourDatasViewState extends State<FourDatasView> {
  int selectedIndex = -1;

  FourDatasViewState(int select) {
    selectedIndex = select;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(left: 0, top: 15, right: 0, bottom: 0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Ink(
              padding:
              EdgeInsets.only(left: 0, top: 8, right: 0, bottom: 10),
              color:
                  selectedIndex == 1 ? Color(0xfff3f3f3) : Colors.transparent,
              child: InkWell(
                onTap: widget.onClick1,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Offstage(
                      offstage:
                          !widget.isGarden || widget.garden.moisture.count == 0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                left: 30, top: 0, right: 0, bottom: 0),
                            width: 18,
                            height: 18,
                            child: FlatButton(
                              onPressed: () {},
                              child: Text(""),
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.red),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(9))),
                            ),
                            alignment: Alignment.center,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 30, top: 0, right: 0, bottom: 0),
                            child: Text(
                              widget.isGarden
                                  ? (widget.garden.moisture.count > 99
                                      ? "99+"
                                      : widget.garden.moisture.count.toString())
                                  : "",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 8),
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Image.asset(
                          (widget.isGarden
                                      ? widget.garden.moisture.color
                                      : widget.needle.moisture.color) ==
                                  'red'
                              ? "images/water-red-big.png"
                              : (widget.isGarden
                                          ? widget.garden.moisture.color
                                          : widget.needle.moisture.color) ==
                                      'yellow'
                                  ? "images/water-yellow-big.png"
                                  : "images/water-green-big.png",
                          width: 30,
                          height: 30,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 0, top: 5, right: 0, bottom: 0),
                          child: Text(
                            widget.isGarden
                                ? widget.garden.moisture.avg.toString()
                                : widget.needle.moisture.avg.toString() + "%",
                            style: new TextStyle(
                                color: (widget.isGarden
                                            ? widget.garden.moisture.color
                                            : widget.needle.moisture.color) ==
                                        'red'
                                    ? Color(0xffF36649)
                                    : (widget.isGarden
                                                ? widget.garden.moisture.color
                                                : widget
                                                    .needle.moisture.color) ==
                                            'yellow'
                                        ? Color(0xffFDCA3E)
                                        : Color(0xff7ED321)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Ink(
              padding:
              EdgeInsets.only(left: 0, top: 8, right: 0, bottom: 10),
              color:
                  selectedIndex == 2 ? Color(0xfff3f3f3) : Colors.transparent,
              child: InkWell(
                onTap: widget.onClick2,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Offstage(
                      offstage: !widget.isGarden ||
                          widget.garden.fertility.count == 0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                left: 30, top: 0, right: 0, bottom: 0),
                            width: 18,
                            height: 18,
                            child: FlatButton(
                              onPressed: () {},
                              child: Text(""),
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.red),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(9))),
                            ),
                            alignment: Alignment.center,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 30, top: 0, right: 0, bottom: 0),
                            child: Text(
                              widget.isGarden
                                  ? (widget.garden.fertility.count > 99
                                      ? "99+"
                                      : widget.garden.fertility.count
                                          .toString())
                                  : "",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 8),
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Image.asset(
                          (widget.isGarden
                                      ? widget.garden.fertility.color
                                      : widget.needle.fertility.color) ==
                                  'red'
                              ? "images/fertility-red-big.png"
                              : (widget.isGarden
                                          ? widget.garden.fertility.color
                                          : widget.needle.fertility.color) ==
                                      'yellow'
                                  ? "images/fertility-yellow-big.png"
                                  : "images/fertility-green-big.png",
                          width: 30,
                          height: 30,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 0, top: 5, right: 0, bottom: 0),
                          child: Text(
                            widget.isGarden
                                ? widget.garden.fertility.avg.toString()
                                : widget.needle.fertility.avg.toString() +
                                    "ds/m",
                            style: new TextStyle(
                                color: (widget.isGarden
                                            ? widget.garden.fertility.color
                                            : widget.needle.fertility.color) ==
                                        'red'
                                    ? Color(0xffF36649)
                                    : (widget.isGarden
                                                ? widget.garden.fertility.color
                                                : widget
                                                    .needle.fertility.color) ==
                                            'yellow'
                                        ? Color(0xffFDCA3E)
                                        : Color(0xff7ED321)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Ink(
              padding:
              EdgeInsets.only(left: 0, top: 8, right: 0, bottom: 10),
              color:
                  selectedIndex == 3 ? Color(0xfff3f3f3) : Colors.transparent,
              child: InkWell(
                onTap: widget.onClick3,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Offstage(
                      offstage:
                          !widget.isGarden || widget.garden.power.count == 0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                left: 30, top: 0, right: 0, bottom: 0),
                            width: 18,
                            height: 18,
                            child: FlatButton(
                              onPressed: () {},
                              child: Text(""),
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.red),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(9))),
                            ),
                            alignment: Alignment.center,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 30, top: 0, right: 0, bottom: 0),
                            child: Text(
                              widget.isGarden
                                  ? (widget.garden.power.count > 99
                                      ? "99+"
                                      : widget.garden.power.count.toString())
                                  : "",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 8),
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Image.asset(
                          (widget.isGarden
                                      ? widget.garden.power.color
                                      : widget.needle.power.color) ==
                                  'red'
                              ? "images/power-red-big.png"
                              : (widget.isGarden
                                          ? widget.garden.power.color
                                          : widget.needle.power.color) ==
                                      'yellow'
                                  ? "images/powerr-yellow-big.png"
                                  : "images/power-green-big.png",
                          width: 30,
                          height: 30,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 0, top: 5, right: 0, bottom: 0),
                          child: Text(
                            (widget.isGarden
                                    ? widget.garden.power.avg.toString()
                                    : widget.needle.power.avg.toString()) +
                                "%",
                            style: new TextStyle(
                                color: (widget.isGarden
                                            ? widget.garden.power.color
                                            : widget.needle.power.color) ==
                                        'red'
                                    ? Color(0xffF36649)
                                    : (widget.isGarden
                                                ? widget.garden.power.color
                                                : widget.needle.power.color) ==
                                            'yellow'
                                        ? Color(0xffFDCA3E)
                                        : Color(0xff7ED321)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Ink(
              padding:
              EdgeInsets.only(left: 0, top: 8, right: 0, bottom: 10),
              color:
              selectedIndex == 4 ? Color(0xfff3f3f3) : Colors.transparent,
              child: InkWell(
                onTap: widget.onClick4,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      "images/temperature-green-big.png",
                      width: 30,
                      height: 30,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 0, top: 5, right: 0, bottom: 0),
                      child: Text(
                          widget.isGarden
                              ? widget.garden.temperature.avg.toString()
                              : widget.needle.temperature.avg.toString() +
                              "℃",
                          style: new TextStyle(color: Color(0xff7ED321))),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
