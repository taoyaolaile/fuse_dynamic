import 'package:test_dynamic/model/widget_attribute.dart';

///文件作者 ：陈涛(Ann)
///文件名字 ：attribute_bean
///创建日期 ：2024/3/14
///文件描述 ：单个属性全局处理
///修改的人 :
///修改时间 ：
///修改备注 ：
class AttributeBean {
  factory AttributeBean() {
    _singleton ??= AttributeBean._();
    return _singleton!;
  }

  AttributeBean._();

  static AttributeBean? _singleton;
  //选中的widget的父widget
  WidgetAttribute? parentAttr;
  //选中的widget
  WidgetAttribute? childAttr;
}
