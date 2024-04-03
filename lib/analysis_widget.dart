import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

  HookConsumerWidget? toStrategy(WidgetAttribute attribute) {
    if (attribute is ScaffoldAttribute) {
      return ScaffoldStrategy(attribute);
    } else if (attribute is TextAttribute) {
      return TextStrategy(attribute);
    } else if (attribute is RowAttribute) {
      return RowStrategy(attribute);
    } else if (attribute is ColumnAttribute) {
      return ColumnStrategy(attribute);
    } else if (attribute is FlexAttribute) {
      return FlexStrategy(attribute);
    }else if (attribute is ExpandedAttribute) {
      return ExpandedStrategy(attribute);
    }

    return null;
  }
}

typedef WidgetStrategyCallback = WidgetAttribute Function(
    WidgetAttribute attribute);
// abstract class WidgetStrategy {
//   Widget mapToWidget(BuildContext context,WidgetAttribute attribute);
//
// }

class AttributeToWidget {
  final HookConsumerWidget widgetStrategy;

  AttributeToWidget(this.widgetStrategy);

  Widget change() {
    return widgetStrategy;
  }
}

class ScaffoldStrategy extends HookConsumerWidget {
  Widget? scaffold;
  late ScaffoldAttribute scaffoldAttribute;
  late Map<String, dynamic> data;
  Widget? body;

  ScaffoldStrategy(WidgetAttribute attribute, {super.key}) {
    scaffoldAttribute = attribute as ScaffoldAttribute;
    data = scaffoldAttribute.toMap();
    var strategy = AttributeToStrategy().toStrategy(scaffoldAttribute.body);
    if (strategy != null) {
      AttributeToWidget attributeToWidget = AttributeToWidget(strategy);
      body = attributeToWidget.change();
    }
  }

  Widget getWidget() {
    return Scaffold(
      appBar: getAppBar(data),
      body: body,
    );
  }

  AppBar? getAppBar(Map<String, dynamic> appBar) {
    if (appBar.containsKey('appBar')) {
      String title =
          MapExt().getValue(appBar['appBar'], "title", defaultValue: "");
      return AppBar(
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return getWidget();
  }
}

class RowStrategy extends HookConsumerWidget {
  late Widget row;
  late RowAttribute rowAttribute;
  late Map<String, dynamic> data;
  List<Widget> widgets = [];

  RowStrategy(WidgetAttribute attribute) {
    rowAttribute = attribute as RowAttribute;
    data = rowAttribute.toMap();
    List<Map<String, dynamic>> children =
        MapExt().getValueListMap(data, "children", defaultValue: []);
    if (children.isNotEmpty) {
      for (var element in children) {
        var elementAttr = MapToAttribute().toAttribute(element);
        if (elementAttr != null) {
          var strategy = AttributeToStrategy().toStrategy(elementAttr);
          if (strategy != null) {
            AttributeToWidget attributeToWidget = AttributeToWidget(strategy);
            widgets.add(attributeToWidget.change());
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: Tool().getMainAxisAlignment(
          MapExt().getValue(data, "mainAxisAlignment", defaultValue: "")),
      crossAxisAlignment: Tool().getCrossAxisAlignment(
          MapExt().getValue(data, "crossAxisAlignment", defaultValue: "")),
      mainAxisSize: Tool().getMainAxisSize(
          MapExt().getValue(data, "mainAxisSize", defaultValue: "")),
      textDirection: Tool().getTextDirection(
          MapExt().getValue(data, "textDirection", defaultValue: "")),
      verticalDirection: Tool().getVerticalDirection(
          MapExt().getValue(data, "verticalDirection", defaultValue: "")),
      textBaseline: Tool().getTextBaseline(
          MapExt().getValue(data, "textBaseline", defaultValue: "")),
      children: widgets,
    );
  }
}

class ColumnStrategy extends HookConsumerWidget {
  late Widget column;
  late ColumnAttribute columnAttribute;
  late Map<String, dynamic> data;
  List<Widget> widgets = [];

  ColumnStrategy(WidgetAttribute attribute) {
    columnAttribute = attribute as ColumnAttribute;
    data = columnAttribute.toMap();
    List<Map<String, dynamic>> children =
        MapExt().getValueListMap(data, "children", defaultValue: []);
    if (children.isNotEmpty) {
      for (var element in children) {
        var elementAttr = MapToAttribute().toAttribute(element);
        if (elementAttr != null) {
          var strategy = AttributeToStrategy().toStrategy(elementAttr);
          if (strategy != null) {
            AttributeToWidget attributeToWidget = AttributeToWidget(strategy);
            widgets.add(attributeToWidget.change());
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: Tool().getCrossAxisAlignment(
          MapExt().getValue(data, "crossAxisAlignment", defaultValue: "")),
      mainAxisAlignment: Tool().getMainAxisAlignment(
          MapExt().getValue(data, "mainAxisAlignment", defaultValue: "")),
      mainAxisSize: Tool().getMainAxisSize(
          MapExt().getValue(data, "mainAxisSize", defaultValue: "")),
      textDirection: Tool().getTextDirection(
          MapExt().getValue(data, "textDirection", defaultValue: "")),
      verticalDirection: Tool().getVerticalDirection(
          MapExt().getValue(data, "verticalDirection", defaultValue: "")),
      textBaseline: Tool().getTextBaseline(
          MapExt().getValue(data, "textBaseline", defaultValue: "")),
      children: widgets,
    );
  }
}

class FlexStrategy extends HookConsumerWidget {
  late Widget flex;
  late FlexAttribute flexAttribute;
  late Map<String, dynamic> data;
  List<Widget> widgets = [];

  FlexStrategy(WidgetAttribute attribute) {
    flexAttribute = attribute as FlexAttribute;
    data = flexAttribute.toMap();
    List<Map<String, dynamic>> children =
        MapExt().getValueListMap(data, "children", defaultValue: []);

    if (children.isNotEmpty) {
      for (var element in children) {
        var elementAttr = MapToAttribute().toAttribute(element);
        if (elementAttr != null) {
          var strategy = AttributeToStrategy().toStrategy(elementAttr);
          if (strategy != null) {
            AttributeToWidget attributeToWidget = AttributeToWidget(strategy);
            widgets.add(attributeToWidget.change());
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return Flex(
      direction: Tool().getFlexDirection(
          MapExt().getValue(data, "direction", defaultValue: "")),
      mainAxisAlignment: Tool().getMainAxisAlignment(
          MapExt().getValue(data, "mainAxisAlignment", defaultValue: "")),
      mainAxisSize: Tool().getMainAxisSize(
          MapExt().getValue(data, "mainAxisSize", defaultValue: "")),
      textDirection: Tool().getTextDirection(
          MapExt().getValue(data, "textDirection", defaultValue: "")),
      verticalDirection: Tool().getVerticalDirection(
          MapExt().getValue(data, "verticalDirection", defaultValue: "")),
      textBaseline: Tool().getTextBaseline(
          MapExt().getValue(data, "textBaseline", defaultValue: "")),
      clipBehavior: Tool().getClipBehavior(
          MapExt().getValue(data, "clipBehavior", defaultValue: "")),
      children: widgets,
    );
  }
}

class ExpandedStrategy extends HookConsumerWidget {
  late Widget expanded;
  late ExpandedAttribute expandedAttribute;
  late Map<String, dynamic> data;

  ExpandedStrategy( WidgetAttribute attribute) {
    expandedAttribute = attribute as ExpandedAttribute;
    data = expandedAttribute.toMap();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      flex: MapExt().getValue(data, "flex", defaultValue: 1),
      child: MapExt().getValue(data, "child"),
    );
  }
}

class TextStrategy extends HookConsumerWidget {
  Map<String, dynamic> textMap = {};
  late Widget text;
  TextAttribute? textAttribute;

  TextStrategy(WidgetAttribute attribute) {
    textAttribute ??= attribute as TextAttribute;
    textMap = textAttribute!.toMap();
  }

  TextStyle getTextStyle(Map<String, dynamic>? textStyle) {
    if (textStyle == null) {
      return const TextStyle();
    } else {
      Color color = Colors.black;
      double fontSize = 14;
      if (MapExt()
          .getValue(textStyle, "fontSize", defaultValue: 14)
          .toString()
          .isNotEmpty) {
        fontSize = MapExt().getValue(textStyle, "fontSize", defaultValue: 14);
      }
      if (MapExt()
          .getValue(textStyle, "color", defaultValue: 0xFF000000)
          .toString()
          .isNotEmpty) {
        color = Color(MapExt().getValue(textStyle, "color"));
      }
      return TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: Tool().getFontWeight(
            MapExt().getValue(textStyle, "fontWeight", defaultValue: "")),
        fontStyle: Tool().getFontStyle(
            MapExt().getValue(textStyle, "fontStyle", defaultValue: "")),
        height: MapExt().getValue(textStyle, "height", defaultValue: 1),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      (MapExt().getValue(textMap, "text") ?? ""),
      style: getTextStyle(MapExt().getValue(textMap, "style")),
    );
  }
}
