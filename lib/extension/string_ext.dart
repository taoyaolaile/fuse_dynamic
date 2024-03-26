import 'package:test_dynamic/analysis_widget.dart';
import 'package:test_dynamic/model/widget_attribute.dart';

///文件作者 ：陈涛(Ann)
///文件名字 ：attribute_ext
///创建日期 ：2024/3/11
///文件描述 ：
///修改的人 :
///修改时间 ：
///修改备注 ：
extension StringExt on String {
  String typeToKey(){
    switch(this){
      case "Scaffold":
        return "body";
      case "Row":
        return "children";
      case "Column":
        return "children";
      case "Flex":
        return "children";
      case "Expanded":
        return "child";
      case "Container":
        return "child";
      case "Text":
        return "";
      case "TextField":
        return "";
      default:
        return "";
    }
  }
  bool isNumeric() {
    return int.tryParse(this) != null || double.tryParse(this) != null;
  }

}
