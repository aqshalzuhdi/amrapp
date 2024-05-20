part of 'shared.dart';

int runRowIndex = 8, disRowIndex = 8, stopRowIndex = 8, totalRowIndex = 8;
int runCount = 0, disconnectCount = 0, stopCount = 0, lidarCount = 0;
Map<String, dynamic> resultExcelFile = {};

Future<void> createFileExcelReport({
  required String fileName,
  required Device data,
}) async {
  int position = 0;
  try {
    position = 1;
    const parentDir = 'data';
    await prepareDir(parentDir);

    position = 2;
    final path = await localPath;
    Excel excel;

    position = 3;
    var filepath = path +
        Platform.pathSeparator +
        parentPath +
        Platform.pathSeparator +
        parentDir +
        Platform.pathSeparator +
        fileName +
        (".xlsx");

    position = 4;
    //var file = "/Users/kawal/Desktop/excel/test/test_resources/example.xlsx";
    final excelFiles = File(filepath);

    position = 5;
    if (await excelFiles.exists() == false) {
      print('file doesn\'t exists!');
      excel = Excel.createExcel();
      await _writeExcelSettingsFile(
        id: data.amrId.toString(),
        run: runRowIndex.toString(),
        dis: disRowIndex.toString(),
        stop: stopRowIndex.toString(),
        total: totalRowIndex.toString(),
        runCount: runCount.toString(),
        disconnectCount: disconnectCount.toString(),
        stopCount: stopCount.toString(),
        lidarCount: lidarCount.toString(),
      );
    } else {
      excel = Excel.decodeBytes(excelFiles.readAsBytesSync());
    }

    position = 6;
    resultExcelFile = await _excelSettingsFile(data: data);
    // index: 0 [running], 1 [disconnect], 2 [stop], 3 [total]

    // final resultExcelFile = await readExcelSettingsFile(data.amrId.toString());
    // final splitResultExcelFile = resultExcelFile.split('#');

    // final runningSplitResultExcelFile = splitResultExcelFile[0].split("|");
    // final disconnectSplitResultExcelFile = splitResultExcelFile[1].split("|");
    // final stopSplitResultExcelFile = splitResultExcelFile[2].split("|");
    // final totalSplitResultExcelFile = splitResultExcelFile[3].split("|");

    position = 7;
    print(resultExcelFile['running']);
    print(resultExcelFile['disconnect']);
    print(resultExcelFile['stop']);
    print(resultExcelFile['total']);

    position = 8;
    //set variable yang memiliki value default
    disRowIndex = int.parse(resultExcelFile['disconnect'][2]);
    disconnectCount = int.parse(resultExcelFile['total'][4]);

    position = 9;
    runRowIndex = int.parse(resultExcelFile['running'][2]);
    runCount = int.parse(resultExcelFile['total'][3]);

    position = 10;
    stopRowIndex = int.parse(resultExcelFile['stop'][2]);
    stopCount = int.parse(resultExcelFile['total'][5]);

    position = 11;
    lidarCount = int.parse(resultExcelFile['total'][6]);

    // print(await excel);

    // CellStyle cellStyle = CellStyle(
    //   bold: true,
    //   italic: true,
    //   textWrapping: TextWrapping.WrapText,
    //   fontFamily: getFontFamily(FontFamily.Comic_Sans_MS),
    //   rotation: 0,
    // );

    position = 12;
    var sheet = excel['Sheet1'];
    headerExcel(sheet);
    runningHeaderExcel(sheet);
    disconnectHeaderExcel(sheet);
    stopHeaderExcel(sheet);
    totalHeaderExcel(sheet);

    position = 13;
    String amrStatus = data.status.toString();
    if (amrStatus == "0") {
      position = 14;
      disconnectDataExcel(sheet, resultExcelFile['disconnect'][2], data);
      disRowIndex += 1;
      disconnectCount += 1;
    } else if (amrStatus == "1") {
      position = 15;
      runningDataExcel(sheet, resultExcelFile['running'][2], data);
      runRowIndex += 1;
      runCount += 1;
    } else if (amrStatus == "3") {
      position = 16;
      stopDataExcel(sheet, resultExcelFile['stop'][2], data);
      stopRowIndex += 1;
      stopCount += 1;
    } else {
      // runningHeaderExcel(sheet);
      // disconnectHeaderExcel(sheet);
      // stopHeaderExcel(sheet);
      // totalHeaderExcel(sheet);
    }

    position = 17;
    if (data.lidarStatus.toString() == "0") {
      lidarCount += 1;
    }

    position = 18;
    await _writeExcelSettingsFile(
      id: data.amrId.toString(),
      run: runRowIndex.toString(),
      dis: disRowIndex.toString(),
      stop: stopRowIndex.toString(),
      total: totalRowIndex.toString(),
      runCount: runCount.toString(),
      disconnectCount: disconnectCount.toString(),
      stopCount: stopCount.toString(),
      lidarCount: lidarCount.toString(),
    );

    position = 19;
    resultExcelFile = await _excelSettingsFile(data: data);
    totalDataExcel(
      sheet,
      resultExcelFile['total'][2],
      runCount: resultExcelFile['total'][3],
      disconnectCount: disconnectCount.toString(),
      stopCount: resultExcelFile['total'][5],
      lidarCount: resultExcelFile['total'][6],
    );

    // var cell = sheet.cell(CellIndex.indexByString("A1"));
    // cell.value = TextCellValue("Heya How are you I am fine ok goood night");
    // cell.cellStyle = cellStyle;

    // var cell2 = sheet.cell(CellIndex.indexByString("E5"));
    // cell2.value = TextCellValue("Heya How night");
    // cell2.cellStyle = cellStyle;

    // String outputFile = "/Users/kawal/Desktop/git_projects/r.xlsx";

    List<int>? fileBytes = excel.save();
    //print('saving executed in ${stopwatch.elapsed}');
    if (fileBytes != null) {
      File(filepath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
    }
  } catch (e) {
    writeLogFile(
      "app.log",
      "logs",
      DateTime.now().toLocal().toString() +
          (" | CreateFileExcelReport() Exception {position: $position} ") +
          e.toString(),
    );
    // createFileExcelReport(fileName: fileName, data: data);
  }
}

void headerExcel(Sheet sheet) {
  // sheet.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('Z1'));
  // sheet.setMergedCellStyle(
  //   CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
  //   CellStyle(
  //       backgroundColorHex: "25D366",
  //       horizontalAlign: HorizontalAlign.Center,
  //       verticalAlign: VerticalAlign.Center),
  // );

  var titleReportCell = sheet.cell(CellIndex.indexByString('L1'));
  titleReportCell.value = const TextCellValue('[Report]');

  var titleAMRCell = sheet.cell(CellIndex.indexByString('M1'));
  titleAMRCell.value = const TextCellValue('Automatic Mobile Robotic');

  var descriptionCell = sheet.cell(CellIndex.indexByString('J2'));
  descriptionCell.value = const TextCellValue(
      'Laporan Pemakaian Harian AMR [Automatic Mobile Robotic] Pada BU REF');

  var subDescriptionCell = sheet.cell(CellIndex.indexByString('K3'));
  subDescriptionCell.value =
      const TextCellValue('PT. PANASONIC MANUFACTURING INDONESIA');

  var dateCell = sheet.cell(CellIndex.indexByString('A4'));
  dateCell.value = const TextCellValue('Date');

  var cell3 = sheet.cell(CellIndex.indexByString('B4'));
  cell3.value = TextCellValue(dateNow.split(" ")[0]);
}

void runningHeaderExcel(Sheet sheet) {
//Running Header
  var runTitleCell = sheet.cell(CellIndex.indexByString('C6'));
  runTitleCell.value = TextCellValue('Running');

  var runStartCell = sheet.cell(CellIndex.indexByString('A7'));
  runStartCell.value = TextCellValue('Start');

  var runPositionCell = sheet.cell(CellIndex.indexByString('B7'));
  runPositionCell.value = TextCellValue('Position');

  var runLiDARCell = sheet.cell(CellIndex.indexByString('C7'));
  runLiDARCell.value = TextCellValue('LiDAR');

  var runBatteryCell = sheet.cell(CellIndex.indexByString('D7'));
  runBatteryCell.value = TextCellValue('Battery');

  var runSpeedCell = sheet.cell(CellIndex.indexByString('E7'));
  runSpeedCell.value = TextCellValue('Speed');

  var runFinishCell = sheet.cell(CellIndex.indexByString('F7'));
  runFinishCell.value = TextCellValue('Finish');
}

void runningDataExcel(Sheet sheet, String col, Device data) {
  // Running Data
  var runStartDataCell = sheet.cell(CellIndex.indexByString('A' + col));
  runStartDataCell.value = TextCellValue(timeNow);

  var runPositionDataCell = sheet.cell(CellIndex.indexByString('B' + col));
  runPositionDataCell.value =
      TextCellValue(data.x.toString() + (",") + data.y.toString());

  String statusLiDAR =
      (data.lidarStatus.toString() == "0") ? 'Error' : 'Connect';
  var runLiDARDataCell = sheet.cell(CellIndex.indexByString('C' + col));
  runLiDARDataCell.value = TextCellValue(statusLiDAR);

  var runBatteryDataCell = sheet.cell(CellIndex.indexByString('D' + col));
  runBatteryDataCell.value = TextCellValue(data.battery.toString() + '%');

  var runSpeedDataCell = sheet.cell(CellIndex.indexByString('E' + col));
  runSpeedDataCell.value = TextCellValue(data.speed.toString() + 'km/h');

  var runFinishDataCell = sheet.cell(CellIndex.indexByString('F' + col));
  runFinishDataCell.value = TextCellValue(timeNow);
}

void disconnectHeaderExcel(Sheet sheet) {
  var dcTitleCell = sheet.cell(CellIndex.indexByString('J6'));
  dcTitleCell.value = TextCellValue('Disconnect');

  var dcTimeCell = sheet.cell(CellIndex.indexByString('H7'));
  dcTimeCell.value = TextCellValue('Time');

  var dcPositionCell = sheet.cell(CellIndex.indexByString('I7'));
  dcPositionCell.value = TextCellValue('Position');

  var dcLiDARCell = sheet.cell(CellIndex.indexByString('J7'));
  dcLiDARCell.value = TextCellValue('LiDAR');

  var dcBatteryCell = sheet.cell(CellIndex.indexByString('K7'));
  dcBatteryCell.value = TextCellValue('Battery');

  var dcSpeedCell = sheet.cell(CellIndex.indexByString('L7'));
  dcSpeedCell.value = TextCellValue('Speed');
}

void disconnectDataExcel(Sheet sheet, String col, Device data) {
  var dcTimeDataCell = sheet.cell(CellIndex.indexByString('H' + col));
  dcTimeDataCell.value = TextCellValue(timeNow);

  var dcPositionDataCell = sheet.cell(CellIndex.indexByString('I' + col));
  dcPositionDataCell.value =
      TextCellValue(data.x.toString() + (",") + data.y.toString());

  String statusLiDAR =
      (data.lidarStatus.toString() == "0") ? 'Error' : 'Connect';
  var dcLiDARDataCell = sheet.cell(CellIndex.indexByString('J' + col));
  dcLiDARDataCell.value = TextCellValue(statusLiDAR);

  var dcBatteryDataCell = sheet.cell(CellIndex.indexByString('K' + col));
  dcBatteryDataCell.value = TextCellValue(data.battery.toString() + ("%"));

  var dcSpeedDataCell = sheet.cell(CellIndex.indexByString('L' + col));
  dcSpeedDataCell.value = TextCellValue(data.speed.toString() + ('km/h'));
}

void stopHeaderExcel(Sheet sheet) {
  var stopTitleCell = sheet.cell(CellIndex.indexByString('P6'));
  stopTitleCell.value = TextCellValue('Stop');

  var stopTimeCell = sheet.cell(CellIndex.indexByString('N7'));
  stopTimeCell.value = TextCellValue('Time');

  var stopPositionCell = sheet.cell(CellIndex.indexByString('O7'));
  stopPositionCell.value = TextCellValue('Position');

  var stopLiDARCell = sheet.cell(CellIndex.indexByString('P7'));
  stopLiDARCell.value = TextCellValue('LiDAR');

  var stopBatteryCell = sheet.cell(CellIndex.indexByString('Q7'));
  stopBatteryCell.value = TextCellValue('Battery');

  var stopSpeedCell = sheet.cell(CellIndex.indexByString('R7'));
  stopSpeedCell.value = TextCellValue('Speed');

  var stopReasonCell = sheet.cell(CellIndex.indexByString('S7'));
  stopReasonCell.value = TextCellValue('Reason');
}

void stopDataExcel(Sheet sheet, String col, Device data) {
  var stopTimeDataCell = sheet.cell(CellIndex.indexByString('N' + col));
  stopTimeDataCell.value = TextCellValue(timeNow);

  var stopPositionDataCell = sheet.cell(CellIndex.indexByString('O' + col));
  stopPositionDataCell.value =
      TextCellValue(data.x.toString() + (",") + data.y.toString());

  String statusLiDAR =
      (data.lidarStatus.toString() == "0") ? 'Error' : 'Connect';
  var stopLiDARDataCell = sheet.cell(CellIndex.indexByString('P' + col));
  stopLiDARDataCell.value = TextCellValue(statusLiDAR);

  var stopBatteryDataCell = sheet.cell(CellIndex.indexByString('Q' + col));
  stopBatteryDataCell.value = TextCellValue(data.battery.toString() + ('%'));

  var stopSpeedDataCell = sheet.cell(CellIndex.indexByString('R' + col));
  stopSpeedDataCell.value = TextCellValue(data.speed.toString() + ('km/h'));

  var stopReasonDataCell = sheet.cell(CellIndex.indexByString('S' + col));
  stopReasonDataCell.value = TextCellValue('Null Reason');
}

void totalHeaderExcel(Sheet sheet) {
  var totalTitleCell = sheet.cell(CellIndex.indexByString('W6'));
  totalTitleCell.value = TextCellValue('Total');

  var totalJobCell = sheet.cell(CellIndex.indexByString('U7'));
  totalJobCell.value = TextCellValue('Job');

  var totalRunningCell = sheet.cell(CellIndex.indexByString('V7'));
  totalRunningCell.value = TextCellValue('Running');

  var totalDisconnectCell = sheet.cell(CellIndex.indexByString('W7'));
  totalDisconnectCell.value = TextCellValue('Disconnect');

  var totalStopCell = sheet.cell(CellIndex.indexByString('X7'));
  totalStopCell.value = TextCellValue('Stop');

  var totalLiDARFailureCell = sheet.cell(CellIndex.indexByString('Y7'));
  totalLiDARFailureCell.value = TextCellValue('LiDAR Failure');
}

void totalDataExcel(
  Sheet sheet,
  String col, {
  required String runCount,
  required String disconnectCount,
  required String stopCount,
  required String lidarCount,
}) {
  var jobCount = int.parse(runCount) + int.parse(stopCount);
  //+ int.parse(disconnectCount);
  var totalJobDataCell = sheet.cell(CellIndex.indexByString(('U') + col));
  totalJobDataCell.value = TextCellValue(jobCount.toString());

  var totalRunningDataCell = sheet.cell(CellIndex.indexByString(('V') + col));
  totalRunningDataCell.value = TextCellValue(runCount);

  var totalDisconnectDataCell =
      sheet.cell(CellIndex.indexByString(('W') + col));
  totalDisconnectDataCell.value = TextCellValue(disconnectCount);

  var totalStopDataCell = sheet.cell(CellIndex.indexByString(('X') + col));
  totalStopDataCell.value = TextCellValue(stopCount);

  var totalLiDARFailureDataCell =
      sheet.cell(CellIndex.indexByString('Y' + col));
  totalLiDARFailureDataCell.value = TextCellValue(lidarCount);
}

Future<void> _writeExcelSettingsFile({
  required String id,
  required String run,
  required String dis,
  required String stop,
  required String total,
  required String runCount,
  required String disconnectCount,
  required String stopCount,
  required String lidarCount,
}) async {
  // format header|ColIndex|rowIndexString#header|rowIndex|ColIndexString
  await writeExcelSettingsFile(
    id,
    ('running|A|') +
        run +
        ('#disconnect|H|') +
        dis +
        ('#stop|N|') +
        stop +
        ('#total|U|') +
        total +
        ('|') +
        runCount + //3
        ('|') +
        disconnectCount + //4
        ('|') +
        stopCount + // 5
        ('|') +
        lidarCount, //6
  );
}

Future<Map<String, dynamic>> _excelSettingsFile({required Device data}) async {
  final resultExcelFile = await readExcelSettingsFile(data.amrId.toString());
  final splitResultExcelFile = resultExcelFile.split('#');

  final runningSplitResultExcelFile = splitResultExcelFile[0].split("|");
  final disconnectSplitResultExcelFile = splitResultExcelFile[1].split("|");
  final stopSplitResultExcelFile = splitResultExcelFile[2].split("|");
  final totalSplitResultExcelFile = splitResultExcelFile[3].split("|");

  return {
    'running': runningSplitResultExcelFile,
    'disconnect': disconnectSplitResultExcelFile,
    'stop': stopSplitResultExcelFile,
    'total': totalSplitResultExcelFile
  };
}

String get timeNow =>
    DateTime.now().hour.toString() + (":") + DateTime.now().minute.toString();

String get dateNow => DateTime.now().toLocal().toString();
