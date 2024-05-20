part of 'widget.dart';

class AMRWidget extends StatelessWidget {
  final Device e;
  const AMRWidget({super.key, required this.e});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // width: 200,
          // height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: kWhiteColor, width: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/amrpoint2.png',
                      height: 28,
                      width: 28,
                      color: Color(
                          int.parse(("0xFF") + e.pointerColor.toString())),
                    ),
                    const SizedBox(width: 14),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ('AMR-') + e.amrId.toString(),
                            style: whiteTextStyle.copyWith(
                                fontSize: 14, fontWeight: bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              // Text(
                              //   ('AMR-') +
                              //       e.amrId.toString() +
                              //       " AMR TEST BALBALBLABALBABLA",
                              //   style: whiteTextStyle.copyWith(
                              //       fontSize: 14, fontWeight: bold),
                              //   overflow: TextOverflow.ellipsis,
                              //   maxLines: 1,
                              // ),
                              // const SizedBox(width: 8),
                              // Text(
                              //   '⚈',
                              //   style: whiteTextStyle.copyWith(fontSize: 14, color: (e.status == 0) ? kRedColor : ((e.status == 1) ? kWhatsAppColor : kGreyColor)),
                              // ),
                              // Text(
                              //   '⚈',
                              //   style: whiteTextStyle
                              //       .copyWith(
                              //           fontSize:
                              //               14,
                              //           color:
                              //               kRedColor),
                              // ),
                              // Text(
                              //   '⚈',
                              //   style: whiteTextStyle
                              //       .copyWith(
                              //           fontSize:
                              //               14,
                              //           color:
                              //               kGreyColor),
                              // ),
                              // SizedBox(width: 8),
                              // Text(
                              //   'green: run, red: stop with reason, grey: idle',
                              //   style: whiteTextStyle
                              //       .copyWith(
                              //           fontSize: 12),
                              // ),
                            ],
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Row(
                            children: [
                              Text(
                                '⚈',
                                style: whiteTextStyle.copyWith(
                                    fontSize: 14,
                                    color: (e.status == 0)
                                        ? kRedColor
                                        : ((e.status == 1)
                                            ? kWhatsAppColor
                                            : ((e.status == 2)
                                                ? kGreyColor
                                                : kRedColor))),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  (e.status == 0)
                                      ? 'Disconnected'
                                      : ((e.status == 1)
                                          ? 'Running'
                                          : ((e.status == 2)
                                              ? 'Idle'
                                              : 'Stop')),
                                  style: whiteTextStyle.copyWith(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          // Text(
                          //   'slider speed',
                          //   style: whiteTextStyle,
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Text(
                            '11:00',
                            style: whiteTextStyle.copyWith(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Started',
                              style: whatsAppTextStyle.copyWith(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width / 11.8),
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Finished',
                              style: whatsAppTextStyle.copyWith(
                                  fontSize: 12,
                                  color: kWhiteColor.withOpacity(0.5)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '11:06',
                            style: whiteTextStyle.copyWith(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(
              //     height: 8),
              Divider(
                color: kWhiteColor,
                thickness: 0.5,
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                  left: 16,
                  right: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/icons8-cctv-16.png',
                            color: (e.lidarStatus == 0)
                                ? kRedColor
                                : ((e.lidarStatus == 2)
                                    ? kYellowColor
                                    : kWhatsAppColor) //kYellowColor, //kRedColor, //kWhatsAppColor,
                            ),
                        // SizedBox(width: 8),
                        // Text(
                        //   'Connected',
                        //   style: whiteTextStyle.copyWith(
                        //     fontSize: 12,
                        //     color: kWhiteColor,
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/mdi_speedometer.png',
                            color: kWhiteColor,
                            width: 14,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              e.speed.toString() + (' km/h'),
                              style: whiteTextStyle.copyWith(
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Column(
                    //   children: [
                    //     Text(
                    //       e.speed.toString() +
                    //           'km/j',
                    //       style:
                    //           whiteTextStyle.copyWith(fontSize: 12),
                    //     ),
                    //     Text(
                    //       'Kecepatan',
                    //       style:
                    //           whiteTextStyle.copyWith(fontSize: 14),
                    //     ),
                    //   ],
                    // ),
                    // Column(
                    //   children: [
                    //     Text(
                    //       (e.lidarStatus == 1)
                    //           ? '[ON]'
                    //           : '[OFF]',
                    //       style:
                    //           whiteTextStyle.copyWith(fontSize: 12),
                    //     ),
                    //     Text(
                    //       'Status Lidar',
                    //       style:
                    //           whiteTextStyle.copyWith(fontSize: 14),
                    //     ),
                    //   ],
                    // ),
                    BatteryIndicatorWidget(
                        battery: int.parse(e.battery.toString())),
                    // Column(
                    //   children: [
                    //     Text(
                    //       e.battery.toString() +
                    //           '%',
                    //       style:
                    //           whiteTextStyle.copyWith(fontSize: 12),
                    //     ),
                    //     Text(
                    //       'Baterai',
                    //       style:
                    //           whiteTextStyle.copyWith(fontSize: 14),
                    //     ),
                    //   ],
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}
