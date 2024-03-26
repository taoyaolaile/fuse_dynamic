import 'package:flutter/material.dart';

///文件作者 ：陈涛(Ann)
///文件名字 ：attribute_handler
///创建日期 ：2024/3/15
///文件描述 ：只针对是枚举类型的处理
///修改的人 :
///修改时间 ：
///修改备注 ：
class AttributeUtils {
  factory AttributeUtils() {
    _singleton ??= AttributeUtils._();
    return _singleton!;
  }

  AttributeUtils._();

  static AttributeUtils? _singleton;
  AttributeHandler? hander;
  AttributeHandler? hander2;
  AttributeHandler? hander3;
  AttributeHandler? hander4;
  AttributeHandler? hander5;
  AttributeHandler? hander6;
  AttributeHandler? hander7;
  AttributeHandler? hander8;
  AttributeHandler? hander9;
  AttributeHandler? hander10;

  Map<String, String> getAttribute(String key) {
    Map<String, String> mapAttribute = {};
    if (hander == null) {
      hander = FontWeightHandler();
      hander2 = FontStyleHandler();
      hander3 = MainAxisAlignmentHandler();
      hander4 = CrossAxisAlignmentHandler();
      hander5 = MainAxisSizeHandler();
      hander6 = TextDirectionHandler();
      hander7 = VerticalDirectionHandler();
      hander8 = TextBaselineHandler();
      hander9 = AxisHandler();
      hander10 = ClipHandler();
      hander!.setNext(hander2!);
      hander2!.setNext(hander3!);
      hander3!.setNext(hander4!);
      hander4!.setNext(hander5!);
      hander5!.setNext(hander6!);
      hander6!.setNext(hander7!);
      hander7!.setNext(hander8!);
      hander8!.setNext(hander9!);
      hander9!.setNext(hander10!);
      // hander10!.setNext(hander9!);
    }
    mapAttribute = hander!.passRequestToNext(key);
    return mapAttribute;
  }
}

//处理属性列表
abstract class AttributeHandler {
  AttributeHandler? _next;

  // 设置下一个处理者
  void setNext(AttributeHandler handler) => _next = handler;

  // 抽象方法，处理请求
  Map<String, String> handleRequest(String request);

  // 可以选择性地定义一个辅助方法来传递请求到下一个处理者
  Map<String, String> passRequestToNext(String request) {
    if (_next != null) {
      return _next!.handleRequest(request);
    } else {
      return {};
    }
  }
}

class FontWeightHandler extends AttributeHandler {
  @override
  Map<String, String> handleRequest(String request) {
    if (request == "fontWeight") {
      return {
        "bold": "FontWeight.bold",
        "normal": "FontWeight.normal",
        "w100": "FontWeight.w100",
        "w200": "FontWeight.w200",
        "w300": "FontWeight.w300",
        "w400": "FontWeight.w400",
        "w500": "FontWeight.w500",
        "w600": "FontWeight.w600",
        "w700": "FontWeight.w700",
        "w800": "FontWeight.w800",
        "w900": "FontWeight.w900",
      };
    } else {
      return passRequestToNext(request);
    }
  }
}

class FontStyleHandler extends AttributeHandler {
  @override
  Map<String, String> handleRequest(String request) {
    if (request == "fontStyle") {
      return {
        "italic": "FontStyle.italic",
        "normal": "FontStyle.normal",
      };
    } else {
      return passRequestToNext(request);
    }
  }
}

class MainAxisAlignmentHandler extends AttributeHandler {
  @override
  Map<String, String> handleRequest(String request) {
    if (request == "mainAxisAlignment") {
      return {
        "center": "MainAxisAlignment.center",
        "spaceEvenly": "MainAxisAlignment.spaceEvenly",
        "end": "MainAxisAlignment.end",
        "spaceAround": "MainAxisAlignment.spaceAround",
        "spaceBetween": "MainAxisAlignment.spaceBetween",
        "start": "MainAxisAlignment.start",
      };
    } else {
      return passRequestToNext(request);
    }
  }
}

class CrossAxisAlignmentHandler extends AttributeHandler {
  @override
  Map<String, String> handleRequest(String request) {
    if (request == "crossAxisAlignment") {
      return {
        "start": "CrossAxisAlignment.start",
        "end": "CrossAxisAlignment.end",
        "center": "CrossAxisAlignment.center",
        "baseline": "CrossAxisAlignment.baseline",
        "stretch": "CrossAxisAlignment.stretch",
      };
    } else {
      return passRequestToNext(request);
    }
  }
}

class MainAxisSizeHandler extends AttributeHandler {
  @override
  Map<String, String> handleRequest(String request) {
    if (request == "mainAxisSize") {
      return {
        "max": "MainAxisSize.max",
        "end": "MainAxisSize.min",
      };
    } else {
      return passRequestToNext(request);
    }
  }
}

class TextDirectionHandler extends AttributeHandler {
  @override
  Map<String, String> handleRequest(String request) {
    if (request == "textDirection") {
      return {
        "ltr": "TextDirection.ltr",
        "rtl": "TextDirection.rtl",
      };
    } else {
      return passRequestToNext(request);
    }
  }
}

class VerticalDirectionHandler extends AttributeHandler {
  @override
  Map<String, String> handleRequest(String request) {
    if (request == "verticalDirection") {
      return {
        "down": "VerticalDirection.down",
        "rtl":  "VerticalDirection.up",
      };
    } else {
      return passRequestToNext(request);
    }
  }
}

class TextBaselineHandler extends AttributeHandler {
  @override
  Map<String, String> handleRequest(String request) {
    if (request == "textBaseline") {
      return {
        "alphabetic":  "TextBaseline.alphabetic",
        "ideographic": "TextBaseline.ideographic",
      };
    } else {
      return passRequestToNext(request);
    }
  }
}

class AxisHandler extends AttributeHandler {
  @override
  Map<String, String> handleRequest(String request) {
    if (request == "direction") {
      return {
        "vertical":   "Axis.vertical",
        "horizontal": "Axis.horizontal",
      };
    } else {
      return passRequestToNext(request);
    }
  }
}

class ClipHandler extends AttributeHandler {
  @override
  Map<String, String> handleRequest(String request) {
    if (request == "clipBehavior") {
      return {
        "antiAlias": "Clip.antiAlias",
        "antiAliasWithSaveLayer": "Clip.antiAliasWithSaveLayer",
        "hardEdge": "Clip.hardEdge",
        "none": "Clip.none",
      };
    } else {
      return passRequestToNext(request);
    }
  }
}


