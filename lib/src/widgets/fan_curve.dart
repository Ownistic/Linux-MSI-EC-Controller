import 'package:flutter/material.dart';
import 'package:linux_msi_ec_controller/src/providers/ec_reader.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FanCurve extends StatefulWidget {
  final ProfileValues? fanProfile;
  const FanCurve({
    Key? key,
    this.fanProfile,
  }) : super(key: key);

  @override
  State<FanCurve> createState() => _FanCurveState();
}

class _FanCurveState extends State<FanCurve> {

  @override
  Widget build(BuildContext context) {
    List<ChartData> chartData = widget.fanProfile?.speeds.map((speed) {
      if (widget.fanProfile?.temps == null) {
        return ChartData(speed, 0);
      }

      int speedIndex = widget.fanProfile!.speeds.indexOf(speed);
      if (speedIndex >= widget.fanProfile!.temps.length) {
        speedIndex = widget.fanProfile!.temps.length - 1;
      }

      return ChartData(speed, widget.fanProfile!.temps[speedIndex]);
    }).toList() ?? [];

    chartData.insert(0, ChartData(0, 0));

    return SfCartesianChart(
      zoomPanBehavior: ZoomPanBehavior(),
      primaryXAxis: NumericAxis(
        maximum: 100,
        minimum: 45,
        labelFormat: '{value}°C'
      ),
      primaryYAxis: NumericAxis(
        maximum: 100,
        minimum: 0,
        labelFormat: '{value}%',
      ),
      series: <ChartSeries>[
        SplineSeries<ChartData, int>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          markerSettings: const MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.rectangle
          ),
          dataLabelSettings: const DataLabelSettings(
            isVisible: true
          )
        )
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final int? y;
}