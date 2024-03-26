///文件作者 ：陈涛(Ann)
///文件名字 ：flutter_to_js_interface
///创建日期 ：2024/3/26
///文件描述 ：flutter 调用 js 的通信
///修改的人 :
///修改时间 ：
///修改备注 ：
import 'dart:js' as js;
mixin FlutterToJsInterface {

  void callJsMethod(String json){
    js.context.callMethod('flutterToJs',[json]);
  }
  //拍照选择图片
  void setTakePicture(dynamic json){
    js.context.callMethod('setTakePicture',[json]);
  }
  //接口数据
  void setNetData(dynamic json){
    js.context.callMethod('setNetData',[json]);
  }
  //给代码框传值
  setCode(){
    String code="";
    //读取代码文件
    js.context.callMethod('setCode',[code]);
  }
}