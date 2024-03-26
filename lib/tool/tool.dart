import 'package:flutter/material.dart';

///文件作者 ：陈涛(Ann)
///文件名字 ：tool
///创建日期 ：2024/3/8
///文件描述 ：
///修改的人 :
///修改时间 ：
///修改备注 ：
class Tool {
  factory Tool() {
    _singleton ??= Tool._();
    return _singleton!;
  }

  Tool._();

  static Tool? _singleton;

  Map<String, dynamic>? syncWidgetTree(
      Map<String, dynamic> parents, Map<String, dynamic> child,
      {String? key}) {
    if (parents["key"] == (key ?? child["key"])) {
      parents = child;
      return parents;
    } else {
      if (parents.containsKey("child")) {
        var pc = syncWidgetTree(parents["child"], child, key: key);
        parents["child"] = pc;
        return parents;
      } else if (parents.containsKey("body")) {
        var pc = syncWidgetTree(parents["body"], child, key: key);
        parents["body"] = pc;
        return parents;
      } else if (parents.containsKey("children")) {
        for (int i = 0; i < parents["children"].length; i++) {
          if (parents["children"][i]["key"] == (key ?? child["key"])) {
            parents["children"][i] = child;
            return parents;
          } else {
            syncWidgetTree(parents["children"][i], child, key: key);
            // parents["children"][i] = pc;
          }
        }
      } else {
        return parents;
      }
    }
  }


  FontWeight? getFontWeight(String fontWeight){
    switch(fontWeight){
      case "bold": return FontWeight.bold;
      case "normal": return FontWeight.normal;
      case "w100": return FontWeight.w100;
      case "w200": return FontWeight.w200;
      case "w300": return FontWeight.w300;
      case "w400": return FontWeight.w400;
      case "w500": return FontWeight.w500;
      case "w600": return FontWeight.w600;
      case "w700": return FontWeight.w700;
      case "w800": return FontWeight.w800;
      case "w900": return FontWeight.w900;
      default: return null;
    }
  }
  FontStyle? getFontStyle(String fontStyle) {
    switch(fontStyle){
      case "italic":return FontStyle.italic;
      case "normal":return FontStyle.normal;
      default:return null;
    }
  }
  MainAxisAlignment getMainAxisAlignment(String axisAlignment) {
    switch(axisAlignment){
      case "center":return MainAxisAlignment.center;
      case "spaceEvenly":return MainAxisAlignment.spaceEvenly;
      case "end":return MainAxisAlignment.end;
      case "spaceAround":return MainAxisAlignment.spaceAround;
      case "spaceBetween":return MainAxisAlignment.spaceBetween;
      case "start":return MainAxisAlignment.start;
      default:return MainAxisAlignment.start;
    }
  }
  CrossAxisAlignment getCrossAxisAlignment(String axisAlignment) {
    switch(axisAlignment){
      case "start":return CrossAxisAlignment.start;
      case "end":return CrossAxisAlignment.end;
      case "center":return CrossAxisAlignment.center;
      case "baseline":return CrossAxisAlignment.baseline;
      case "stretch":return CrossAxisAlignment.stretch;
      default:return CrossAxisAlignment.center;
    }
  }
  MainAxisSize getMainAxisSize(String mainAxisSize) {
    switch(mainAxisSize){
      case "max":return MainAxisSize.max;
      case "end":return MainAxisSize.min;
      default:return MainAxisSize.max;
    }
  }
  TextDirection? getTextDirection(String textDirection) {
    switch(textDirection){
      case "ltr":return TextDirection.ltr;
      case "rtl":return TextDirection.rtl;
      default:return null;
    }
  }
  VerticalDirection getVerticalDirection(String verticalDirection) {
    switch(verticalDirection){
      case "down":return VerticalDirection.down;
      case "rtl":return VerticalDirection.up;
      default:return VerticalDirection.down;
    }
  }
  TextBaseline? getTextBaseline(String textBaseline) {
    switch(textBaseline){
      case "alphabetic":return TextBaseline.alphabetic;
      case "ideographic":return TextBaseline.ideographic;
      default:return null;
    }
  }
  Axis getFlexDirection(String axis) {
    switch(axis){
      case "vertical":return Axis.vertical;
      case "horizontal":return Axis.horizontal;
      default:return Axis.horizontal;
    }
  }
  Clip getClipBehavior(String clip) {
    switch(clip){
      case "antiAlias":return Clip.antiAlias;
      case "antiAliasWithSaveLayer":return Clip.antiAliasWithSaveLayer;
      case "hardEdge":return Clip.hardEdge;
      case "none":return Clip.none;
      default:return Clip.none;
    }
  }

}
