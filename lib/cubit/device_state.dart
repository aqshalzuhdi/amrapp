part of 'device_cubit.dart';

sealed class DeviceState extends Equatable {
  const DeviceState();

  @override
  List<Object> get props => [];
}

final class DeviceInitial extends DeviceState {}

class DeviceConnection extends DeviceState {
  final bool status;

  const DeviceConnection(this.status);

  @override
  List<Object> get props => [status];
}

class DeviceSuccess extends DeviceState {
  final List<Device> device;

  const DeviceSuccess(this.device);

  @override
  List<Object> get props => [device];
}

class DeviceFailed extends DeviceState {
  final String message;

  const DeviceFailed(this.message);

  @override
  List<Object> get props => [message];
}
