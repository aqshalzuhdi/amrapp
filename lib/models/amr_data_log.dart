part of 'model.dart';

class AMRDataLog extends Equatable {
  final bool disconnect;
  final bool idle;
  final bool start;
  final bool stop;

  const AMRDataLog({
    required this.disconnect,
    required this.idle,
    required this.start,
    required this.stop,
  });

  factory AMRDataLog.fromJson(Map<String, dynamic> data) => AMRDataLog(
        disconnect: data['disconnect'],
        idle: data['idle'],
        start: data['start'],
        stop: data['stop'],
      );

  @override
  // TODO: implement props
  List<Object?> get props => [
        disconnect,
        idle,
        start,
        stop,
      ];
}
