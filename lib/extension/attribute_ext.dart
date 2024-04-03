import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test_dynamic/analysis_widget.dart';
import 'package:test_dynamic/model/widget_attribute.dart';

///文件作者 ：陈涛(Ann)
///文件名字 ：attribute_ext
///创建日期 ：2024/3/11
///文件描述 ：
///修改的人 :
///修改时间 ：
///修改备注 ：
extension AttributeExt on WidgetAttribute {
  dynamic toAttribute() {
    if (this is ScaffoldAttribute) {
      return (this as ScaffoldAttribute);
    } else if (this is RowAttribute) {
      return (this as RowAttribute);
    } else if (this is ColumnAttribute) {
      return (this as ColumnAttribute);
    } else if (this is FlexAttribute) {
      return (this as FlexAttribute);
    } else if (this is ContainerAttribute) {
      return (this as ContainerAttribute);
    }
    else if (this is ExpandedAttribute) {
      return (this as ExpandedAttribute);
    }
    else if (this is TextAttribute) {
      return (this as TextAttribute);
    } else {
      return null;
    }
  }
  Map<String,dynamic> changeMpa() {
    if (this is ScaffoldAttribute) {
      return (this as ScaffoldAttribute).toMap();
    } else if (this is RowAttribute) {
      return (this as RowAttribute).toMap();
    } else if (this is ColumnAttribute) {
      return (this as ColumnAttribute).toMap();
    } else if (this is FlexAttribute) {
      return (this as FlexAttribute).toMap();
    } else if (this is ContainerAttribute) {
      return (this as ContainerAttribute).toMap();
    }
    else if (this is ExpandedAttribute) {
      return (this as ExpandedAttribute).toMap();
    }
    else if (this is TextAttribute) {
      return (this as TextAttribute).toMap();
    } else {
      return {};
    }
  }

  dynamic toAttributeChild() {
    if (this is ScaffoldAttribute) {
      return (this as ScaffoldAttribute).body;
    } else if (this is ContainerAttribute) {
      return (this as ContainerAttribute).child;
    }else if (this is ExpandedAttribute) {
      return (this as ExpandedAttribute).child;
    } else {
      return null;
    }
  }
  List<dynamic> toAttributeChildren() {
    if (this is RowAttribute) {
      return (this as RowAttribute).children??[];
    } else if (this is ColumnAttribute) {
      return (this as ColumnAttribute).children??[];
    }else if (this is FlexAttribute) {
      return (this as FlexAttribute).children??[];
    } else {
      return [];
    }
  }

  //是否显示添加按钮
  bool isChildren() {
    switch (widgetType) {
      case "Row":
        return true;
      case "Column":
        return true;
      case "Flex":
        return true;
      default:
        return false;
    }
  }

  bool isChild() {
    switch (widgetType) {
      case "Container":
        return true;
      case "Scaffold":
        return true;
      case "SingleChildScrollView":
        return true;
      case "Expanded":
        return true;
      default:
        return false;
    }
  }
  List<dynamic> getChildren() {
    List<dynamic>? widgets = [];
    switch (widgetType) {
      case "Row":
        widgets = (this as RowAttribute).children;
        return widgets ?? [];
      case "Column":
        widgets = (this as ColumnAttribute).children;
        return widgets ?? [];
      case "Expanded":
        var widget = (this as ExpandedAttribute).child;
        if (widget == null) {
          return [];
        } else {
          widgets.add(widget);
          return widgets;
        }
      case "Flex":
        widgets = (this as FlexAttribute).children;
        return widgets ?? [];
      case "Container":
        var widget = (this as ContainerAttribute).child;
        if (widget == null) {
          return [];
        } else {
          widgets.add(widget);
          return widgets;
        }
      case "Scaffold":
        var widget = (this as ScaffoldAttribute).body;
        if (widget == null) {
          return [];
        } else {
          widgets.add(widget);
          return widgets;
        }
      default:
        return [];
    }
  }
  changeChild(WidgetAttribute child) {
    if (this is ScaffoldAttribute) {
       (this as ScaffoldAttribute).body = child;
    } else if (this is ContainerAttribute) {
       (this as ContainerAttribute).child = child;
    }else if (this is ExpandedAttribute) {
       (this as ExpandedAttribute).child = child;
    } else {

    }
  }
  changeChildren(List<dynamic> childs) {
    if (this is RowAttribute) {
      (this as RowAttribute).children = childs;
    } else if (this is ColumnAttribute) {
      (this as ColumnAttribute).children =childs;
    }else if (this is FlexAttribute) {
      (this as FlexAttribute).children =childs;
    } else {

    }
  }
  HookConsumerWidget? attributeToStrategy() {
    switch (widgetType) {
      case "Row":
       return RowStrategy(this);
      case "Column":
       return ColumnStrategy(this);
      case "Expanded":
        return ExpandedStrategy(this);
      case "Flex":
        return FlexStrategy(this);
      case "Container":
        return ColumnStrategy(this);
      case "Scaffold":
       return ScaffoldStrategy(this);
      case "Text":
       return TextStrategy(this);
      default:
        return null;
    }
  }

}
