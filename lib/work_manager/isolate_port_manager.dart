import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

class IsolatePortManager {
  static final ReceivePort _receivePort = ReceivePort();
  static const isolateNameServerName = 'worker_isolate_name_server';

  IsolatePortManager();

  void init() async {}

  static void dispose() {
    IsolateNameServer.removePortNameMapping(isolateNameServerName);
    _receivePort.close();
  }

  static SendPort? getSendPort() {
    return IsolateNameServer.lookupPortByName(isolateNameServerName);
  }

  static StreamSubscription<dynamic> listen(
    void Function(dynamic message)? onData,
  ) {
    IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      isolateNameServerName,
    );

    return _receivePort.listen(onData);
  }
}
