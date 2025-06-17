# flutter_work_manager

Flutter의 `workmanager` 패키지를 활용하여 백그라운드 작업을 실행하는 방법을 보여주는 예제입니다.
<br/>
`workmanager`는 Android 및 iOS 플랫폼에서 신뢰할 수 있는 방식으로 백그라운드 작업을 스케줄링하고 실행할 수 있도록 지원합니다.

### 주요 기능

* **백그라운드 작업 스케줄링**: 특정 조건(예: 네트워크 연결, 충전 상태)에 따라 또는 주기적으로 백그라운드 작업을 실행하도록 스케줄링할 수 있습니다.
* **플랫폼별 구현**: Android에서는 `WorkManager`를, iOS에서는 `BGTaskScheduler`를 사용하여 각 플랫폼의 백그라운드 작업 처리 방식에
  최적화되어 있습니다.
* **작업 지속성**: 앱이 종료되거나 장치가 재부팅되어도 예약된 작업은 유지됩니다.
* **다양한 작업 유형 지원**: 간단한 일회성 작업부터 주기적인 작업, 특정 제약 조건이 있는 작업까지 다양한 유형의 백그라운드 작업을 지원합니다.
* **Work 클래스 중심 제어**: `Worker` 클래스를 통해 작업 초기화(`init()`), 예약된 작업 로그 출력(`log()`), 작업 등록(`emitOneOff()`, `emitPeriodic()`, `emitProcessing()`)을 일관된 방식으로 관리할 수 있습니다.

### Workmanager Task 종류

| Task 종류        | Android    | iOS                            | 설명                       |
|----------------|------------|--------------------------------|--------------------------|
| OneOffTask     | Immediate  | BGAppRefreshTask               | 즉시 실행                    |
| PeriodTask     | Deferrable | BGAppRefreshTask<br/>(주기 보장 X) | 30초 이하 작업에 대하여 주기적인 실행   |
| ProcessingTask | 지원 X       | BGProcessingTask               | 30초 이상 긴 작업에 대하여 주기적인 실행 |

### 작업 등록 예시

작업은 `Worker` 클래스를 통해 아래와 같이 등록할 수 있습니다.

```dart
// main() 함수에서 초기화
Worker.init();

// 일회성 작업 등록
Worker.emitOneOff();

// 주기적 작업 등록 (Android 15분 이상, iOS는 시스템에 의해 결정됨)
Worker.emitPeriodic();

// iOS 전용, 긴 작업에 적합한 처리
Worker.emitProcessing();
```

> 참고: `emitProcessing()`은 iOS에서만 동작하며, 네트워크 연결 및 충전 중 조건을 만족해야 합니다.

### isolate 간 통신

* `IsolatePortManager`를 통해 메인 isolate와 workmanager isolate(백그라운드 isolate) 간의 메시지 통신을 구현할 수 있습니다.
* 내부적으로 `ReceivePort`를 생성하고, `IsolateNameServer.registerPortWithName()`를 통해 식별 가능한 이름으로 등록합니다.
* 이후 `IsolateNameServer.lookupPortByName()`를 통해 `SendPort`를 획득하여 메시지를 전달할 수 있습니다.
* `listen()` 메서드를 통해 메시지 수신을 시작할 수 있으며, 필요 시 `dispose()`를 호출하여 포트를 해제합니다., 백그라운드 작업 수행 후 메인 isolate로 메시지를 전달하는 데 사용됩니다.

```dart
// 메시지 수신 리스너 등록
final subscription = IsolatePortManager.listen((message) {
  print('Received message: $message');
});

// 메시지 전송
final sendPort = IsolatePortManager.getSendPort();
sendPort?.send('Hello from main isolate');
```


### 참고

* [workmanager - pub.dev](https://pub.dev/packages/workmanager): Flutter용 백그라운드 작업 스케줄링 패키지
* [dart isolate](https://dart.dev/language/isolates): dart isolate 공식 문서
* [BGTaskScheduler - Apple Docs](https://developer.apple.com/documentation/backgroundtasks)