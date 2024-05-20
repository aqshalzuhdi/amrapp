part of 'page.dart';

// ignore: must_be_immutable
class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  final TCPSocketServer _tcpServer = TCPSocketServer();

  List<Device> deviceList = List.empty(growable: true);
  double x = 0, y = 0.0, rDegree = 0, scale = 1;
  double xAlignment = 0, yAlignment = 0;
  double anchorTopY = -0.3, anchorBottomY = 0.26;
  int tempAMRID = 0, intervalDisconnectDelay = 10;

  Future<void> setData(BuildContext context, Device device) async {
    try {
      if (readDataByAmrID(device.amrId!) == null) {
        await addData(device);
      } else {
        await updateData(device.amrId!, device);
      }

      deviceList = readAllData();
      context.read<DeviceCubit>().Fetch(
            isError: false,
            message: '',
            device: deviceList,
          );
    } catch (e) {
      writeLogFile(
        "app.log",
        "logs",
        DateTime.now().toLocal().toString() +
            (" | SetData() Exception ") +
            e.toString(),
      );
    }
  }

  void tcpServer(BuildContext context) async {
    try {
      deviceInitTCP();
      await _tcpServer.initServer(
        onData: (ip, sourcePort, event) async {
          try {
            var split = [], detailAMR = [], device = [], coordinate = [];

            split = event.data.split('#');
            detailAMR = split[0].split(',');
            device = split[1].split('|');
            coordinate = device[4].split(',');

            double coordinateX = double.parse(coordinate[0]);
            double coordinateY = double.parse(coordinate[1]);

            // writeLogFile(
            //   ("coordinate") + detailAMR[0].toString() + (".log"),
            //   "logs",
            //   DateTime.now().toLocal().toString() +
            //       (" | ") +
            //       coordinateX.toString() +
            //       (",") +
            //       coordinateY.toString(),
            // );

            await setData(
                context,
                Device(
                  amrId: detailAMR[0],
                  pointerColor: device[0],
                  speed: device[1],
                  lidarStatus: int.parse(device[2]),
                  battery: device[3],
                  x: (coordinateX.isNegative)
                      ? (coordinateX + xAlignment)
                      : (coordinateX - xAlignment),
                  y: (coordinateY.isNegative)
                      ? (coordinateY + yAlignment)
                      : (coordinateY - yAlignment),
                  degree: 0,
                  status: int.parse(split[2]),
                  time: DateTime.now().second,
                ));

            deviceList = readAllData();
          } catch (e) {
            writeLogFile(
              "app.log",
              "logs",
              ("[Exception] ") +
                  DateTime.now().toLocal().toString() +
                  (" | TCPServer() onData(): Exception ") +
                  e.toString(),
            );
          }
        },
        onDone: (ip, sourcePort) {
          writeLogFile(
            "connection.log",
            "logs",
            DateTime.now().toLocal().toString() + (" | Server disconnected"),
          );
        },
        onError: (error, ip, sourcePort) {
          writeLogFile(
            "connection.log",
            "logs",
            DateTime.now().toLocal().toString() + (" | Server error: $error"),
          );
          context.read<DeviceCubit>().Fetch(
                isError: true,
                message: '',
                device: List.empty(),
                // amrId: '0',
                // device: '',
                // status: 0,
                // message: error,
              );
        },
      );
    } catch (e) {
      writeLogFile(
        "app.log",
        "logs",
        ("[Exception] ") +
            DateTime.now().toLocal().toString() +
            (" | TCPServer() Exception ") +
            e.toString(),
      );
    }

    // return result;
  }

  void checkAMRAvailable(BuildContext context, TCPSocketServer tcpServer) {
    Timer.periodic(const Duration(milliseconds: 250), (timer) async {
      try {
        if (tcpServer.serverIsRunning) {
          int seconds = DateTime.now().second;
          deviceList = readAllData();
          for (var element in deviceList) {
            int intervalDisconnectValue = seconds - element.time!;
            if (element.time! <= seconds) {
              if ((intervalDisconnectValue % intervalDisconnectDelay) == 0 &&
                  intervalDisconnectValue > 0) {
                setData(
                    context,
                    Device(
                      amrId: element.amrId,
                      pointerColor: element.pointerColor,
                      speed: element.speed,
                      lidarStatus: element.lidarStatus,
                      battery: element.battery,
                      x: element.x,
                      y: element.y,
                      degree: element.degree,
                      status: 0,
                      time: element.time,
                    ));
              }
            } else if (element.time! >= seconds) {
              intervalDisconnectValue = element.time! - seconds;
              if ((intervalDisconnectValue % intervalDisconnectDelay) == 0 &&
                  intervalDisconnectValue > 0) {
                setData(
                    context,
                    Device(
                      amrId: element.amrId,
                      pointerColor: element.pointerColor,
                      speed: element.speed,
                      lidarStatus: element.lidarStatus,
                      battery: element.battery,
                      x: element.x,
                      y: element.y,
                      degree: element.degree,
                      status: 0,
                      time: element.time,
                    ));
              }
            } else {
              setData(
                  context,
                  Device(
                    amrId: element.amrId,
                    pointerColor: element.pointerColor,
                    speed: element.speed,
                    lidarStatus: element.lidarStatus,
                    battery: element.battery,
                    x: element.x,
                    y: element.y,
                    degree: element.degree,
                    status: element.status,
                    time: element.time,
                  ));
            }
          }
        }
      } catch (e) {
        writeLogFile(
          "app.log",
          "logs",
          ("[Exception] ") +
              DateTime.now().toLocal().toString() +
              (" | CheckAMRAvailable() Exception ") +
              e.toString(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    tcpServer(context);
    checkAMRAvailable(context, _tcpServer);

    return Scaffold(
      body: WindowBorder(
        color: Colors.black,
        width: 1,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff272831), Color(0xff272831)],
              stops: [0.0, 1.0],
            ),
          ),
          child: Column(
            children: [
              WindowTitleBarBox(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: Text(
                        'Automatic Mobile Robotic',
                        style: whiteTextStyle,
                      ),
                    ),
                    Expanded(child: MoveWindow()),
                    const WindowButtons()
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 50,
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Builder(builder: (context) {
                      // print("width: " +
                      //     (MediaQuery.of(context).size.width / 4).toString());
                      // print("height: " +
                      //     (MediaQuery.of(context).size.height / 1.2)
                      //         .toString());

                      // print("widthOrigin: " +
                      //     (MediaQuery.of(context).size.width).toString());
                      // print("heightOrigin: " +
                      //     (MediaQuery.of(context).size.height).toString());
                      return Container(
                        width: MediaQuery.of(context).size.width / 4,
                        height: MediaQuery.of(context).size.height / 1.2,
                        decoration: BoxDecoration(
                          color: kDarkColor,
                          borderRadius: BorderRadius.circular(24),
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AMR List',
                                style: whiteTextStyle.copyWith(fontSize: 16),
                              ),
                              const SizedBox(height: 24),
                              BlocBuilder<DeviceCubit, DeviceState>(
                                builder: (context, state) {
                                  if (state is DeviceSuccess) {
                                    print(state);
                                    // state.device.forEach((element) =>
                                    //     _textLogController.text = "{x: " +
                                    //         element.x.toString() +
                                    //         " y: " +
                                    //         element.y.toString() +
                                    //         "}");
                                    // state.device.map((e) => _textLogController.text = "{x: "+state.+"}");
                                    return Expanded(
                                      child: ListView(
                                        children: [
                                          Column(
                                            children: state.device
                                                .map((e) => AMRWidget(e: e))
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    MeasuredSize(
                      onChange: (Size size) {
                        // final width = size.width;
                        final height = size.height;
                        // 1026.1333333333334 684.6666666666667 laptop
                        // 1281.3333333333333 863.3333333333334 monitor
                        if (height >= 700) {
                          yAlignment = 0.04;
                          anchorTopY = -0.35;
                          anchorBottomY = 0.26;
                        }
                        if (height <= 700) {
                          yAlignment = 0;
                          anchorTopY = -0.3;
                          anchorBottomY = 0.26;
                        }
                        // Gunakan ukuran sesuai kebutuhan
                      },
                      child: Container(
                        // width: 1064,
                        // height: 680,
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: MediaQuery.of(context).size.height / 1.2,
                        decoration: BoxDecoration(
                          color: kDarkColor,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        clipBehavior: Clip.antiAlias,
                        // alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(48),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: 150,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: kWhiteColor)),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "ASSY",
                                          style: whiteTextStyle.copyWith(
                                            fontSize: 16,
                                            fontWeight: regular,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Divider(
                                        color: kWhiteColor,
                                        height: 2,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 80),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Divider(
                                        color: kWhiteColor,
                                        height: 2,
                                      ),
                                      const SizedBox(height: 24),
                                      Container(
                                        width: 150,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: kWhiteColor)),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "URD",
                                          style: whiteTextStyle.copyWith(
                                            fontSize: 16,
                                            fontWeight: regular,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // AnchorWidget(
                              //   alignment: Alignment(-0.8, anchorTopY),
                              //   color: kWhiteColor,
                              // ),
                              // AnchorWidget(
                              //   alignment: Alignment(-0.4, anchorTopY),
                              //   color: kWhiteColor,
                              // ),
                              // AnchorWidget(
                              //   alignment: Alignment(0, anchorTopY),
                              //   color: kWhiteColor,
                              // ),
                              // AnchorWidget(
                              //   alignment: Alignment(0.4, anchorTopY),
                              //   color: kWhiteColor,
                              // ),
                              // DONT USE AnchorWidget(
                              //   alignment: const Alignment(0.8, -0.3),
                              //   color: kWhiteColor,
                              // ),
                              //BOTTOM
                              // DONT USE AnchorWidget(
                              //   alignment: const Alignment(-0.8, 0.26),
                              //   color: kWhiteColor,
                              // ),
                              // AnchorWidget(
                              //   alignment: Alignment(-0.4, anchorBottomY),
                              //   color: kWhiteColor,
                              // ),
                              // AnchorWidget(
                              //   alignment: Alignment(0, anchorBottomY),
                              //   color: kWhiteColor,
                              // ),
                              // AnchorWidget(
                              //   alignment: Alignment(0.4, anchorBottomY),
                              //   color: kWhiteColor,
                              // ),
                              // AnchorWidget(
                              //   alignment: Alignment(0.8, anchorBottomY),
                              //   color: kWhiteColor,
                              // ),
                              BlocBuilder<DeviceCubit, DeviceState>(
                                builder: (context, state) {
                                  return (state is DeviceSuccess)
                                      ? Stack(
                                          fit: StackFit.expand,
                                          // clipBehavior: Clip.none,
                                          children: state.device.map((e) {
                                            Offset offsetAMR =
                                                Offset(e.x!, e.y!);
                                            return Align(
                                              alignment: Alignment(
                                                offsetAMR.dx,
                                                offsetAMR.dy,
                                              ),
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: kWhiteColor),
                                                      shape: BoxShape.circle,
                                                      color: Color(int.parse(
                                                          ("0xFF") +
                                                              e.pointerColor
                                                                  .toString())),
                                                    ),
                                                  ),
                                                  Text(
                                                    e.amrId.toString(),
                                                    style: whiteTextStyle
                                                        .copyWith(fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            );
                                            // return Positioned(
                                            //   left: offsetAMR.dx,
                                            //   // right: offsetAMR.dy,
                                            //   top: offsetAMR.dy,
                                            //   // bottom: offsetAMR.dy,
                                            //   child: Stack(
                                            //     alignment: Alignment.center,
                                            //     children: [
                                            //       Container(
                                            //         width: 30,
                                            //         height: 30,
                                            //         decoration: BoxDecoration(
                                            //           border: Border.all(
                                            //               color: kWhiteColor),
                                            //           shape: BoxShape.circle,
                                            //           color: Color(int.parse(
                                            //               ("0xFF") +
                                            //                   e.pointerColor
                                            //                       .toString())),
                                            //         ),
                                            //       ),
                                            //       Text(
                                            //         e.amrId.toString(),
                                            //         style: whiteTextStyle
                                            //             .copyWith(fontSize: 12),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // );
                                          }).toList())
                                      : const SizedBox();
                                  // : Align(
                                  //     alignment: Alignment(1, 0.15),
                                  //     child: Stack(
                                  //       alignment: Alignment.center,
                                  //       children: [
                                  //         Container(
                                  //           width: 30,
                                  //           height: 30,
                                  //           decoration: BoxDecoration(
                                  //             border: Border.all(
                                  //                 color: kWhiteColor),
                                  //             shape: BoxShape.circle,
                                  //             color: kWhatsAppColor,
                                  //           ),
                                  //         ),
                                  //         Text(
                                  //           'test',
                                  //           style: whiteTextStyle.copyWith(
                                  //               fontSize: 12),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   );
                                },
                              ),
                            ],
                          ),
                          // child: GridPaper(
                          // child: Stack(
                          //   // fit: StackFit.loose,
                          //   children: [
                          //     // CustomPaint(
                          //     //   painter: MyPainter(),
                          //     // ),
                          //     // Align(
                          //     //   alignment: const Alignment(0, 0),
                          //     //   child: MeasuredSize(
                          //     //     onChange: (Size size) {
                          //     //       setState(() {
                          //     //         print(size);
                          //     //       });
                          //     //     },
                          //     //     child: Image.asset(
                          //     //       'assets/mapscustom.png',
                          //     //       filterQuality: FilterQuality.high,
                          //     //       color: kWhiteColor,
                          //     //       // width: 1024,
                          //     //       // height: 680,
                          //     //     ),
                          //     //   ),
                          //     // ),
                          //     // AnchorWidget(
                          //     //   alignment: const Alignment(-0.8, -0.1),
                          //     //   color: kWhiteColor,
                          //     // ),
                          //     // AnchorWidget(
                          //     //   alignment: const Alignment(-0.5, 0.5),
                          //     //   color: kWhiteColor,
                          //     // ),
                          //     // AnchorWidget(
                          //     //   alignment: const Alignment(-0.2, -0.1),
                          //     //   color: kWhatsAppColor,
                          //     // ),
                          //     // Align(
                          //     //   alignment: const Alignment(0, 0),
                          //     //   child: Text(
                          //     //     '.',
                          //     //     style: whiteTextStyle.copyWith(fontSize: 36),
                          //     //   ),
                          //     // ),
                          //     // Align(
                          //     //   alignment: const Alignment(0, 1),
                          //     //   child: Text(
                          //     //     '.',
                          //     //     style:
                          //     //         whatsAppTextStyle.copyWith(fontSize: 36),
                          //     //   ),
                          //     // ),
                          //     // Align(
                          //     //   alignment: const Alignment(1, 0),
                          //     //   child: Text(
                          //     //     '.',
                          //     //     style: yellowTextStyle.copyWith(fontSize: 36),
                          //     //   ),
                          //     // ),
                          //     // AnchorWidget(
                          //     //   alignment: const Alignment(0.2, 0.5),
                          //     //   color: kWhiteColor,
                          //     // ),
                          //     // AnchorWidget(
                          //     //   alignment: const Alignment(0.5, -0.1),
                          //     //   color: kWhiteColor,
                          //     // ),
                          //     // AnchorWidget(
                          //     //   alignment: const Alignment(0.8, 0.5),
                          //     //   color: kWhiteColor,
                          //     // ),
                          //     Container(
                          //       // width: MediaQuery.of(context).size.width / 5,
                          //       // height:
                          //       //     MediaQuery.of(context).size.height / 2.5,
                          //       margin: EdgeInsets.only(
                          //         top: MediaQuery.of(context).size.height / 3.6,
                          //         bottom: MediaQuery.of(context).size.height / 8,
                          //       ),
                          //       child: Container(
                          //         // decoration: BoxDecoration(
                          //         //   border: Border.all(
                          //         //     color: kWhiteColor,
                          //         //   ),
                          //         // ),
                          //         child: BlocBuilder<DeviceCubit, DeviceState>(
                          //           builder: (context, state) {
                          //             // print("container media W" +
                          //             //     (MediaQuery.of(context).size.width /
                          //             //             1.5)
                          //             //         .toString());
                          //             // print("container media H" +
                          //             //     (MediaQuery.of(context).size.height /
                          //             //             1.2)
                          //             //         .toString());

                          //             // print("media W" +
                          //             //     (MediaQuery.of(context).size.width)
                          //             //         .toString());
                          //             // print("media H" +
                          //             //     (MediaQuery.of(context).size.height)
                          //             //         .toString());
                          //             // x = (x >= 0.5) ? 0.5 : x + 0.03;

                          //             // print(('xy: ') + x.toString());
                          //             // print(('yx: ') + y.toString());
                          //             // print(
                          //             //     ('xy rDegree: ') + rDegree.toString());
                          //             // if (x >= 0.60) {
                          //             //   print('xy if nol');

                          //             //   //rotate to top route
                          //             //   if (x <= 0.66) {
                          //             //     rDegree = -64;

                          //             //     if (y <= -0.12) {
                          //             //       rDegree = 0;
                          //             //       x += 0.02;
                          //             //     } else {
                          //             //       y -= 0.02;
                          //             //     }
                          //             //   }

                          //             //   //rotate to right route and follow straight the route
                          //             //   if (x > 0.66 && x <= 0.92) {
                          //             //     rDegree = 0;
                          //             //     x += 0.02;
                          //             //   }

                          //             //   //rotate to bottom route
                          //             //   if (x >= 0.92 && y <= -0.11) {
                          //             //     rDegree = 35;
                          //             //     y += 0.009;

                          //             //     // if (y <= -0.109) rDegree = 38;
                          //             //   }

                          //             //   //follow the route
                          //             //   if (x >= 0.92 && y <= 1) {
                          //             //     print("nomor: " + y.toString());
                          //             //     if (rDegree == 35 && y <= -0.98) {
                          //             //       rDegree = 10;
                          //             //       y += 0.01;
                          //             //       if (y <= -0.98) rDegree = 8;
                          //             //     }
                          //             //     if (rDegree == 10 && y >= -0.88) {
                          //             //       // rDegree = 8;
                          //             //       y += 0.01;
                          //             //       if (y >= -0.88) rDegree = 20;
                          //             //     }
                          //             //     if (rDegree == 20 && y >= -0.018) {
                          //             //       // rDegree = 20;
                          //             //       y += 0.01;
                          //             //     }
                          //             //   }

                          //             //   // if(y >)

                          //             //   // if (y >= -0.1) {
                          //             //   //   rDegree = 0;
                          //             //   //   print('xy if pertama');
                          //             //   //   // y += 0.02;
                          //             //   // } else if (y >= -0.2) {
                          //             //   //   print('xy elseif pertama');
                          //             //   //   // rDegree = 0;
                          //             //   //   if (x >= 0.91) {
                          //             //   //     rDegree = 64;

                          //             //   //     print('xy if keduua');

                          //             //   //     if (y >= 0.5) {
                          //             //   //       print('xy if ketiga');
                          //             //   //       rDegree = 50;
                          //             //   //     } else {
                          //             //   //       print('xy else ketiga');
                          //             //   //       y += 0.02;
                          //             //   //       // print("aku disini");
                          //             //   //     }
                          //             //   //   } else {
                          //             //   //     x += 0.02;

                          //             //   //     print('xy else kedua');
                          //             //   //   }
                          //             //   // } else {
                          //             //   //   y -= 0.02;
                          //             //   //   print('xy else pertama');

                          //             //   //   // print("ternyata disini");
                          //             //   // }
                          //             // } else {
                          //             //   x += 0.03;

                          //             //   print('xy else nol');
                          //             // }
                          //             // return MyHomePage();
                          //             // print("xy: " +
                          //             //     x.toString() +
                          //             //     ", " +
                          //             //     y.toString());

                          //             // print((state is DeviceSuccess)
                          //             //     ? state.device
                          //             //     : []);

                          //             // print(("device: ") +
                          //             //     ((state is DeviceSuccess)
                          //             //             ? (state as DeviceSuccess)
                          //             //                 .device
                          //             //             : "")
                          //             //         .toString());

                          //             rDegree = 0;

                          //             // Offset offsetAMR =
                          //             //     const Offset(250, 160);

                          //             // Timer.periodic(
                          //             //     Duration(milliseconds: 100), (timer) {
                          //             //   // Simulasi nilai ticks encoder (di sini bisa diambil dari sensor encoder sesungguhnya)
                          //             //   x++;
                          //             //   y++;

                          //             //   // Print hasil odometry
                          //             //   // print(
                          //             //   //     'X: ${x}, Y: ${y}, degree: ${rDegree}');
                          //             //   setState(() {});
                          //             // });

                          //             return (state is DeviceSuccess)
                          //                 ? Stack(
                          //                     fit: StackFit.expand,
                          //                     // clipBehavior: Clip.none,
                          //                     children: state.device.map((e) {
                          //                       Offset offsetAMR =
                          //                           Offset(e.x!, e.y!);
                          //                       return Positioned(
                          //                         left: offsetAMR.dx,
                          //                         // right: offsetAMR.dy,
                          //                         top: offsetAMR.dy,
                          //                         // bottom: offsetAMR.dy,
                          //                         child: Stack(
                          //                           alignment: Alignment.center,
                          //                           children: [
                          //                             Container(
                          //                               width: 30,
                          //                               height: 30,
                          //                               decoration: BoxDecoration(
                          //                                 border: Border.all(
                          //                                     color: kWhiteColor),
                          //                                 shape: BoxShape.circle,
                          //                                 color: Color(int.parse(
                          //                                     ("0xFF") +
                          //                                         e.pointerColor
                          //                                             .toString())),
                          //                               ),
                          //                             ),
                          //                             Text(
                          //                               e.amrId.toString(),
                          //                               style: whiteTextStyle
                          //                                   .copyWith(
                          //                                       fontSize: 12),
                          //                             ),
                          //                           ],
                          //                         ),
                          //                       );
                          //                       // return AnimatedPositioned(
                          //                       //   // width: 0.0,
                          //                       //   // left: 250,
                          //                       //   // top: 250,
                          //                       //   left: offsetAMR.dx,
                          //                       //   top: offsetAMR.dy,
                          //                       //   // top: 1,
                          //                       //   // right: -10,
                          //                       //   // bottom: 50,
                          //                       //   duration: const Duration(
                          //                       //       seconds: 2),
                          //                       //   curve: Curves.linear,
                          //                       //   child: AnimatedBuilder(
                          //                       //     animation:
                          //                       //         animationController,
                          //                       //     builder:
                          //                       //         (context, widget) =>
                          //                       //             Transform.rotate(
                          //                       //       angle: e.degree! / 360,
                          //                       //       child: Container(
                          //                       //         width: 20,
                          //                       //         height: 20,
                          //                       //         // child: Icon(CustomIcons.option, size: 20,),
                          //                       //         decoration:
                          //                       //             BoxDecoration(
                          //                       //           shape:
                          //                       //               BoxShape.circle,
                          //                       //           color: Color(int
                          //                       //               .parse(("0xFF") +
                          //                       //                   e.pointerColor
                          //                       //                       .toString())),
                          //                       //         ),
                          //                       //       ),
                          //                       //       // SizedBox(
                          //                       //       //   // height: 150.0,
                          //                       //       //   width: 20.0,
                          //                       //       //   height: 20.0,
                          //                       //       //   child: Transform.scale(
                          //                       //       //     scale: 1,
                          //                       //       //     child: Image.asset(
                          //                       //       //       'assets/amrpointerreal.jpg',
                          //                       //       //     ),
                          //                       //       //   ),
                          //                       //       // ),
                          //                       //     ),
                          //                       //     child: const SizedBox(
                          //                       //         // height: 150.0,
                          //                       //         // width: 60.0,
                          //                       //         // height: 60.0,
                          //                       //         // child: Transform.scale(
                          //                       //         //   scale: 1,
                          //                       //         //   child: Image.asset(
                          //                       //         //     'assets/amrpointerreal.jpg',
                          //                       //         //   ),
                          //                       //         // ),
                          //                       //         ),
                          //                       //   ),
                          //                       // );
                          //                       // Align(
                          //                       //   alignment:
                          //                       //       Alignment(e.x!, e.y!),
                          //                       //   child:
                          //                       //       new RotationTransition(
                          //                       //     turns:
                          //                       //         new AlwaysStoppedAnimation(
                          //                       //             rDegree / 360),
                          //                       //     child: Transform.scale(
                          //                       //       scaleX: scale,
                          //                       //       child: Image.asset(
                          //                       //         'assets/amrpointerreal.jpg',
                          //                       //         width: 60,
                          //                       //         // color: Color(int.parse(
                          //                       //         //     ("0xFF") +
                          //                       //         //         e.pointerColor
                          //                       //         //             .toString())),
                          //                       //       ),
                          //                       //     ),
                          //                       //   ),
                          //                       // ),
                          //                     }).toList())
                          //                 // : AnimatedPositioned(
                          //                 //     // width: 0.0,
                          //                 //     // left: 250,
                          //                 //     // top: 250,
                          //                 //     left: x,
                          //                 //     top: y,
                          //                 //     // top: 1,
                          //                 //     // right: -10,
                          //                 //     // bottom: 50,
                          //                 //     duration:
                          //                 //         const Duration(seconds: 2),
                          //                 //     curve: Curves.linear,
                          //                 //     child: AnimatedBuilder(
                          //                 //       animation: animationController,
                          //                 //       builder: (context, widget) =>
                          //                 //           Transform.rotate(
                          //                 //         angle: rDegree / 360,
                          //                 //         child: SizedBox(
                          //                 //           // height: 150.0,
                          //                 //           width: 60.0,
                          //                 //           height: 60.0,
                          //                 //           child: Transform.scale(
                          //                 //             scale: 1,
                          //                 //             child: Image.asset(
                          //                 //               'assets/amrpointerreal.jpg',
                          //                 //             ),
                          //                 //           ),
                          //                 //         ),
                          //                 //       ),
                          //                 //       child: const SizedBox(
                          //                 //           // height: 150.0,
                          //                 //           // width: 60.0,
                          //                 //           // height: 60.0,
                          //                 //           // child: Transform.scale(
                          //                 //           //   scale: 1,
                          //                 //           //   child: Image.asset(
                          //                 //           //     'assets/amrpointerreal.jpg',
                          //                 //           //   ),
                          //                 //           // ),
                          //                 //           ),
                          //                 //     ),
                          //                 //   );
                          //                 : const SizedBox();
                          //             // : Align(
                          //             //     alignment: Alignment(x, y),
                          //             //     child: new RotationTransition(
                          //             //       turns: new AlwaysStoppedAnimation(
                          //             //           rDegree / 360),
                          //             //       child: Transform.scale(
                          //             //         scaleX: scale,
                          //             //         child: Image.asset(
                          //             //           'assets/amrpointerreal.jpg',
                          //             //           width: 60,
                          //             //           // color: Color(int.parse(
                          //             //           //     ("0xFF") +
                          //             //           //         e.pointerColor
                          //             //           //             .toString())),
                          //             //         ),
                          //             //       ),
                          //             //     ),
                          //             //   );
                          //           },
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        // child: Expanded(
        //   child:
        // ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  //         <-- CustomPainter class
  @override
  void paint(Canvas canvas, Size size) {
    //                                             <-- Insert your painting code here.
    final p1 = Offset(700, 100);
    final p2 = Offset(50, 100);
    final paint = Paint()
      ..color = kWhiteColor
      ..strokeWidth = 2;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
