part of 'widget.dart';

class AnchorWidget extends StatelessWidget {
  final Alignment alignment;
  final Color color;

  const AnchorWidget({
    super.key,
    required this.alignment,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Image.asset(
        'assets/anchor.png',
        // filterQuality: FilterQuality.high,
        color: color,
        width: 32,
      ),
    );
  }
}
