///文件作者 ：陈涛(Ann)
///文件名字 ：event_bus
///创建日期 ：2024/4/2
///文件描述 ：
///修改的人 :
///修改时间 ：
///修改备注 ：
import 'dart:async';

class EventBusUtil {
  factory EventBusUtil() {
    _singleton ??= EventBusUtil._();
    return _singleton!;
  }

  EventBusUtil._();
  EventBus eventBus = EventBus();
  static EventBusUtil? _singleton;
}

class EventBus {
  final StreamController _streamController;

  StreamController get streamController => _streamController;

  EventBus({bool sync = false})
      : _streamController = StreamController.broadcast(sync: sync);

  EventBus.customController(StreamController controller)
      : _streamController = controller;

  Stream<T> on<T>() {
    if (T == dynamic) {
      return streamController.stream as Stream<T>;
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
