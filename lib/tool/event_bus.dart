import 'dart:async';

///文件作者 ：陈涛(Ann)
///文件名字 ：饿、ventBus
///创建日期 ：2024/3/19
///文件描述 ：
///修改的人 :
///修改时间 ：
///修改备注 ：
class EventBus {

  StreamController _streamController;

  StreamController get streamController => _streamController;

  EventBus({bool sync = false})
      : _streamController = StreamController.broadcast(sync: sync);

  EventBus.customController(StreamController controller)
      : _streamController = controller;

  Stream on<T>() {
    if (T == dynamic) {
      return streamController.stream;
    } else {
      return streamController.stream.where((event) => event is T).cast<T>();
    }
  }

  void fire(event) {
    streamController.add(event);
  }

  void destroy() {
    _streamController.close();
  }
}
