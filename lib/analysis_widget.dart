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

abstract class WidgetStrategy {
  Widget mapToWidget(WidgetAttribute attribute);
}

class AttributeToWidget {
  final WidgetStrategy widgetStrategy;

  AttributeToWidget(this.widgetStrategy);

  Widget change(WidgetAttribute attribute) {
    return this.widgetStrategy.mapToWidget(attribute);
  }
}

class ScaffoldStrategy extends WidgetStrategy {
  @override
  Widget mapToWidget(WidgetAttribute attribute) {
    ScaffoldAttribute scaffoldAttribute = attribute as ScaffoldAttribute;
    Map<String, dynamic> data = scaffoldAttribute.toMap();
    var strategy = AttributeToStrategy().toStrategy(scaffoldAttribute.body);
    Widget? body;
    if(strategy!=null){
      AttributeToWidget attributeToWidget = AttributeToWidget(strategy);
      body =attributeToWidget.change(scaffoldAttribute.body);
    }
    return Scaffold(
      appBar: getAppBar(data),
      body:  body,
    );
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
  @override
  Widget mapToWidget(WidgetAttribute attribute) {
    RowAttribute rowAttribute = attribute as RowAttribute;
    Map<String, dynamic> data = rowAttribute.toMap();
    List<Map<String, dynamic>> children = MapExt().getValueListMap(data,"children",defaultValue: []);
    List<Widget> widgets =[];
    if(children.isNotEmpty){
      if(children.isNotEmpty){
        for (var element in children) {
          var elementAttr = MapToAttribute().toAttribute(element);
          if(elementAttr!=null)
          {
            var strategy = AttributeToStrategy().toStrategy(elementAttr);
            if(strategy!=null){
              AttributeToWidget attributeToWidget = AttributeToWidget(strategy);
              widgets.add(attributeToWidget.change(elementAttr));
            }
          }

        }
      }
    }
    return Row(
      mainAxisAlignment: Tool().getMainAxisAlignment(MapExt().getValue(data,"mainAxisAlignment",defaultValue: "")),
      crossAxisAlignment: Tool().getCrossAxisAlignment(MapExt().getValue(data,"crossAxisAlignment",defaultValue: "")),
      mainAxisSize: Tool().getMainAxisSize(MapExt().getValue(data,"mainAxisSize",defaultValue: "")),
      textDirection: Tool().getTextDirection(MapExt().getValue(data,"textDirection",defaultValue: "")),
      verticalDirection: Tool().getVerticalDirection(MapExt().getValue(data,"verticalDirection",defaultValue: "")),
      textBaseline: Tool().getTextBaseline(MapExt().getValue(data,"textBaseline",defaultValue: "")),
      children: widgets,
    );
  }
}

class ColumnStrategy extends WidgetStrategy {
  @override
  Widget mapToWidget(WidgetAttribute attribute) {
    ColumnAttribute columnAttribute = attribute as ColumnAttribute;
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
            widgets.add(attributeToWidget.change(elementAttr));
          }
        }

      }
    }
    return Column(
      crossAxisAlignment: Tool().getCrossAxisAlignment(MapExt().getValue(data,"crossAxisAlignment",defaultValue: "")),
      mainAxisAlignment: Tool().getMainAxisAlignment(MapExt().getValue(data,"mainAxisAlignment",defaultValue: "")),
      mainAxisSize: Tool().getMainAxisSize(MapExt().getValue(data,"mainAxisSize",defaultValue: "")),
      textDirection: Tool().getTextDirection(MapExt().getValue(data,"textDirection",defaultValue: "")),
      verticalDirection: Tool().getVerticalDirection(MapExt().getValue(data,"verticalDirection",defaultValue: "")),
      textBaseline: Tool().getTextBaseline(MapExt().getValue(data,"textBaseline",defaultValue: "")),
      children: widgets,
    );
  }
}

class FlexStrategy extends WidgetStrategy {
  @override
  Widget mapToWidget(WidgetAttribute attribute) {
    FlexAttribute flexAttribute = attribute as FlexAttribute;
    Map<String, dynamic> data = flexAttribute.toMap();
    List<Map<String, dynamic>> children = MapExt().getValueListMap(data,"children",defaultValue: []);
    List<Widget> widgets =[];
    if(children.isNotEmpty){
      if(children.isNotEmpty){
        for (var element in children) {
          var elementAttr = MapToAttribute().toAttribute(element);
          if(elementAttr!=null)
          {
            var strategy = AttributeToStrategy().toStrategy(elementAttr);
            if(strategy!=null){
              AttributeToWidget attributeToWidget = AttributeToWidget(strategy);
              widgets.add(attributeToWidget.change(elementAttr));
            }
          }

        }
      }
    }
    return Flex(
      direction: Tool().getFlexDirection(MapExt().getValue(data,"direction",defaultValue: "")),
      mainAxisAlignment: Tool().getMainAxisAlignment(MapExt().getValue(data,"mainAxisAlignment",defaultValue: "")),
      mainAxisSize: Tool().getMainAxisSize(MapExt().getValue(data,"mainAxisSize",defaultValue: "")),
      textDirection: Tool().getTextDirection(MapExt().getValue(data,"textDirection",defaultValue: "")),
      verticalDirection: Tool().getVerticalDirection(MapExt().getValue(data,"verticalDirection",defaultValue: "")),
      textBaseline: Tool().getTextBaseline(MapExt().getValue(data,"textBaseline",defaultValue: "")),
      clipBehavior: Tool().getClipBehavior(MapExt().getValue(data,"clipBehavior",defaultValue: "")),
      children: widgets,
    );
  }
}
class ExpandedStrategy extends WidgetStrategy {
  @override
  Widget mapToWidget(WidgetAttribute attribute) {
    ExpandedAttribute expandedAttribute = attribute as ExpandedAttribute;
    Map<String, dynamic> data = expandedAttribute.toMap();
    // WidgetAttribute? child = data.getValue("child");
    // var strategy = AttributeToStrategy().toStrategy();
    // if(strategy!=null){
    //   AttributeToWidget attributeToWidget = AttributeToWidget(strategy);
    //   widgets.add(attributeToWidget.change(element));
    // }
    return Expanded(
      flex: MapExt().getValue(data,"flex",defaultValue: 1),
      child: MapExt().getValue(data,"child"),
    );
  }
}
class TextStrategy extends WidgetStrategy {
  @override
  Widget mapToWidget(WidgetAttribute attribute) {
    TextAttribute textAttribute = attribute as TextAttribute;
    Map<String, dynamic> data = textAttribute.toMap();
    return Text(
      (MapExt().getValue(data,"text") ?? ""),
      style: getTextStyle(MapExt().getValue(data,"style")),
    );
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
