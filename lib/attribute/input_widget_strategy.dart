import 'package:flutter/material.dart';
import 'package:test_dynamic/tool/tool.dart';
import 'package:test_dynamic/widget/colorPicker/flutter_hsvcolor_picker.dart';

///文件作者 ：陈涛(Ann)
///文件名字 ：input_widget_strategy
///创建日期 ：2024/3/18
///文件描述 ：处理输入属性
///修改的人 :
///修改时间 ：
///修改备注 ：
class InputWidgeUtil {
  factory InputWidgeUtil() {
    _singleton ??= InputWidgeUtil._();
    return _singleton!;
  }

  InputWidgeUtil._();

  static InputWidgeUtil? _singleton;

  Widget? getWidget(BuildContext context, String inputKey, dynamic value,
      Function(String inputKey, dynamic value) callBack) {
    InputWidgeStrategy? widgetStrategy;
    if (inputKey == "color") {
      widgetStrategy = ColorsWidget(context, inputKey, value, callBack);
    } else if (inputKey == "width") {
      widgetStrategy = WidthWidget(context, inputKey, value, callBack);
    } else if (inputKey == "height") {
      widgetStrategy = HeightWidget(context, inputKey, value, callBack);
    } else if (inputKey == "fontSize") {
      widgetStrategy = FontSizeWidget(context, inputKey, value, callBack);
    }
    return widgetStrategy?.build(context);
  }
}

abstract class InputWidgeStrategy {
  String inputKey;
  dynamic value;
  BuildContext context;
  Function(String inputKey, dynamic value) callBack;

  InputWidgeStrategy(this.context, this.inputKey, this.value, this.callBack);

  Widget build(BuildContext context);

  BoxDecoration boxDecoration = const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 1,
          spreadRadius: 1,
        )
      ]);
}

class ColorsWidget extends InputWidgeStrategy {
  ColorsWidget(super.context, super.itemKey, super.value, super.callBack);

  ValueNotifier<Color>? _colorNotifier ;

  // int decimalValue = int.parse(hexString, radix: 16); // 将16进制字符串转换为整数
  // String sameHexString = decimalValue.toRadixString(16);
  @override
  Widget build(BuildContext context) {
    if(value!=null && _colorNotifier ==  null)
    {
      _colorNotifier ??= ValueNotifier<Color>(Color(value));
    }else if(value==null && _colorNotifier ==  null){
      _colorNotifier ??= ValueNotifier<Color>(Colors.black);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder<Color>(
          valueListenable: _colorNotifier!,
          builder: (_, color, __) {
            return ColorPicker(
              color: color,
              onChanged: (v) {
                color = v;
                value =  color.value;
                _colorNotifier!.value = v;
                callBack.call(inputKey, value);
              },
            );
          },
        ),
      ],
    );
  }
  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0')}'.substring(2);
  }
}

class WidthWidget extends InputWidgeStrategy {
  WidthWidget(super.context, super.inputKey, super.value, super.callBack);

  final _colorNotifier = ValueNotifier<double?>(0);

  @override
  Widget build(BuildContext context) {
    _colorNotifier.value = value;
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: boxDecoration,
          child: ValueListenableBuilder<double?>(
              valueListenable: _colorNotifier,
              builder: (_, color, __) {
                return TextField(
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                    controller: TextEditingController.fromValue(
                        TextEditingValue(
                            text: value == null ? "" : value.toString(),
                            selection: TextSelection.fromPosition(TextPosition(
                                affinity: TextAffinity.downstream,
                                offset: (value == null ? "" : value.toString())
                                    .length)))),
                    onChanged: (string) {
                      value = string.isNotEmpty ? double.parse(string) : null;
                      _colorNotifier.value = value;
                      callBack.call(inputKey, value);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none, // 移除边框线条
                      ),
                    ));
              }),
        ),
      ],
    );
  }
}

class HeightWidget extends InputWidgeStrategy {
  HeightWidget(super.context, super.inputKey, super.value, super.callBack);

  final _colorNotifier = ValueNotifier<double?>(0);

  @override
  Widget build(BuildContext context) {
    _colorNotifier.value = value;
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: boxDecoration,
          child: ValueListenableBuilder<double?>(
              valueListenable: _colorNotifier,
              builder: (_, color, __) {
                return TextField(
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                    controller: TextEditingController.fromValue(
                        TextEditingValue(
                            text: value == null ? "" : value.toString(),
                            selection: TextSelection.fromPosition(TextPosition(
                                affinity: TextAffinity.downstream,
                                offset: (value == null ? "" : value.toString())
                                    .length)))),
                    onChanged: (string) {
                      value = string.isNotEmpty ? double.parse(string) : null;
                      _colorNotifier.value = value;
                      callBack.call(inputKey, value);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none, // 移除边框线条
                      ),
                    ));
              }),
        ),
      ],
    );
  }
}

class FontSizeWidget extends InputWidgeStrategy {
  FontSizeWidget(super.context, super.inputKey, super.value, super.callBack);

  final _colorNotifier = ValueNotifier<double?>(14);

  @override
  Widget build(BuildContext context) {
    _colorNotifier.value = value;
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: boxDecoration,
          child: ValueListenableBuilder<double?>(
              valueListenable: _colorNotifier,
              builder: (_, color, __) {
                return TextField(
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                    controller: TextEditingController.fromValue(
                        TextEditingValue(
                            text: value == null ? "" : value.toString(),
                            selection: TextSelection.fromPosition(TextPosition(
                                affinity: TextAffinity.downstream,
                                offset: (value == null ? "" : value.toString())
                                    .length)))),
                    onChanged: (string) {
                      if (string.isNotEmpty) {
                        value = double.parse(string);
                        _colorNotifier.value = value;
                        callBack.call(inputKey, value);
                      } else {
                        value = null;
                        _colorNotifier.value = null;
                        callBack.call(inputKey, null);
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none, // 移除边框线条
                      ),
                    ));
              }),
        ),
      ],
    );
  }
}
