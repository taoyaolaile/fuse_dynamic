import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:test_dynamic/analysis_widget.dart';
import 'package:test_dynamic/bean/attribute_bean.dart';
import 'package:test_dynamic/extension/attribute_ext.dart';
import 'package:test_dynamic/extension/string_ext.dart';
import 'package:test_dynamic/main.dart';
import 'package:test_dynamic/model/widget_attribute.dart';
import 'package:test_dynamic/popup/pop_bottom_window.dart';
import 'package:test_dynamic/popup/pop_middle_window.dart';
import 'package:test_dynamic/tool/tool.dart';

///文件作者 ：陈涛(Ann)
///文件名字 ：widget_navigation
///创建日期 ：2024/3/8
///文件描述 ：
///修改的人 :
///修改时间 ：
///修改备注 ：
final random = Random();

class WidgetNavigation extends StatefulWidget {
  //父widget
  WidgetAttribute attributes;
  Function(Map<String, dynamic> uiMap,WidgetAttribute attributes) callBackUI;
  Function(WidgetAttribute attribute,WidgetAttribute childAttribute) callBackSelected;

  WidgetNavigation({super.key,required this.attributes, required this.callBackUI,required this.callBackSelected});

  @override
  State<WidgetNavigation> createState() => _WidgetNavigationState();
}

class _WidgetNavigationState extends State<WidgetNavigation> {
  List<WidgetAttribute> titles = [];

  //子widget 可能是一个child  也可能是一个children
  List<dynamic> attributes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.attributes.isChild()) {
      attributes = [widget.attributes.toAttributeChild()];
    } else if (widget.attributes.isChildren()) {
      attributes = widget.attributes.toAttributeChildren();
    }
    titles.add(widget.attributes);
    eventBus.on().listen((event) {
      if (event is Map) {

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //显示父widget 信息,如果父widget 还是父widget 就在右边显示一个返回按钮
        WidgetTitleNavigation(
          titles,
          (attribute) {
            //返回上一层
            if (attribute != null) {
              if (titles.length > 1) {
                titles.removeLast();
              }
              var json = jsonEncode( widget.attributes.toMap());
              print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
              print(json);
              print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
              var ats = findParent(widget.attributes, titles.last.key);
              if (ats != null) {
                json = jsonEncode( ats.toMap());
                print("////////////////////////////////////////////////////////////////");
                print(json);
                print("////////////////////////////////////////////////////////////////");
                if (ats.isChild()) {
                  attributes = [ats.toAttributeChild()];
                } else if (ats.isChildren()) {
                  attributes = ats.toAttributeChildren();
                }
                setState(() {});
              }
            }
          },
          addWidget: (attr) {
            attributes.add(attr);
            modifyWidgetUITree();
            setState(() {});
          },
          modifyWidget: (widgetAttribute) {
            modifyWidget(widgetAttribute);
          },
        ),
        Expanded(
          flex: 1,
          child: ReorderableListView(
            onReorder: (int oldIndex, int newIndex) {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              var child = attributes.removeAt(oldIndex);
              attributes.insert(newIndex, child);
              //修改了排序也要同步给widget树
              modifyWidgetUITree();
              setState(() {});
            },
            children: attributes
                .map((item) => Container(
                      key: ValueKey(
                          (item.key ?? "") + random.nextInt(100000).toString()),
                      child: GestureDetector(
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(
                              left: 5, right: 5, top: 5, bottom: 5),
                          padding: const EdgeInsets.only(
                              left: 10, right: 30, top: 8, bottom: 8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              boxShadow: [
                                if (item.key == (AttributeBean().childAttr?.key??""))
                                  BoxShadow(
                                    color: Colors.red.withAlpha(90),
                                    blurRadius: 3,
                                    spreadRadius: 2,
                                  ),
                                if (item.key != (AttributeBean().childAttr?.key??""))
                                  BoxShadow(
                                    color: Colors.grey.withAlpha(90),
                                    blurRadius: 3,
                                    spreadRadius: 2,
                                  ),
                              ]),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  item.widgetType,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                              if ((item as WidgetAttribute).isChildren() || (item).isChild())
                                GestureDetector(
                                  child: const Padding(
                                    padding: EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                      top: 5,
                                      bottom: 5,
                                    ),
                                    child: Icon(
                                      Icons.keyboard_arrow_right_outlined,
                                      size: 25,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  onTap: () {
                                    if (item.isChildren() || item.isChild()) {
                                      titles.add(item);
                                      attributes = item.getChildren();
                                      setState(() {});
                                    }
                                  },
                                ),
                            ],
                          ),
                        ),
                        onTap: () {
                          //选中
                          AttributeBean().parentAttr = titles.last;
                          AttributeBean().childAttr = item;
                          widget.callBackSelected.call(titles.last,item);
                          setState(() {});
                        },
                        onLongPress: () {
                          //长按删除
                          deleteWidget(item);
                        },
                      ),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }



  //查找指定层
  //参数1 需要从哪一个集合里面去找
  //参数2 需要找哪一个key的上级
  WidgetAttribute? findParent(WidgetAttribute attr, String key) {
    if (attr.key == key) {
      return attr;
    } else if (attr.isChild()) {
      return findParent(attr.toAttributeChild(), key);
    } else if (attr.isChildren()) {
      for (WidgetAttribute child in attr.toAttributeChildren()) {
        if (child.key == key) {
          return child;
        } else {
          findParent(child, key);
        }
      }
    }
  }



  //弹出删除提示框
  deleteWidget(WidgetAttribute item) {
    PopMiddleWindow(context, (context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(25),
          decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  color: Colors.white30,
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("是否删除",
                  style: TextStyle(fontSize: 16, color: Colors.amber)),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        for (int i = 0; i < attributes.length; i++) {
                          if (attributes[i].key == item.key) {
                            attributes.removeAt(i);
                            break;
                          }
                        }
                        modifyWidgetUITree();
                        // var attr = titles.last;
                        // attr.changeChildren(attributes);
                        // var map = syncWidgetTree(widget.attributes.toMap(),attr.toMap());
                        // widget.callBackUI.call(map ?? {});
                        // if (map != null) {
                        //   var json = jsonEncode(map);
                        //   print(json);
                        // }
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "删除",
                        style: TextStyle(fontSize: 14, color: Colors.red),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "取消",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }, barrierDismissible: true)
        .showMiddleWindow();
  }

  //修改Widget
  modifyWidget(WidgetAttribute item) {
    //修改父widget
    //如果修改后的控件 有children 属性 不用提示直接替换
    //如果修改后的控件 没有children 属性，只有child属性 提示用户 是否保留一个子控件
    //如果修改后的控件 没有children 属性 没有child属性 提示用户再次确认修改，修改完成删除原有的
    if (item.isChildren()) {
      var lastAttr = titles.last;
      item.changeChildren(attributes);
      titles.removeLast();
      titles.add(item);
      var map = Tool().syncWidgetTree(widget.attributes.toMap(), item.toMap(),
          key: lastAttr.key);
      widget.attributes = ScaffoldAttribute.fromJson(map);
      widget.callBackUI.call(map ?? {},widget.attributes);
      if (map != null) {
        var json = jsonEncode(map);
        print(json);
      }
      setState(() {});
    } else if (item.isChild()) {
      modifyPop((att) {
        setState(() {
          var lastAttr = titles.last;
          if(att!=null){
            item.changeChild(att);
          }
          titles.removeLast();
          titles.add(item);
          attributes = item.getChildren();
          var map = Tool().syncWidgetTree(widget.attributes.toMap(), item.toMap(), key: lastAttr.key);
          widget.attributes = ScaffoldAttribute.fromJson(map);
          widget.callBackUI.call(map ?? {},widget.attributes);
          if (map != null) {
            var json = jsonEncode(map);
            print(json);
          }
        });
      }, atts: attributes);
    } else {
      modifyPop((att) {
        //先返回上一层
        var lastKey = titles.last.key;
        if (titles.length > 1) {
          titles.removeLast();
        }
        var map = Tool().syncWidgetTree(widget.attributes.toMap(), item.toMap(),
            key: lastKey);
        widget.attributes = ScaffoldAttribute.fromJson(map);
        var ats = findParent(widget.attributes, titles.last.key);
        if (ats != null) {
          if (ats.isChild()) {
            attributes = [ats.toAttributeChild()];
          } else if (ats.isChildren()) {
            attributes = ats.toAttributeChildren();
          }
        }
        widget.callBackUI.call(map ?? {},widget.attributes);
        if (map != null) {
          var json = jsonEncode(map);
          print(json);
        }
        setState(() {});
      });
    }
  }

  //修改UI树
  modifyWidgetUITree() {
    WidgetAttribute att = titles.last;
    if (att.isChildren()) {
      att.changeChildren(attributes);
    }
    var map = Tool().syncWidgetTree(widget.attributes.toMap(), att.toMap());
    widget.callBackUI.call(map ?? {},widget.attributes);
    if (map != null) {
      var json = jsonEncode(map);
      print(json);
    }
    return map;
  }

  modifyPop(Function(dynamic att) callback, {List<dynamic>? atts}) {
    if (atts == null) {
      PopMiddleWindow(context, (context) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.all(25),
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    color: Colors.white30,
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("是否直接替换，如果替换将丢失下级所有控件",
                    style: TextStyle(fontSize: 16, color: Colors.amber)),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          callback.call(null);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "确定",
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "取消",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }, barrierDismissible: true)
          .showMiddleWindow();
    } else {
      int? selectIndex;
      PopBottomWindow(contentWidget: (context, setDialogState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
              child: Text("替换控件可以选中保留其中一个，如果不选择默认将会全部删掉",
                  style: TextStyle(fontSize: 16, color: Colors.amber)),
            ),
            GridView.builder(
              itemBuilder: (ctx, index) {
                var attr = atts[index] as WidgetAttribute;
                var strategy = attr.attributeToStrategy();
                if (strategy != null) {
                  var widgetStrategy = AttributeToWidget(strategy);
                  Widget widgetUI = widgetStrategy.change(attr);
                  return GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: (selectIndex??-1) == index
                                    ? Colors.red
                                    : Colors.grey,
                                blurRadius: 2,
                                spreadRadius: 2)
                          ]),
                      child: widgetUI,
                    ),
                    onTap: () {
                      if (setDialogState != null) {
                        setDialogState(() {
                          if(selectIndex==index){
                            selectIndex=null;
                          }
                         else{
                            selectIndex = index;
                          }
                        });
                      }
                    },
                  );
                } else {
                  return Container();
                }
              },
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
              ),
              itemCount: atts.length,
            )
          ],
        );
      }).showWindow(context,
          right: GestureDetector(
            child: const Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Text(
                "确定",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            onTap: () {
              if(selectIndex!=null && selectIndex!>=0&& atts!=null)
              {
                callback.call(atts[selectIndex!]);
              }else{
                callback.call(null);
              }
              Navigator.pop(context);
            },
          ));
    }
  }
}

class WidgetTitleNavigation extends StatelessWidget {
  List<WidgetAttribute> titles = [];
  Function(WidgetAttribute) back;
  Function(WidgetAttribute) addWidget;
  Function(WidgetAttribute) modifyWidget;

  WidgetTitleNavigation(this.titles, this.back,
      {required this.addWidget, required this.modifyWidget, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (titles.length > 1)
            GestureDetector(
              child: const Padding(
                padding: EdgeInsets.only(left: 5, right: 10, top: 5, bottom: 5),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.red,
                  size: 20,
                ),
              ),
              onTap: () {
                back.call(titles.last);
              },
            ),
          Expanded(
              child: Text(
            titles.last.widgetType,
            style: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700),
            textAlign: TextAlign.start,
          )),
          if (titles.last.isChildren() ||
              (titles.last.isChild() && titles.last.toAttributeChild() == null))
            GestureDetector(
              child: const Padding(
                padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 25,
                ),
              ),
              onTap: () {
                //添加child 或者children
                //只有child 为null 或者有children 属性的控件才会添加
                popWindow(context);
              },
            ),
          //修改
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.only(left: 15, right: 10, top: 5, bottom: 5),
              child: Icon(
                Icons.mode,
                color: Colors.black,
                size: 20,
              ),
            ),
            onTap: () {
              //添加child 或者children
              //只有child 为null 或者有children 属性的控件才会添加
              popWindow(context, isModify: true);
            },
          ),
        ],
      ),
    );
  }

  popWindow(BuildContext context, {bool isModify = false}) {
    var window = showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (ctx, setState) {
              return ListView(
                children: [
                  getPopListItem(
                      context,
                      ScaffoldAttribute(
                          key: "ScaffoldAttribute${random.nextInt(100000)}"),
                      isModify),
                  getPopListItem(
                      context,
                      RowAttribute(
                          key: "RowAttribute${random.nextInt(100000)}"),
                      isModify),
                  getPopListItem(
                      context,
                      ColumnAttribute(
                          key: "ColumnAttribute${random.nextInt(100000)}"),
                      isModify),
                  getPopListItem(
                      context,
                      FlexAttribute(
                          key: "FlexAttribute${random.nextInt(100000)}",
                          direction: "vertical"),
                      isModify),
                  getPopListItem(
                      context,
                      ContainerAttribute(
                        key: "ContainerAttribute${random.nextInt(100000)}",
                      ),
                      isModify),
                  getPopListItem(
                      context,
                      TextAttribute(
                          key: "TextAttribute${random.nextInt(100000)}",
                          text: "Text"),
                      isModify),
                  getPopListItem(
                      context,
                      TextFieldAttribute(
                          key: "TextFieldAttribute${random.nextInt(100000)}",
                          text: "Text"),
                      isModify),
                ],
              );
            },
          );
        });
  }

  Widget getPopListItem(
      BuildContext context, WidgetAttribute attribute, bool isModify) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        child: Text(
          attribute.widgetType,
          style: const TextStyle(fontSize: 14, color: Colors.red),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        if (isModify) {
          modifyWidget.call(attribute);
        } else {
          addWidget.call(attribute);
        }
      },
    );
  }
}
