///文件作者 ：陈涛(Ann)
///文件名字 ：map_ext
///创建日期 ：2024/3/8
///文件描述 ：
///修改的人 :
///修改时间 ：
///修改备注 ：

class MapExt {
  factory MapExt() {
    _singleton ??= MapExt._();
    return _singleton!;
  }

  MapExt._();

  static MapExt? _singleton;

  dynamic getValue(Map<String, dynamic> map, String key,
      {dynamic defaultValue}) {
    if (map.containsKey(key)) {
      return map[key]??defaultValue;
    } else {
      return defaultValue;
    }
  }
  Map<String,dynamic> getValueMap(Map<String, dynamic> map, String key,
      {Map<String,dynamic>? defaultValue}) {
    if (map.containsKey(key)) {
      return map[key] as Map<String,dynamic>;
    } else {
      return defaultValue??{};
    }
  }
  List<Map<String,dynamic>> getValueListMap(Map<String, dynamic> map, String key,
      {List<Map<String,dynamic>>? defaultValue}) {
    if (map.containsKey(key)) {
      List<dynamic> maps = map[key]as List<dynamic>;
      List<Map<String,dynamic>> list=[];
      if(maps.isNotEmpty){
        for (var element in maps) {
          list.add(element as Map<String,dynamic>);
        }
      }
      return list;
    } else {
      return defaultValue??[];
    }
  }
}
