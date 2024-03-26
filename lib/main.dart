import 'dart:collection';
import 'dart:math';
import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'package:test_dynamic/analysis_widget.dart';
import 'package:test_dynamic/bean/attribute_bean.dart';
import 'package:test_dynamic/extension/attribute_ext.dart';
import 'package:test_dynamic/model/widget_attribute.dart';
import 'package:test_dynamic/navigation/widget_navigation.dart';
import 'package:test_dynamic/attribute/set_attribute_page.dart';
import 'package:test_dynamic/tool/event_bus.dart';

var eventBus = EventBus();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: DraggableSplitView(),
      // home: MyHomePage(
      //   title: "aaaaaa",
      // ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: widgetUI,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ColumnAttribute columnAttribute = ColumnAttribute(
            mainAxisAlignment: "center",
            crossAxisAlignment: "center",
            children: [TextAttribute(text: "test", key: "TextAttribute")],
            key: "ColumnAttribute",
          );
          ScaffoldAttribute attribute = ScaffoldAttribute(
              key: "ScaffoldAttribute",
              appBar: {"title": "test"},
              body: columnAttribute);
          // var map =  attribute.toMap();
          // var ss = ScaffoldAttribute.fromJson(map).body;

          var att = AttributeToWidget(ScaffoldStrategy());
          widgetUI = att.change(attribute);
          setState(() {});
        },
      ),
    );
  }

  Widget widgetUI = Center(
    child: Text("test"),
  );
}

class DraggableSplitView extends StatefulWidget {
  @override
  _DraggableSplitViewState createState() => _DraggableSplitViewState();
}

class _DraggableSplitViewState extends State<DraggableSplitView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  double dividerPosition = 0.8; // 初始位置在屏幕中间
  double dividerPosition2 = 0.2; // 初始位置在屏幕中间

  void onDragUpdate(BuildContext context, double delta) {
    var position = max(0.0,
        min(1.0, dividerPosition + delta / MediaQuery.of(context).size.width));
    if (position < 0.8 && position > 0.4) {
      setState(() {
        // 更新分隔线位置，确保它在 [0,1] 范围内
        dividerPosition = position;
      });
    }
  }

  void onDragUpdate2(BuildContext context, double delta) {
    var position = max(
        0.0,
        min(
            1.0,
            dividerPosition2 +
                delta / (MediaQuery.of(context).size.width * dividerPosition)));
    if (position < 0.8 && position > 0.2) {
      setState(() {
        // 更新分隔线位置，确保它在 [0,1] 范围内
        dividerPosition2 = position;
      });
    }
  }

  late TabController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ColumnAttribute columnAttribute = ColumnAttribute(
      children: [
        RowAttribute(key: "RowAttribut1", children: [
          TextAttribute(text: "test1", key: "TextAttribute1"),
          TextAttribute(text: "test12", key: "TextAttribute12"),
          TextAttribute(text: "test13", key: "TextAttribute13")
        ]),
        ColumnAttribute(key: "ColumnAttribute222", children: [
          TextAttribute(
              text: "test2",
              key: "TextAttribute2",
              style: {"fontSize": 14, "color": 0xFFC62828}),
          TextAttribute(
              text: "test22",
              key: "TextAttribute22",
              style: {"fontSize": 14, "color": 0xFFC62828}),
          TextAttribute(
              text: "test23",
              key: "TextAttribute23",
              style: {"fontSize": 14, "color": 0xFFC62828})
        ]),
      ],
      key: "ColumnAttribute",
    );
    attribute = ScaffoldAttribute(
        key: "ScaffoldAttribute",
        appBar: {"title": "test"},
        body: columnAttribute);

    var att = AttributeToWidget(ScaffoldStrategy());
    widgetUI = att.change(attribute);
    _controller = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  Widget widgetUI = const Center();
  late ScaffoldAttribute attribute;
  ScrollController scrollController = ScrollController();

  double attributeWidth = 300;
  double attributeHeight = 500;
  List<String> tabValues = ["父控件", "选中控件"];

  //返回当前选中的widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: WidgetNavigation(
              attributes: attribute,
              callBackUI: (map, attr) {
                //修改UI后回掉
                var strategy = ScaffoldAttribute.fromJson(map);
                if (strategy != null) {
                  var att = AttributeToWidget(ScaffoldStrategy());
                  setState(() {
                    widgetUI = att.change(strategy);
                    attribute = attr as ScaffoldAttribute;
                  });
                }
              },
              callBackSelected:
                  (WidgetAttribute attr, WidgetAttribute childAttr) {
                //返回选中的widget 和父widget
                tabValues = [attr.widgetType, childAttr.widgetType];
                setState(() {});
              },
            ),
          ),
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              print("details.delta.dx:${details.delta.dx}");
              onDragUpdate(context, -details.delta.dx);
            },
            child: Container(
              height: double.infinity,
              color: Colors.black.withOpacity(0.1),
              child: const Icon(Icons.drag_indicator),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * dividerPosition,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 70,
                        height: 100,
                        margin: const EdgeInsets.only(left: 15,right: 15),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.red,
                                  blurRadius: 1,
                                  spreadRadius: 1
                              )
                            ]
                        ),
                        child: Column(
                          children: [
                            Expanded(flex: 1,child: TextButton(onPressed: (){
                              setState(() {
                                isShowUI = true;
                              });
                            }, child: Text("UI",style: TextStyle(fontSize: 14,color:isShowUI? Colors.red:Colors.black),)),),
                            Expanded(flex: 1,child: TextButton(onPressed: (){
                              setState(() {
                                isShowUI = false;
                              });
                            }, child: Text("Code",style: TextStyle(fontSize: 14,color:isShowUI? Colors.black:Colors.red))),),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: AnimatedCrossFade(
                          firstChild: Center(
                            child: Container(
                              width: 412,
                              height: 915,
                              margin: const EdgeInsets.only(
                                  left: 15, right: 15, top: 15, bottom: 15),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 2,
                                        spreadRadius: 1)
                                  ]),
                              child: widgetUI,
                            ),
                          ),
                          secondChild: CodemirrorPage(MediaQuery.of(context).size.width * dividerPosition-100),
                          crossFadeState: isShowUI
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(seconds: 1),
                        ),
                      ),

                    ],
                  ),
                ),
                if (AttributeBean().parentAttr != null ||
                    AttributeBean().childAttr != null)
                  GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      print("details.delta.dx:${details.delta.dx}");
                      onDragUpdate2(context, -details.delta.dx);
                    },
                    child: Container(
                      height: double.infinity,
                      color: Colors.black.withOpacity(0.1),
                      child: const Icon(Icons.drag_indicator),
                    ),
                  ),
                //显示属性
                if (AttributeBean().parentAttr != null ||
                    AttributeBean().childAttr != null)
                  SizedBox(
                    width:
                        (MediaQuery.of(context).size.width * dividerPosition) *
                            dividerPosition2,
                    child: Column(
                      children: [
                        TabBar(
                          controller: _controller,
                          tabs: tabValues.map((e) {
                            return Text(e);
                          }).toList(),
                          isScrollable: false,
                          labelPadding:
                              const EdgeInsets.only(top: 10, bottom: 10),
                          indicatorColor: Colors.red,
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: Colors.red,
                          unselectedLabelColor: Colors.black,
                          indicatorWeight: 2.0,
                          labelStyle: const TextStyle(height: 2, fontSize: 15),
                          unselectedLabelStyle:
                              const TextStyle(height: 2, fontSize: 14),
                        ),
                        Flexible(
                          child: TabBarView(
                            controller: _controller,
                            children: [
                              SetAttributePage(
                                  attribute, AttributeBean().parentAttr,
                                  (attr, widgetKey) {
                                setState(() {
                                  AttributeBean().parentAttr =
                                      getWidgetByKey(attr, widgetKey);
                                  AttributeBean().parentAttr?.toMap();
                                  attribute = attr as ScaffoldAttribute;
                                  var att =
                                      AttributeToWidget(ScaffoldStrategy());
                                  widgetUI = att.change(attribute);
                                });
                              }),
                              SetAttributePage(
                                  attribute, AttributeBean().childAttr,
                                  (attr, widgetKey) {
                                setState(() {
                                  AttributeBean().childAttr =
                                      getWidgetByKey(attr, widgetKey);
                                  AttributeBean().childAttr?.toMap();
                                  attribute = attr as ScaffoldAttribute;
                                  var att =
                                      AttributeToWidget(ScaffoldStrategy());
                                  widgetUI = att.change(attribute);
                                });
                              }),
                              // PolicyListPage(isShowSigned:widget.isShowSigned),
                              // ChangeNotifierProvider(
                              //   create: (_) => QuoteListViewModel(),
                              //   child: QuoteListPage(isShowSigned: widget.isShowSigned,),
                              // )
                              // PolicyListPage(isShowSigned:widget.isShowSigned),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  //更具key 获取对应的widget
  WidgetAttribute? getWidgetByKey(WidgetAttribute attr, String key) {
    if (attr.key == key) {
      return attr;
    } else if (attr.isChildren()) {
      for (WidgetAttribute child in attr.getChildren()) {
        final foundAttr = getWidgetByKey(child, key);
        if (foundAttr != null) {
          return foundAttr;
        }
      }
    } else if (attr.isChild()) {
      return getWidgetByKey(attr.getChildren().first, key);
    }
  }

  bool isShowUI = true;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class CodemirrorPage extends StatefulWidget {
  double width = 800;
  CodemirrorPage(this.width,{super.key});

  @override
  State<CodemirrorPage> createState() => _CodemirrorPageState();
}

class _CodemirrorPageState extends State<CodemirrorPage> {
  DivElement? frame;
  @override
  void initState() {
    js.context["xxx_jsToFlutter"] = jsToFlutter;
    super.initState();

  }

  DivElement getFrame(){
    if(frame==null)
    {
      frame = DivElement();
      frame!.contentEditable = "true";
      IFrameElement iframe = IFrameElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..src = 'codemirror/assets/code.html'
        ..inputMode = 'text'
        ..id = 'codemirror_iframe'
        ..style.border = 'none';

      frame!.append(iframe);
    }
    return frame!;
  }

  @override
  Widget build(BuildContext context) {


    // iframe.isContentEditable;
    // //设置token
    // StyleElement sFrame = StyleElement();
    // String script = """localStorage.setItem('token',token)""";
    // sFrame.innerHtml = script;
    // frame.append(sFrame);
    //ignore: undefined_prefixed_name
    ui.platformViewRegistry
        .registerViewFactory('codemirror', (int viewId) => getFrame());
    return SingleChildScrollView(
      child: Row(
        children: [
          TextButton(onPressed: (){
            flutterTojs();
          }, child: Text("test",style: TextStyle(fontSize: 14),)),
          Container(
            width: widget.width -80,
            height: MediaQuery.of(context).size.height-50,
            child: HtmlElementView(
              viewType: 'codemirror',
            ),
          ),
        ],
      ),
    );
  }
  //监听代码输入回掉
  jsToFlutter(String code){
    print("////////////////////////////////");
    print(code);
    print("////////////////////////////////");
    if(code!=null){

    }
  }
  //给代码框传值
  flutterTojs(){

    js.context.callMethod('flutterToJs',["////////////////////////////////test////////////////////////////////"]);
  }
}

class MenuItem {
  String title;
  String? description;
  List<MenuItem> children;

  MenuItem({required this.title, this.description, this.children = const []});
}

class RecursiveMenu extends StatelessWidget {
  final MenuItem item;
  final Function(MenuItem) onItemSelected;

  RecursiveMenu({required this.item, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    if (item.children.isEmpty) {
      return Container(
        key: PageStorageKey<String>(item.title),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                item.title,
                style: const TextStyle(fontSize: 16, color: Colors.amber),
              ),
            ),
            IconButton(
              onPressed: () {
                item.children.add(MenuItem(title: item.title + 'New Item'));
              },
              icon: Icon(
                Icons.add,
                size: 20,
              ),
            ),
          ],
        ),
      );
    } else {
      return ExpansionTile(
          leading: GestureDetector(
            child: const Icon(Icons.add),
            onTap: () {},
          ),
          key: PageStorageKey<String>(item.title),
          title: Text(item.title),
          subtitle: Text(item.description ?? ''),
          children: item.children
              .map((childItem) => RecursiveMenu(
                    item: childItem,
                    onItemSelected: onItemSelected,
                  ))
              .toList());
    }
  }
}

//底部弹出窗

// //定义
// class TreeModel {}
//
// class ListMenuWidget extends StatefulWidget {
//   const ListMenuWidget({super.key});
//
//   @override
//   State<ListMenuWidget> createState() => _ListMenuWidgetState();
// }
//
// class _ListMenuWidgetState extends State<ListMenuWidget> {
//   List<String> items = [];
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     items.add("1");
//     items.add("2");
//     items.add("1");
//     items.add("2");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ReorderableListView.builder(
//       onReorder: (int oldIndex, int newIndex) {
//         if (oldIndex < newIndex) {
//           newIndex -= 1;
//         }
//         var child = items.removeAt(oldIndex);
//         items.insert(newIndex, child);
//         setState(() {});
//       },
//       itemBuilder: (BuildContext context, int index) {
//         return Container(
//           key: ValueKey(items[index]),
//           height: 100,
//           margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
//           decoration: BoxDecoration(
//               color: Colors
//                   .amber,
//               borderRadius: BorderRadius.circular(10)),
//         );
//       },
//       itemCount: items.length,
//     );
//   }
// }
