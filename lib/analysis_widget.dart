import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_dynamic/extension/map_ext.dart';
import 'package:test_dynamic/model/widget_attribute.dart';
import 'package:test_dynamic/tool/tool.dart';

///文件作者 ：陈涛(Ann)
///文件名字 ：analysis_widget
///创建日期 ：2024/3/8
///文件描述 ：将WidgetAttribute 对象 解析成为 Widget 对象
///修改的人 :
///修改时间 ：
///修改备注 ：
class AttributeToStrategy {
  factory AttributeToStrategy() {
    _singleton ??= AttributeToStrategy._();
    return _singleton!;
  }

  AttributeToStrategy._();

  static AttributeToStrategy? _singleton;
  WidgetStrategy? toStrategy(WidgetAttribute attribute){
      if(attribute is ScaffoldAttribute){
        return ScaffoldStrategy();
      } else if(attribute is TextAttribute){
        return TextStrategy();
      } else if(attribute is RowAttribute){
        return RowStrategy();
      } else if(attribute is ColumnAttribute){
        return ColumnStrategy();
      }else if(attribute is FlexAttribute){
        return FlexStrategy();
      }

      return null;
  }
}
typedef WidgetStrategyCallback = WidgetAttribute Function(WidgetAttribute attribute);
abstract class WidgetStrategy {
  Widget mapToWidget(BuildContext context,WidgetAttribute attribute);

}

class AttributeToWidget {
  final WidgetStrategy widgetStrategy;

  AttributeToWidget(this.widgetStrategy);

  Widget change(BuildContext context,WidgetAttribute attribute) {
    return widgetStrategy.mapToWidget(context,attribute);
  }

}

class ScaffoldStrategy extends WidgetStrategy {
  Widget? scaffold;
  late ScaffoldAttribute scaffoldAttribute;
  @override
  Widget mapToWidget(BuildContext context,WidgetAttribute attribute) {
    scaffoldAttribute = attribute as ScaffoldAttribute;
      return getWidget(context);
  }

  Widget getWidget(BuildContext context){

    Map<String, dynamic> data = scaffoldAttribute.toMap();
    var strategy = AttributeToStrategy().toStrategy(scaffoldAttribute.body);
    Widget? body;
    if(strategy!=null){
      AttributeToWidget attributeToWidget = AttributeToWidget(strategy);
      body =attributeToWidget.change(context,scaffoldAttribute.body);
    }
    scaffold = Scaffold(
      appBar: getAppBar(data),
      body:  body,
    );
    return scaffold!;
  }

  AppBar? getAppBar(Map<String, dynamic> appBar) {
    if (appBar.containsKey('appBar')) {
      String title = MapExt().getValue(appBar['appBar'],"title",defaultValue:"");
      return AppBar(
        title: Text(title,style: const TextStyle(fontSize: 16,color: Colors.white),),
        backgroundColor: Colors.red,
      );
    } else {
      return null;
    }
  }




}

class RowStrategy extends WidgetStrategy {
  late Widget row;
  late RowAttribute rowAttribute;
  @override
  Widget mapToWidget(BuildContext context,WidgetAttribute attribute) {
    rowAttribute = attribute as RowAttribute;
    return getWidget(context);
  }
  Widget getWidget(BuildContext context) {
    Map<String, dynamic> data = rowAttribute.toMap();
    List<Map<String, dynamic>> children = MapExt().getValueListMap(data,"children",defaultValue: []);
    List<Widget> widgets =[];
    if(children.isNotEmpty){
      for (var element in children) {
        var elementAttr = MapToAttribute().toAttribute(element);
        if(elementAttr!=null)
        {
          var strategy = AttributeToStrategy().toStrategy(elementAttr);
          if(strategy!=null){
            AttributeToWidget attributeToWidget = AttributeToWidget(strategy);
            widgets.add(attributeToWidget.change(context,elementAttr));
          }
        }

      }
    }
    row = Row(
      mainAxisAlignment: Tool().getMainAxisAlignment(MapExt().getValue(data,"mainAxisAlignment",defaultValue: "")),
      crossAxisAlignment: Tool().getCrossAxisAlignment(MapExt().getValue(data,"crossAxisAlignment",defaultValue: "")),
      mainAxisSize: Tool().getMainAxisSize(MapExt().getValue(data,"mainAxisSize",defaultValue: "")),
      textDirection: Tool().getTextDirection(MapExt().getValue(data,"textDirection",defaultValue: "")),
      verticalDirection: Tool().getVerticalDirection(MapExt().getValue(data,"verticalDirection",defaultValue: "")),
      textBaseline: Tool().getTextBaseline(MapExt().getValue(data,"textBaseline",defaultValue: "")),
      children: widgets,
    );
    return row;
  }


}

class ColumnStrategy extends WidgetStrategy {
  late Widget column;
  late ColumnAttribute columnAttribute;
  @override
  Widget mapToWidget(BuildContext context,WidgetAttribute attribute) {
    columnAttribute = attribute as ColumnAttribute;
    return getWidget(context);
  }

  Widget getWidget(BuildContext context) {
    Map<String, dynamic> data = columnAttribute.toMap();
    List<Map<String, dynamic>> children = MapExt().getValueListMap(data,"children",defaultValue: []) ;
    List<Widget> widgets =[];
    if(children.isNotEmpty){
      for (var element in children) {
        var elementAttr = MapToAttribute().toAttribute(element);
        if(elementAttr!=null)
        {
          var strategy = AttributeToStrategy().toStrategy(elementAttr);
          if(strategy!=null){
            AttributeToWidget attributeToWidget = AttributeToWidget(strategy);
            widgets.add(attributeToWidget.change(context,elementAttr));
          }
        }

      }
    }
    column = Column(
      crossAxisAlignment: Tool().getCrossAxisAlignment(MapExt().getValue(data,"crossAxisAlignment",defaultValue: "")),
      mainAxisAlignment: Tool().getMainAxisAlignment(MapExt().getValue(data,"mainAxisAlignment",defaultValue: "")),
      mainAxisSize: Tool().getMainAxisSize(MapExt().getValue(data,"mainAxisSize",defaultValue: "")),
      textDirection: Tool().getTextDirection(MapExt().getValue(data,"textDirection",defaultValue: "")),
      verticalDirection: Tool().getVerticalDirection(MapExt().getValue(data,"verticalDirection",defaultValue: "")),
      textBaseline: Tool().getTextBaseline(MapExt().getValue(data,"textBaseline",defaultValue: "")),
      children: widgets,
    );
    return column;
  }

}

class FlexStrategy extends WidgetStrategy {
  late Widget flex;
  late FlexAttribute flexAttribute;
  @override
  Widget mapToWidget(BuildContext context,WidgetAttribute attribute) {
    flexAttribute = attribute as FlexAttribute;
    return getWidget(context);
  }
  Widget getWidget(BuildContext context) {
    Map<String, dynamic> data = flexAttribute.toMap();
    List<Map<String, dynamic>> children = MapExt().getValueListMap(data,"children",defaultValue: []);
    List<Widget> widgets =[];
    if(children.isNotEmpty){
      for (var element in children) {
        var elementAttr = MapToAttribute().toAttribute(element);
        if(elementAttr!=null)
        {
          var strategy = AttributeToStrategy().toStrategy(elementAttr);
          if(strategy!=null){
            AttributeToWidget attributeToWidget = AttributeToWidget(strategy);
            widgets.add(attributeToWidget.change(context,elementAttr));
          }
        }

      }
    }
    flex  = Flex(
      direction: Tool().getFlexDirection(MapExt().getValue(data,"direction",defaultValue: "")),
      mainAxisAlignment: Tool().getMainAxisAlignment(MapExt().getValue(data,"mainAxisAlignment",defaultValue: "")),
      mainAxisSize: Tool().getMainAxisSize(MapExt().getValue(data,"mainAxisSize",defaultValue: "")),
      textDirection: Tool().getTextDirection(MapExt().getValue(data,"textDirection",defaultValue: "")),
      verticalDirection: Tool().getVerticalDirection(MapExt().getValue(data,"verticalDirection",defaultValue: "")),
      textBaseline: Tool().getTextBaseline(MapExt().getValue(data,"textBaseline",defaultValue: "")),
      clipBehavior: Tool().getClipBehavior(MapExt().getValue(data,"clipBehavior",defaultValue: "")),
      children: widgets,
    );
    return flex;
  }

}
class ExpandedStrategy extends WidgetStrategy {
  late Widget expanded;
  late  ExpandedAttribute expandedAttribute;
  @override
  Widget mapToWidget(BuildContext context,WidgetAttribute attribute) {
    expandedAttribute = attribute as ExpandedAttribute;
    return getWidget(context);
  }

  Widget getWidget(BuildContext context) {
    Map<String, dynamic> data = expandedAttribute.toMap();
    // WidgetAttribute? child = data.getValue("child");
    // var strategy = AttributeToStrategy().toStrategy();
    // if(strategy!=null){
    //   AttributeToWidget attributeToWidget = AttributeToWidget(strategy);
    //   widgets.add(attributeToWidget.change(element));
    // }
    expanded = Expanded(
      flex: MapExt().getValue(data,"flex",defaultValue: 1),
      child: MapExt().getValue(data,"child"),
    );
    return expanded;
  }

}
class TextStrategy extends WidgetStrategy {
  Map<String, dynamic> textMap = {};
  late Widget text;
  TextAttribute? textAttribute;
  @override
  Widget mapToWidget(BuildContext context,WidgetAttribute attribute) {
    textAttribute ??= attribute as TextAttribute;

    return getWidget();
  }
  Widget getWidget() {
    textMap = textAttribute!.toMap();
    text = Text(
      (MapExt().getValue(textMap,"text") ?? ""),
      style: getTextStyle(MapExt().getValue(textMap,"style")),
    );
    return text;
  }
  

  TextStyle getTextStyle(Map<String, dynamic>? textStyle) {
    if (textStyle == null) {
      return const TextStyle();
    } else {
      Color color = Colors.black;
      double fontSize=14;
      if(MapExt().getValue(textStyle,"fontSize",defaultValue:14).toString().isNotEmpty){
        fontSize = MapExt().getValue(textStyle,"fontSize",defaultValue:14);
      }
      if(MapExt().getValue(textStyle,"color",defaultValue: 0xFF000000).toString().isNotEmpty){
        color = Color(MapExt().getValue(textStyle,"color"));
      }
      return TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: Tool().getFontWeight(MapExt().getValue(textStyle,"fontWeight",defaultValue: "")),
          fontStyle: Tool().getFontStyle(MapExt().getValue(textStyle,"fontStyle",defaultValue: "")),
          height: MapExt().getValue(textStyle,"height",defaultValue: 1),
      );
    }
  }

}
