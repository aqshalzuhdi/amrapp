part of 'service.dart';

void initTCP() async {
  TCPSocketSetUp.setConfig(
    const SocketConfig(
      port: 8000,
      numberSplit: 10000,
      timeoutEachTimesSendData: Duration(milliseconds: 50),
    ),
  );
  deviceInitTCP();
}

void deviceInitTCP() async {
  while (!TCPSocketSetUp.deviceInfo.isNotNone()) {
    await TCPSocketSetUp.init();
    print(("deviceInfo: ") + TCPSocketSetUp.deviceInfo.ip);
    if (TCPSocketSetUp.deviceInfo.isNotNone()) {
      // print("deviceInfo exit()");
      writeLogFile(
        "connection.log",
        "logs",
        DateTime.now().toLocal().toString() +
            (" | Server ${TCPSocketSetUp.deviceInfo.ip}:${TCPSocketSetUp.config.port} started"),
      );
      break;
    }
  }
}
