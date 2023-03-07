import 'package:flutter/material.dart';

class CardSpeed extends StatefulWidget {
  final String text;
  final double? speed;
  final int? speedPercent;

  const CardSpeed({
    super.key,
    this.text = '',
    this.speed = 0,
    this.speedPercent = 0,
  });

  @override
  State<CardSpeed> createState() => _CardSpeed();
}

class _CardSpeed extends State<CardSpeed> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final Animation<double> rotation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  @override
  void initState() {
    super.initState();
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.speed == 0 && _controller.isAnimating) {
      _controller.stop();
    } else if (widget.speed != 0 && !_controller.isAnimating) {
      _controller.repeat();
    }

    double speed = (widget.speed ?? 1);
    speed = speed > 0 ? speed : 1;
    _controller.duration =
        Duration(milliseconds: (1 / speed * 3600 * 1000).toInt());

    if (_controller.isAnimating) {
      _controller.repeat();
    }

    return Expanded(
      child: Card(
        elevation: 5,
        child: Container(
          height: 150,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Wrap(
            direction: Axis.vertical,
            spacing: 15,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Wrap(
                spacing: 5,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  RotationTransition(
                    turns: rotation,
                    child: Image.asset(
                      'lib/src/assets/fan.png',
                      height: 25,
                      width: 25,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "${widget.speed?.toInt().toString()}",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1,
                      letterSpacing: 1),
                  ),
                  const Text(
                    "RPM",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      height: 1.5,
                      letterSpacing: 1),
                  ),
                ],
              ),
              Text(
                "${widget.speedPercent}%",
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
