import 'package:flutter/material.dart';

class CardTemp extends StatelessWidget {
  final String text;
  final int? temp;
  final int? maxTemp;

  const CardTemp({
    super.key,
    this.text = '',
    this.temp = 0,
    this.maxTemp = 0,
  });

  Color? getTempColor(int? temp) {
    // TODO: Generate a color scale from blue to red
    return (temp == null) ? null :
      temp < 55 ? Colors.blue.shade400 :
      temp > 80 ? Colors.red.shade400 :
      null;
  }

  @override
  Widget build(BuildContext context) {
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
                text,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  Text(
                    "$temp",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: getTempColor(temp),
                      height: .8,
                      letterSpacing: 1
                    ),
                  ),
                  Text(
                    "°C",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: getTempColor(temp),
                      height: 1.5
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 10,
                children: [
                  const Text(
                    "Max:",
                  ),
                  Text(
                    "$maxTemp°C",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: getTempColor(maxTemp)
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}