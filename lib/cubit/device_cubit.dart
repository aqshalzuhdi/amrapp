import 'package:amrapp/models/model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'device_state.dart';

class DeviceCubit extends Cubit<DeviceState> {
  DeviceCubit() : super(DeviceInitial());

  Future<void> Fetch(
      {required bool isError,
      required String message,
      required List<Device> device}) async {
    //   {required bool isError,
    // required String amrId,
    // required String device,
    // required int status,
    // required String message}
    emit(DeviceInitial());

    if (isError) {
      emit(DeviceFailed(message));
    } else {
      emit(DeviceSuccess(device));
      // var split = device.split('|');
      // emit(DeviceSuccess(Device(
      //   id: 1,
      //   amrId: amrId,
      //   pointerImg: 'img.jpg',
      //   speed: split[0],
      //   lidarStatus: int.tryParse(split[1]),
      //   battery: split[2],
      //   status: status,
      // )));
    }

    // final TCPSocketServer _tcpServer = TCPSocketServer();

    // try {
    //   while (!TCPSocketSetUp.deviceInfo.isNotNone()) {
    //     await TCPSocketSetUp.init();
    //     print("deviceInfo: " + TCPSocketSetUp.deviceInfo.ip);
    //     if (TCPSocketSetUp.deviceInfo.isNotNone()) {
    //       print("deviceInfo exit()");
    //       break;
    //     }
    //   }

    //   await _tcpServer.initServer(
    //     onData: (ip, sourcePort, event) {
    //       print(event);
    //       emit(DeviceSuccess(Device(
    //           id: 1, amrId: event.data, pointerImg: 'img.jpg', status: 1)));
    //       // result = ArrayResponse(status: true, data: event);
    //     },
    //     onDone: (ip, sourcePort) {
    //       print("onDone: $ip");
    //     },
    //     onError: (error, ip, sourcePort) {
    //       print("error: $error");
    //       // result = ArrayResponse(status: false, message: error);
    //     },
    //   );
    // } catch (e) {
    //   print(e);
    // }
  }
}
