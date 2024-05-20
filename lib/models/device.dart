part of 'model.dart';

class Device extends Equatable {
  final int? id;
  final String? amrId;
  final String? ip;
  final String? pointerColor;
  final String? speed;
  final int? lidarStatus;
  final String? battery;
  final double? x;
  final double? y;
  final double? degree;
  final int? status;
  final AMRDataLog? amrDataLog;
  final int? time;

  const Device({
    this.id,
    this.amrId,
    this.ip,
    this.pointerColor,
    this.speed,
    this.lidarStatus,
    this.battery,
    this.x,
    this.y,
    this.degree,
    this.status,
    this.amrDataLog,
    this.time,
  });

  factory Device.fromJson(Map<String, dynamic> data) => Device(
        id: data['id'],
        amrId: data['amr_id'],
        ip: data['ip'],
        pointerColor: data['pointer_color'],
        speed: data['speed'],
        lidarStatus: data['lidar_status'],
        battery: data['battery'],
        x: data['x'],
        y: data['y'],
        degree: data['degree'],
        status: data[
            'status'], //0 = disconnected, 1 = connected [run], 2 = connected [idle], 3 = connected [stop]
        amrDataLog: AMRDataLog.fromJson(data['amr_data_log']),
        time: data['time'],
      );

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        amrId,
        ip,
        pointerColor,
        speed,
        lidarStatus,
        battery,
        x,
        y,
        degree,
        status,
        amrDataLog,
        time,
      ];
}
