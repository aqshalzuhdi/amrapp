part of 'model.dart';

class ApiReturnValue<T> {
  final T? value;
  final String? message;
  // final bool? unauthorized;
  final Map<String, dynamic>? exception;

  ApiReturnValue({
    this.message,
    this.value,
    // this.unauthorized,
    this.exception,
  });
}

class Response<T> {
  final bool? status;
  final T? data;
  final String? message;
  // final bool? unauthorized;
  // final Map<String, dynamic>? exception;

  Response({
    this.status,
    this.data,
    // this.unauthorized,
    this.message,
  });
}

Map<String, dynamic> ArrayResponse({
  bool? status,
  String? message,
  dynamic data,
}) {
  dynamic result = {};
  if (status == true) {
    result = {'status': status, 'data': data};
  } else {
    result = {'status': status, 'message': message};
  }

  return result;
}
