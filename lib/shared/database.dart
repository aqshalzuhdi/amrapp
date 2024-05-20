part of 'shared.dart';

// Inisialisasi array bersarang
List<Device> deviceArr = List.empty(growable: true);
String fileAMRName = DateTime.now().year.toString() +
    DateTime.now().month.toString() +
    DateTime.now().day.toString();

// idle = connect
bool idleWriteLog = false, startWriteLog = false;
bool stopWriteLog = false, disconnectWriteLog = false;

Future<void> _writeSeparatedLog(String amrId) async {
  await writeLogFile(
    fileAMRName + ("-activity-") + amrId + (".log"),
    "data",
    "------------------------------------------------------------------",
  );
}

// Fungsi untuk menambahkan data ke array bersarang
Future<void> addData(Device device
    // {
    // // required int id,
    // required String amrID,
    // required String pointerColor,
    // required String speed,
    // required int lidarStatus,
    // required String battery,
    // required double x,
    // required double y,
    // required double degree,
    // required int status,
    // required int time,
    // }
    ) async {
  int autoincrement = (deviceArr.isEmpty) ? 1 : deviceArr.length + 1;

  Device data = Device(
      id: autoincrement,
      amrId: device.amrId,
      pointerColor: device.pointerColor,
      speed: device.speed,
      lidarStatus: device.lidarStatus,
      battery: device.battery,
      x: device.x,
      y: device.y,
      degree: device.degree,
      status: device.status,
      amrDataLog: const AMRDataLog(
        disconnect: false,
        idle: false,
        start: false,
        stop: false,
      ),
      time: device.time);

  deviceArr.add(data);

  if (device.status.toString() == "2") {
    await writeLogFile(
      fileAMRName + ("-activity-") + device.amrId.toString() + (".log"),
      "data",
      ("[connect] ") +
          DateTime.now().toLocal().toString() +
          (" | AMR connected at coordinate(") +
          device.x.toString() +
          (",") +
          device.y.toString() +
          (")"),
    );
  }

  // await createFileExcelReport(
  //     fileName: fileAMRName + ("-report-") + device.amrId.toString(),
  //     data: data);
}

// Fungsi untuk mengubah data pada indeks tertentu
Future<void> updateData(String amrID, Device parameter) async {
  try {
    final data = readDataByAmrID(amrID);
    if (data != null) {
      int index = deviceArr.indexWhere((element) => element.amrId == amrID);

      if (index >= 0 && index < deviceArr.length) {
        Device result = deviceArr[index];

        deviceArr[index] = Device(
          id: result.id,
          amrId: amrID,
          pointerColor: parameter.pointerColor,
          speed: parameter.speed,
          lidarStatus: parameter.lidarStatus,
          battery: parameter.battery,
          x: parameter.x,
          y: parameter.y,
          degree: parameter.degree,
          status: parameter.status,
          amrDataLog: AMRDataLog(
            disconnect: disconnectWriteLog,
            idle: idleWriteLog,
            start: startWriteLog,
            stop: stopWriteLog,
          ),
          time: parameter.time,
        );

        final activityFileName =
            fileAMRName + ("-activity-") + result.amrId.toString() + (".log");
        final reportFileName =
            fileAMRName + ("-report-") + result.amrId.toString();

        if ((result.status.toString() == "1" &&
                !deviceArr[index].amrDataLog!.start) ||
            (result.status.toString() == "3" &&
                !deviceArr[index].amrDataLog!.stop) ||
            (result.status.toString() == "0" &&
                !deviceArr[index].amrDataLog!.disconnect)) {
          await createFileExcelReport(
              fileName: reportFileName, data: parameter);
        }

        if (result.status.toString() == "1" &&
            !deviceArr[index].amrDataLog!.start) {
          //connect [run]
          await writeLogFile(
            activityFileName,
            "data",
            ("[run] ") +
                DateTime.now().toLocal().toString() +
                (" | AMR running at coordinate(") +
                result.x.toString() +
                (",") +
                result.y.toString() +
                (")"),
          );

          // await createFileExcelReport(
          //     fileName: reportFileName, data: parameter);

          disconnectWriteLog = false; // 0
          startWriteLog = true; // 1
          idleWriteLog = false; // 2
          stopWriteLog = false; // 3
        } else if (result.status.toString() == "2" &&
            !deviceArr[index].amrDataLog!.idle) {
          //connect [idle]
          if (result.amrDataLog!.disconnect) {
            await _writeSeparatedLog(result.amrId.toString());
          }

          await writeLogFile(
            activityFileName,
            "data",
            ("[idle] ") +
                DateTime.now().toLocal().toString() +
                (" | AMR idle at coordinate(") +
                result.x.toString() +
                (",") +
                result.y.toString() +
                (")"),
          );

          disconnectWriteLog = false; // 0
          startWriteLog = false; // 1
          idleWriteLog = true; // 2
          stopWriteLog = false; // 3
        } else if (result.status.toString() == "3" &&
            !deviceArr[index].amrDataLog!.stop) {
          //connect [stop]
          await writeLogFile(
            activityFileName,
            "data",
            ("[stop] ") +
                DateTime.now().toLocal().toString() +
                (" | AMR stop at coordinate(") +
                result.x.toString() +
                (",") +
                result.y.toString() +
                (")"),
          );

          // await createFileExcelReport(
          //     fileName: reportFileName, data: parameter);

          if (!result.amrDataLog!.disconnect) {
            await _writeSeparatedLog(result.amrId.toString());
          }

          disconnectWriteLog = false; // 0
          startWriteLog = false; // 1
          idleWriteLog = false; // 2
          stopWriteLog = true; // 3
        } else if (result.status.toString() == "0" &&
            !deviceArr[index].amrDataLog!.disconnect) {
          //disconnect
          await writeLogFile(
            activityFileName,
            "data",
            ("[disconnect] ") +
                DateTime.now().toLocal().toString() +
                (" | AMR disconnected at coordinate(") +
                result.x.toString() +
                (",") +
                result.y.toString() +
                (")"),
          );

          if (!result.amrDataLog!.stop) {
            await _writeSeparatedLog(result.amrId.toString());
          }

          // await createFileExcelReport(
          //     fileName: reportFileName, data: parameter);

          disconnectWriteLog = true; // 0
          startWriteLog = false; // 1
          idleWriteLog = false; // 2
          stopWriteLog = false; // 3
        }
      }
      print("UpdateData() success for $amrID");
    } else {
      print("updateData() failed for $amrID");
    }
  } catch (e) {
    print("catch from UpdateData() for $amrID, reason: $e");
    await writeLogFile(
      "app.log",
      "logs",
      ("[Exception]") +
          DateTime.now().toLocal().toString() +
          (" | Database UpdateData(): ") +
          e.toString(),
    );
  }

  // return;
}

// Fungsi untuk menghapus data pada indeks tertentu
void deleteData(int index) {
  if (index >= 0 && index < deviceArr.length) {
    deviceArr.removeAt(index);
  }

  return;
}

// Fungsi untuk membaca data keseluruhan
List<Device> readAllData() {
  // dynamic tempArr = [];
  // for (var data in deviceArr) {
  //   tempArr.add(data);
  // }

  // return (tempArr == []) ? [] : tempArr;
  return deviceArr;
}

// Fungsi untuk membaca data dengan filter amrID
dynamic readDataByAmrID(String amrID) {
  for (Device data in deviceArr) {
    if (data.amrId == amrID) {
      return data;
    }
  }

  return null;
}
