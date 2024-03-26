import 'package:test_dynamic/extension/map_ext.dart';

///文件作者 ：陈涛(Ann)
///文件名字 ：widget_attribute
///创建日期 ：2024/3/7
///文件描述 ：控件属性类，
///修改的人 :
///修改时间 ：
///修改备注 ：
class MapToAttribute {
  factory MapToAttribute() {
    _singleton ??= MapToAttribute._();
    return _singleton!;
  }

  MapToAttribute._();

  static MapToAttribute? _singleton;
  Map<String,dynamic>? toMap(dynamic value) {
    if(value is ScaffoldAttribute){
      return value.toMap();
    }else if(value is RowAttribute){
      return value.toMap();
    }else if(value is ColumnAttribute){
      return value.toMap();
    }else if(value is FlexAttribute){
      return value.toMap();
    }else if(value is ExpandedAttribute){
      return value.toMap();
    }else if(value is ContainerAttribute){
      return value.toMap();
    }else if(value is TextAttribute){
      return value.toMap();
    }else if(value is TextFieldAttribute){
      return value.toMap();
    }
  }
  WidgetAttribute? toAttribute(Map<String, dynamic>? attributes) {
    if(attributes==null){return null;}
    String widgetType = attributes["widgetType"];
    switch (widgetType) {
      case "Scaffold":
        return ScaffoldAttribute.fromJson(attributes);
      case "Row":
        return RowAttribute.fromJson(attributes);
      case "Column":
        return ColumnAttribute.fromJson(attributes);
      case "Flex":
        return FlexAttribute.fromJson(attributes);
      case "Expanded":
        return ExpandedAttribute.fromJson(attributes);
      case "Container":
        return ContainerAttribute.fromJson(attributes);
      case "Text":
        return TextAttribute.fromJson(attributes);
      case "TextField":
        return TextFieldAttribute.fromJson(attributes);
      default:
        return null;
    }
  }
}

class WidgetAttribute {
  String widgetType = "";
  String key = "";
  //是否选中
  bool selected = false;
  //是否展开下级 当下级属性是child 时候才会使用
  bool isShowchild = false;
  // 刷新状态,需要这个控件刷新就+1
  int loadNum=0;
  WidgetAttribute(
      {required this.widgetType, this.key = "", this.selected = false,this.isShowchild = false,this.loadNum=0});

  Map<String,dynamic>  toMap() {
    return {
      "widgetType": widgetType,
      "key": key,
      "loadNum":loadNum
    };
  }

  WidgetAttribute.fromJson(dynamic json) {
    key = json["key"] ?? "";
    widgetType = json['widgetType'];
    loadNum = json['loadNum']??0;
  }
  //获取控件所有属性
  Map<String,dynamic> getAttributes() {
     return {
       "widgetType": widgetType,
       "key": key,
       // "loadNum":loadNum
      };
  }
}

class ScaffoldAttribute extends WidgetAttribute {
  Map<String, dynamic>? appBar;
  dynamic body;
  String? backgroundColor;
  Map<String, dynamic>? bottomSheet;

  ScaffoldAttribute(
      {this.appBar,
      this.backgroundColor,
      this.bottomSheet,
      this.body,
      required key})
      : super(widgetType: "Scaffold", key: key);

  // this.floatingActionButton;
  // this.floatingActionButtonLocation;
  // this.floatingActionButtonAnimator;
  // this.persistentFooterButtons;
  // this.persistentFooterAlignment = AlignmentDirectional.centerEnd;
  // this.drawer;
  // this.onDrawerChanged;
  // this.endDrawer;
  // this.onEndDrawerChanged;
  // this.bottomNavigationBar;
  // this.bottomSheet;
  // this.backgroundColor;
  // this.resizeToAvoidBottomInset;
  // this.primary = true;
  // this.drawerDragStartBehavior = DragStartBehavior.start;
  // this.extendBody = false;
  // this.extendBodyBehindAppBar = false;
  // this.drawerScrimColor;
  // this.drawerEdgeDragWidth;
  // this.drawerEnableOpenDragGesture = true;
  // this.endDrawerEnableOpenDragGesture = true;
  // this.restorationId;
  @override
  Map<String,dynamic>  toMap() {
    // TODO: implement toMap
    return {
      ...super.toMap(),
      "appBar": appBar,
      "backgroundColor": backgroundColor,
      "bottomSheet": bottomSheet,
      "body": MapToAttribute().toMap(body),
    };
  }

  ScaffoldAttribute.fromJson(dynamic json) : super.fromJson(json) {
    appBar = json["appBar"];
    backgroundColor = json["backgroundColor"];
    bottomSheet = json["bottomSheet"];
    body = MapToAttribute().toAttribute(json["body"]);
  }

  @override
  Map<String, dynamic> getAttributes() {
    // TODO: implement getAttributes
    return {
      ...super.getAttributes(),
      "appBar": appBar,
      "backgroundColor": backgroundColor,
      "bottomSheet": bottomSheet,
    };
  }
}

class AppBarAttribute extends WidgetAttribute {
  String? title;
  String? centerTitle;
  String? backgroundColor;
  String? elevation;
  String? leading;
  String? actions;

  AppBarAttribute(
      {required key,
      this.title,
      this.centerTitle,
      this.backgroundColor,
      this.elevation,
      this.leading,
      this.actions})
      : super(widgetType: "AppBar", key: key);
}

class RowAttribute extends WidgetAttribute {
  String? mainAxisAlignment;
  String? mainAxisSize;
  String? crossAxisAlignment;
  String? textDirection;
  String? verticalDirection;
  String? textBaseline;
  List<dynamic>? children;

  RowAttribute(
      {required key,
      this.mainAxisAlignment,
      this.mainAxisSize,
      this.crossAxisAlignment,
      this.textDirection,
      this.verticalDirection,
      this.textBaseline,
      this.children})
      : super(widgetType: "Row", key: key);

  @override
  Map<String,dynamic>  toMap() {
    List<dynamic> list=[];
    final children = this.children;
    if(children!=null){
      for (var element in children) {
        list.add(MapToAttribute().toMap(element));
      }
    }
    return {
      ...super.toMap(),
      "mainAxisAlignment": mainAxisAlignment,
      "mainAxisSize": mainAxisSize,
      "crossAxisAlignment": crossAxisAlignment,
      "textDirection": textDirection,
      "verticalDirection": verticalDirection,
      "textBaseline": textBaseline,
      "children": list,
    };
  }

  RowAttribute.fromJson(dynamic json) : super.fromJson(json) {
    // TODO: implement fromJson

    mainAxisAlignment = json["mainAxisAlignment"];
    mainAxisSize = json["mainAxisSize"];
    crossAxisAlignment = json["crossAxisAlignment"];
    textDirection = json["textDirection"];
    verticalDirection = json["verticalDirection"];
    textBaseline = json["textBaseline"];
    children = json["children"]?.map((e) => MapToAttribute().toAttribute(e)).toList();
  }
  @override
  Map<String, dynamic> getAttributes() {
    // TODO: implement getAttributes
    return {
      ...super.getAttributes(),
      "mainAxisAlignment": mainAxisAlignment,
      "mainAxisSize": mainAxisSize,
      "crossAxisAlignment": crossAxisAlignment,
      "textDirection": textDirection,
      "verticalDirection": verticalDirection,
      "textBaseline": textBaseline,
    };
  }
}

class ColumnAttribute extends WidgetAttribute {
  String? mainAxisAlignment;
  String? mainAxisSize;
  String? crossAxisAlignment;
  String? textDirection;
  String? verticalDirection;
  String? textBaseline;
  List<dynamic>? children;

  ColumnAttribute(
      {required key,
      this.mainAxisAlignment,
      this.mainAxisSize,
      this.crossAxisAlignment,
      this.textDirection,
      this.verticalDirection,
      this.textBaseline,
      this.children})
      : super(widgetType: "Column", key: key);

  @override
  Map<String,dynamic>  toMap() {
    List<dynamic> list=[];
    final children = this.children;
    if(children!=null){
      for (var element in children) {
        list.add(MapToAttribute().toMap(element));
      }
    }
    return {
      ...super.toMap(),
      "mainAxisAlignment": mainAxisAlignment,
      "mainAxisSize": mainAxisSize,
      "crossAxisAlignment": crossAxisAlignment,
      "textDirection": textDirection,
      "verticalDirection": verticalDirection,
      "textBaseline": textBaseline,
      "children": list,
    };
  }

  ColumnAttribute.fromJson(dynamic json) : super.fromJson(json) {
    // TODO: implement fromJson

    mainAxisAlignment = json["mainAxisAlignment"];
    mainAxisSize = json["mainAxisSize"];
    crossAxisAlignment = json["crossAxisAlignment"];
    textDirection = json["textDirection"];
    verticalDirection = json["verticalDirection"];
    textBaseline = json["textBaseline"];
    children =json["children"]?.map((e) => MapToAttribute().toAttribute(e)).toList();
  }
  @override
  Map<String, dynamic> getAttributes() {
    // TODO: implement getAttributes
    return {
      ...super.getAttributes(),
      "mainAxisAlignment": mainAxisAlignment,
      "mainAxisSize": mainAxisSize,
      "crossAxisAlignment": crossAxisAlignment,
      "textDirection": textDirection,
      "verticalDirection": verticalDirection,
      "textBaseline": textBaseline,
    };
  }
}

class FlexAttribute extends WidgetAttribute {
  String? direction;
  String? mainAxisAlignment;

  String? mainAxisSize;

  String? crossAxisAlignment;

  String? textDirection;
  String? verticalDirection;

  String?
      textBaseline; // NO DEFAULT: we don't know what the text's baseline should be
  String? clipBehavior;

  List<dynamic>? children;

  FlexAttribute(
      {required key,
      required this.direction,
      this.mainAxisAlignment = "start",
      this.mainAxisSize = "max",
      this.crossAxisAlignment = "center",
      this.textDirection,
      this.verticalDirection = "down",
      this.textBaseline,
      this.clipBehavior = "none",
      this.children})
      : super(widgetType: "Flex", key: key);

  @override
  Map<String,dynamic>  toMap() {
    List<dynamic> list=[];
    final children = this.children;
    if(children!=null){
      for (var element in children) {
        list.add(MapToAttribute().toMap(element));
      }
    }
    return {
      ...super.toMap(),
      "direction": direction,
      "mainAxisAlignment": mainAxisAlignment,
      "mainAxisSize": mainAxisSize,
      "crossAxisAlignment": crossAxisAlignment,
      "textDirection": textDirection,
      "verticalDirection": verticalDirection,
      "textBaseline": textBaseline,
      "clipBehavior": clipBehavior,
      "children":list,
    };
  }

  FlexAttribute.fromJson(dynamic json) : super.fromJson(json) {
    mainAxisAlignment = json["mainAxisAlignment"];
    mainAxisSize = json["mainAxisSize"];
    crossAxisAlignment = json["crossAxisAlignment"];
    textDirection = json["textDirection"];
    verticalDirection = json["verticalDirection"];
    textBaseline = json["textBaseline"];
    clipBehavior = json["clipBehavior"];
    direction = json["direction"];
    children = json["children"]?.map((e) => MapToAttribute().toAttribute(e)).toList();
  }
  @override
  Map<String, dynamic> getAttributes() {
    // TODO: implement getAttributes
    return {
      ...super.getAttributes(),
      "direction": direction,
      "mainAxisAlignment": mainAxisAlignment,
      "mainAxisSize": mainAxisSize,
      "crossAxisAlignment": crossAxisAlignment,
      "textDirection": textDirection,
      "verticalDirection": verticalDirection,
      "textBaseline": textBaseline,
      "clipBehavior": clipBehavior,
    };
  }
}

class ExpandedAttribute extends WidgetAttribute {
  int? flex;
  dynamic child;

  ExpandedAttribute({required this.child, this.flex, required key})
      : super(widgetType: "Expanded", key: key);

  @override
  Map<String,dynamic>  toMap() {
    // TODO: implement toMap
    return {
      ...super.toMap(),
      "flex": flex,
      "child": MapToAttribute().toMap(child),
    };
  }

  ExpandedAttribute.fromJson(dynamic json) : super.fromJson(json) {
    flex = json["flex"];
    child = MapToAttribute().toAttribute( json["child"]);
  }
  @override
  Map<String, dynamic> getAttributes() {
    // TODO: implement getAttributes
    return {
      ...super.getAttributes(),
      "flex": flex,
    };
  }
}

class ContainerAttribute extends WidgetAttribute {
  String? alignment;
  Map<String, double>? padding;
  String? color;
  Map<String, dynamic>? decoration;
  Map<String, dynamic>? foregroundDecoration;
  double? width;
  double? height;
  Map<String, dynamic>? constraints;
  Map<String, double>? margin;

  // this.transform;
  // this.transformAlignment;
  dynamic  child;
  String? clipBehavior; // = Clip.none;
  ContainerAttribute(
      {this.color,
      this.decoration,
      this.foregroundDecoration,
      this.alignment,
      this.padding,
      this.margin,
      this.clipBehavior = "none",
      this.width,
      this.height,
      this.constraints,
      this.child,
      required key})
      : super(widgetType: "Container", key: key);

  @override
  Map<String,dynamic>  toMap() {
    // TODO: implement toMap
    return {
      ...super.toMap(),
      "color": color,
      "decoration": decoration,
      "foregroundDecoration": foregroundDecoration,
      "alignment": alignment,
      "padding": padding,
      "margin": margin,
      "clipBehavior": clipBehavior,
      "width": width,
      "height": height,
      "constraints": constraints,
      "child": MapToAttribute().toMap(child),
    };
  }

  ContainerAttribute.fromJson(dynamic json) : super.fromJson(json) {
    color = json["color"];
    decoration = json["decoration"];
    foregroundDecoration = json["foregroundDecoration"];
    alignment = json["alignment"];
    padding = json["padding"];
    margin = json["margin"];
    clipBehavior = json["clipBehavior"];
    width = json["width"];
    height = json["height"];
    constraints = json["constraints"];
    child =MapToAttribute().toAttribute( json["child"]);
  }

  @override
  Map<String, dynamic> getAttributes() {
    // TODO: implement getAttributes
    return {
      ...super.getAttributes(),
      "color": color,
      "decoration": decoration,
      "foregroundDecoration": foregroundDecoration,
      "alignment": alignment,
      "padding": padding,
      "margin": margin,
      "clipBehavior": clipBehavior,
      "width": width,
      "height": height,
      "constraints": constraints,
    };
  }
}

class TextAttribute extends WidgetAttribute {
  String? text;
  Map<String, dynamic>? style;

  TextAttribute({required this.text, this.style, required key})
      : super(widgetType: "Text", key: key);

  @override
  Map<String,dynamic>  toMap() {
    // TODO: implement toMap
    return {
      ...super.toMap(),
      "text": text,
      "style": style,
    };
  }

  TextAttribute.fromJson(dynamic json) : super.fromJson(json) {
    text = json["text"];
    style = json["style"];
  }
  @override
  Map<String, dynamic> getAttributes() {
    // TODO: implement getAttributes
    return {
      ...super.getAttributes(),
      "text": text,
      "style": style,
    };
  }
}

class TextFieldAttribute extends WidgetAttribute {
  String? text;
  Map<String, dynamic>? style;

  TextFieldAttribute({required this.text, this.style, required key})
      : super(widgetType: "TextField", key: key);

  @override
  Map<String,dynamic> toMap() {
    // TODO: implement toMap
    return {...super.toMap(), "text": text, "style": style};
  }

  TextFieldAttribute.fromJson(dynamic json) : super.fromJson(json) {
    text = json["text"];
    style = json["style"];
  }
  @override
  Map<String, dynamic> getAttributes() {
    // TODO: implement getAttributes
    return {
      ...super.getAttributes(),
      "text": text,
      "style": style,
    };
  }
}
