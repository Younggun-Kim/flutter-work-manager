import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

mixin WorkerIsolateMixin {
  String get isolateNameServerName;

  final ReceivePort _receivePort = ReceivePort();

  void init() async {}

  void dispose() {
    IsolateNameServer.removePortNameMapping(
      isolateNameServerName,
    );
    _receivePort.close();
  }

  StreamSubscription<dynamic> listen(
    void Function(dynamic message)? onData,
  ) {
    IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      isolateNameServerName,
    );

    return _receivePort.listen(onData);
  }
}
