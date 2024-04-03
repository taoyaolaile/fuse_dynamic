import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_dynamic/attribute/attribute_handler.dart';
import 'package:test_dynamic/attribute/input_widget_strategy.dart';
import 'package:test_dynamic/model/widget_attribute.dart';
import 'package:test_dynamic/tool/tool.dart';

///文件作者 ：陈涛(Ann)
///文件名字 ：set_attribute_page
///创建日期 ：2024/3/14
///文件描述 ：
///修改的人 :
///修改时间 ：
///修改备注 ：

class SetAttributePage extends StatelessWidget {
  WidgetAttribute? attribute;
  WidgetAttribute parentAttr;
  Function(WidgetAttribute attributes,String widgetKey) callBackUI;
  SetAttributePage(this.parentAttr,this.attribute,this.callBackUI, {super.key});

  @override
  Widget build(BuildContext context) {
    if (attribute != null) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: showAttributeList(attribute!.toMap(),[]),
        ),
      );
    } else {
      return Container();
    }
  }

  //展示属性
  List<Widget> showAttributeList(Map<String, dynamic> attrMap,List<String> keysList) {
    List<Widget> widgets = [];
    //存所有上级的keys
    attrMap.forEach((key, value) {

      if(key!='children' && key!='child' && key!="body")
      {
        if (value is Map<String, dynamic>) {
          keysList.add(key);
          var list = showAttributeList(value,keysList);
          list.insert(0, Text(key,
            style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w600),
          ));
          widgets.add(Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            padding:
            const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: [
                  BoxShadow(color: Colors.grey, blurRadius: 2, spreadRadius: 1)
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: list,
            ),
          ));
        } else if (value is List<Map<String, dynamic>>) {
          //属性是一个列表
          keysList.add(key);
          for(int i =0;i<value.length;i++){
            keysList.add(i.toString());
            var list = showAttributeList(value[i],keysList );
            list.insert(0, Text(key,
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ));
            widgets.add(Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(color: Colors.grey, blurRadius: 2, spreadRadius: 1)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: list,
              ),
            ));
          }

        } else {
          widgets.add(ShowAttributeWidget(key, value,keysList,(selectKey,selectValue,keysList){
            if( keysList.isNotEmpty&& keysList.last!=selectKey){
              keysList.add(selectKey);
            }
            attrMap[selectKey] = selectValue;
            //替换树中对应的控件
            if(attribute!=null){
              // modifyAttribute(parentAttr.toMap(),attrMap);
              if(attrMap.containsKey("key"))
              {
                //如果attrMap 是一个控件 就替换整个控件
                var map = Tool().syncWidgetTree(parentAttr.toMap(),attrMap, key: attrMap["key"]);
                parentAttr = ScaffoldAttribute.fromJson(map);
                parentAttr.toMap();
                callBackUI.call(parentAttr, attrMap["key"]);
              }else{
                callBackUI.call(parentAttr,attribute!.key);
              }
            }

          }));
        }
      }
    });
    return widgets;
  }
  //修改控件
  modifyAttribute(Map<String, dynamic> parentMap,Map<String, dynamic> attrMap) {
    if(parentMap["key"] == attrMap["key"]){
       parentMap = attrMap;
       return parentMap;
    }else{

    }
  }
  //修改控件的
}

class ShowAttributeWidget extends StatelessWidget {
  String title;
  dynamic value;
  List<String> keysList;
  Function (String selectKey,dynamic selectValue,List<String> keysList)  callback;
  ShowAttributeWidget(this.title, this.value,this.keysList,this.callback, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 10,
          ),
          if (title == "key" || title == "widgetType")
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                value.toString(),
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          getWidget(context,value),
        ],
      ),
    );
  }

  //判断类型 枚举不能输入只能下啦选中
  Widget getWidget(BuildContext context,dynamic value) {
    //第一：判断一些属性是枚举类型：下来选中
    //第二：属性为枚举和自己填写
    //第三：属性为自己填写
    if (title == "fontWeight" ||
        title == "fontStyle" ||
        title == "mainAxisAlignment" ||
        title == "crossAxisAlignment" ||
        title == "mainAxisSize" ||
        title == "textDirection" ||
        title == "verticalDirection" ||
        title == "textBaseline" ||
        title == "direction" ||
        title == "clipBehavior") {
      Map<String, String> mapAttr = AttributeUtils().getAttribute(title);
      return ShowEnumWidget(mapAttr, value!=null?value.toString():"", (selectValue) {
        callback.call(title,selectValue,keysList);
      });
    } else if(title == "width" ||
              title == "height" ||
              title == "color" ||
              title == "fontSize" ||
              title == "backgroundColor" ||
              title == "border" ||
              title == "margin" ||
              title == "padding" ||
              title == "borderRadius" ||
              title == "border"
    ){
      //需要用户自己填写
      return InputWidgeUtil().getWidget(context,title, value, (inputKey,value){
        callback.call(title,value,keysList);
      })??Container();
    }else{
      return Container();
    }
  }
}

class ShowEnumWidget extends StatefulWidget {
  Map<String, String> mapAttr;
  String selectKey;
  Function(String selectValue) callback;

  ShowEnumWidget(this.mapAttr, this.selectKey, this.callback, {super.key});

  @override
  State<ShowEnumWidget> createState() => _ShowEnumWidgetState();
}

class _ShowEnumWidgetState extends State<ShowEnumWidget> {
  List<String> attrkeys = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    attrkeys = widget.mapAttr.keys.toList();
  }

  String defaultValue = "";
  bool isShowAttriList = false;

  @override
  Widget build(BuildContext context) {
    if (widget.selectKey != null &&
        widget.selectKey.isNotEmpty &&
        widget.mapAttr.containsKey(widget.selectKey)) {
      defaultValue = widget.mapAttr[widget.selectKey]!;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        //默认
        GestureDetector(
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  defaultValue.isNotEmpty ? defaultValue : "请选择",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              Icon(isShowAttriList ? Icons.keyboard_arrow_down_outlined : Icons
                  .keyboard_arrow_up_outlined, color: Colors.grey, size: 25,)
            ],
          ),
          onTap: () {
            //打开列表
            setState(() {
              isShowAttriList = !isShowAttriList;
            });
          },
        ),
        const SizedBox(height:10),
        AnimatedContainer(duration: const Duration(seconds: 1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: _getAttrList(),
          ),
        )
      ],
    );
  }

  //展示每一个item
  List<Widget> _getAttrList() {
    List<Widget> list = [];
    if(isShowAttriList)
    {
      widget.mapAttr.forEach((key, value) {
        list.add(ShowAttributeItemWidget(widget.selectKey, key, value, (itemKey) {
          setState(() {
            widget.selectKey = itemKey;

          });
          widget.callback.call(widget.selectKey);
        }));
      });
    }
    return list;
  }
}


class ShowAttributeItemWidget extends StatelessWidget {
  String selectKey;
  String itemKey;
  String value;
  Function (String itemKey) onTap;
  ShowAttributeItemWidget(this.selectKey,this.itemKey, this.value,this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.only(left: 10,right: 10,top: 13,bottom: 13),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey,blurRadius: 1,spreadRadius: 1,offset: Offset(0, 0))
          ]
        ),
        child: Flex(direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(flex: 1,child: Text(value,style: const TextStyle(fontSize: 13,color: Colors.black87),),),
            if(itemKey ==selectKey)
              const Icon(Icons.check,color: Colors.red,size: 15,)
          ],
        ),
      ),
      onTap:(){
        onTap.call(itemKey);
      },
    );
  }
}


