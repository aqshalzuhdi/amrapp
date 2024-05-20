part of 'widget.dart';

class BatteryIndicatorWidget extends StatelessWidget {
  final int battery;
  const BatteryIndicatorWidget({super.key, required this.battery});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 14,
              height: 2,
              color: (battery < 90) ? kGreyColor : kWhatsAppColor,
              margin: const EdgeInsets.only(bottom: 2),
            ),
            Container(
              width: 14,
              height: 2,
              color: (battery < 70)
                  ? kGreyColor
                  : ((battery >= 95)
                      ? kWhatsAppColor
                      : ((battery < 60) ? kYellowColor : kWhatsAppColor)),
              margin: const EdgeInsets.only(bottom: 2),
            ),
            Container(
              width: 14,
              height: 2,
              color: (battery < 40)
                  ? kGreyColor
                  : ((battery >= 90)
                      ? kWhatsAppColor
                      : ((battery < 50) ? kYellowColor : kWhatsAppColor)),
              margin: const EdgeInsets.only(bottom: 2),
            ),
            Container(
              width: 14,
              height: 2,
              color: (battery < 20)
                  ? kRedColor
                  : ((battery >= 90)
                      ? kWhatsAppColor
                      : ((battery < 40)
                          ? kYellowColor
                          : ((battery < 20)
                              ? kRedColor
                              : ((battery < 50)
                                  ? kYellowColor
                                  : kWhatsAppColor)))),
              margin: const EdgeInsets.only(bottom: 2),
            ),
          ],
        ),
        SizedBox(width: 8),
        Text(
          battery.toString() + '%',
          style: whiteTextStyle.copyWith(fontSize: 12),
        ),
      ],
    );
  }
}
