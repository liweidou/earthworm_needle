import 'package:earthworm_needle/common/Global.dart';
import 'package:flutter/material.dart';

class HorizontalPickerView extends StatefulWidget {
  HorizontalPickerViewState state;
  Function onSelected;

  HorizontalPickerView(List<HorizontalPickerItemBean> list, int size, int today,
      Function onSelected) {
    state = HorizontalPickerViewState(list, size, today);
    this.onSelected = onSelected;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return state;
  }

  setDatas(List<HorizontalPickerItemBean> list, int size, int selectedDay) {
    state.setState(() {
      state.setDatas(list, size, selectedDay);
    });
  }

  int getSelected() {
    return state.currentSelected;
  }
}

class HorizontalPickerViewState extends State<HorizontalPickerView> {
  int selectSize = 1;
  List<HorizontalPickerItemBean> datalist;
  ScrollController scrollController = new ScrollController();
  int currentSelected = 0, perSelected = -1;
  bool isFirst = true;

  HorizontalPickerViewState(
      List<HorizontalPickerItemBean> list, int size, int today) {
    datalist = list;
    selectSize = size;
    currentSelected = today;
  }

  setDatas(List<HorizontalPickerItemBean> list, int size, int selectedDay) {
    currentSelected = selectedDay;
    if (size == 1) {
      for (var i = 0; i < this.datalist.length; i++) {
        datalist[i].isSelected = currentSelected == i;
      }
    } else {
      for (var i = 0; i < this.datalist.length; i++) {
        datalist[i].isSelected =
            i < currentSelected + 7 && i >= currentSelected;
      }
    }
    setState(() {
      datalist = list;
      selectSize = size;
    });
    scrollController.animateTo(
        double.parse((currentSelected * 30).toString()),
        duration: Duration(milliseconds: 300),
        curve: Curves.linear);
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      currentSelected = scrollController.position.pixels ~/ 30;
      for (var i = 0; i < this.datalist.length; i++) {
        if (i < currentSelected + selectSize && i >= currentSelected) {
          this.datalist[i].isSelected = true;
        } else {
          this.datalist[i].isSelected = false;
        }
      }
      setState(() {
        datalist = datalist;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isFirst)
      Future.delayed(Duration(milliseconds: 300), () {
        scrollController.animateTo(
            double.parse((currentSelected * 30).toString()),
            duration: Duration(milliseconds: 300),
            curve: Curves.linear);
        isFirst = false;
      });
    return Listener(
      onPointerUp: (event) {
        scrollController.animateTo(
            double.parse((currentSelected * 30).toString()),
            duration: Duration(milliseconds: 300),
            curve: Curves.linear);
        if (perSelected != currentSelected) {
          if (widget != null && widget.onSelected != null) widget.onSelected();
          perSelected = currentSelected;
        }
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        child: Row(
          children: <Widget>[
            ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, i) =>
                    HorizontalPickerItemView(datalist[i]),
                separatorBuilder: (context, i) => Divider(
                      height: 20,
                      color: Colors.white,
                    ),
                itemCount: datalist.length),
            SizedBox(
              height: 30,
              width: selectSize == 1 ? 210 : 30,
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalPickerItemView extends StatelessWidget {
  HorizontalPickerItemBean itemBean;

  HorizontalPickerItemView(HorizontalPickerItemBean bean) {
    itemBean = bean;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 30,
      height: 30,
      color: itemBean.isSelected ? Color(Global.colorAccent) : Color(0xfff3f3f3),
      alignment: Alignment.center,
      child: Text(
        itemBean.text,
        textAlign: TextAlign.center,
        style:
            TextStyle(color: itemBean.isSelected ? Colors.white : Colors.black),
      ),
    );
  }
}

class HorizontalPickerItemBean {
  bool isSelected;
  String text;

  HorizontalPickerItemBean(this.isSelected, this.text);
}
