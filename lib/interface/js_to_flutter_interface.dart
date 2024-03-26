///文件作者 ：陈涛(Ann)
///文件名字 ：js_to_flutter_interface
///创建日期 ：2024/3/26
///文件描述 ：js 调用flutter
///修改的人 :
///修改时间 ：
///修改备注 ：
import 'dart:js' as js;
mixin JsToFlutterInterface {

  initInterface(){
    js.context["getTakePicture"] = getTakePicture;
    js.context["getNetData"] = getNetData;
    js.context["getCode"] = getCode;
  }

  //拍照选择图片
  void getTakePicture(dynamic json){

  }
  //接口数据
  void getNetData(dynamic json){

  }
  //监听代码输入回掉
  getCode(String code){
    //修改代码文件
  }
}