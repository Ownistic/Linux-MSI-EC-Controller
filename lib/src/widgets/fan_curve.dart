import 'package:flutter/material.dart';
import 'package:linux_msi_ec_controller/src/providers/ec_reader.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FanCurve extends StatefulWidget {
  final ValueNotifier<ProfileValues?> fanProfile;
  final bool interactive;
  final ValueChanged<ProfileValues>? onApplyPressed;

  const FanCurve({
    Key? key,
    required this.fanProfile,
    this.interactive = false,
    this.onApplyPressed,
  }) : super(key: key);

  @override
  State<FanCurve> createState() => _FanCurveState();
}

class _FanCurveState extends State<FanCurve> {

  ChartSeriesController? seriesController;
  List<ChartData> _chartData = [];
  double _minimum = 45;
  int? _selectedPointIndex;
  bool _editing = false;

  @override
  void initState() {
    _chartData = [];
    mapChartData();
    widget.fanProfile.addListener(handleFanProfileChange);

    super.initState();
  }

  @override
  void dispose() {
    widget.fanProfile.removeListener(handleFanProfileChange);
    super.dispose();
  }

  void handleFanProfileChange() {
    setState(() {
      mapChartData();
      _editing = false;
    });
  }

  void mapChartData() {
    List<int> speeds = List.from(widget.fanProfile.value?.speeds ?? []);
    List<int> temps = List.from(widget.fanProfile.value?.temps ?? []);
    temps.insert(0, 0);

    _chartData = temps.map((temp) {
      final int index = temps.indexOf(temp);
      final int speed = speeds.length > index ? speeds[index] : 0;
      return ChartData(temp, speed);
    }).toList();

    if (_chartData.isNotEmpty) {
      _minimum = _chartData[0].temp < 45 ? _chartData[0].temp.toDouble() : 45;
    }
  }

  void findPointInChart(ChartTouchInteractionArgs args) {
    if (!widget.interactive) {
      return;
    }

    final Offset position = Offset(args.position.dx, args.position.dy);
    double minDistance = double.infinity;
    int? pointIndex;
    for (int i = 0; i < _chartData.length; i++) {
      final ChartData point = _chartData[i];
      final Offset pointPosition = seriesController!
          .pointToPixel(CartesianChartPoint(point.temp.toDouble(), point.speed.toDouble()));

      final double distance = (position - pointPosition).distanceSquared;

      if (distance < minDistance) {
        minDistance = distance;
        pointIndex = i;
      }
    }

    if (pointIndex != null) {
      setState(() {
        _selectedPointIndex = pointIndex;
        _editing = true;
      });
    }
  }

  void finishPointDrag(ChartTouchInteractionArgs args) {
    if (_selectedPointIndex == null) {
      return;
    }

    setState(() {
      _selectedPointIndex = null;
    });
  }

  void dragPoint(ChartTouchInteractionArgs args) {
    if (_selectedPointIndex != null) {
      final point = seriesController!.pixelToPoint(
          Offset(args.position.dx, args.position.dy));
      final int temp = _selectedPointIndex == 0 ? 0 : point.x.toInt().clamp(_minimum, 100).toInt();
      final int speed = point.y.toInt().clamp(0, 100).toInt();
      final newData = ChartData(temp, speed);
      setState(() {
        _chartData[_selectedPointIndex!] = newData;
      });
    }
  }

  ProfileValues buildFanProfile() {
    final ProfileValues newFanProfile = ProfileValues([], []);

    _chartData.asMap().forEach((index, element) {
      final int speed = element.speed;
      final int temp = element.temp;

      if (index == 0) {
        newFanProfile.speeds.add(speed);
        return;
      }

      newFanProfile.speeds.add(speed);
      newFanProfile.temps.add(temp);
    });

    return newFanProfile;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: SfCartesianChart(
            zoomPanBehavior: ZoomPanBehavior(),
            primaryXAxis: NumericAxis(
              maximum: 100,
              minimum: _minimum,
              labelFormat: '{value}°C',
              title: AxisTitle(
                text: "Temperature"
              )
            ),
            primaryYAxis: NumericAxis(
              maximum: 100,
              minimum: 0,
              labelFormat: '{value}%',
              title: AxisTitle(
                text: "Speed"
              )
            ),
            series: <ChartSeries>[
              LineSeries<ChartData, int>(
                onRendererCreated: (ChartSeriesController controller) {
                  seriesController = controller;
                },
                dataSource: _chartData,
                xAxisName: "Temperature",
                yAxisName: "Speed",
                xValueMapper: (ChartData data, _) => data.temp,
                yValueMapper: (ChartData data, _) => data.speed,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.rectangle
                ),
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true
                ),
              )
            ],
            onChartTouchInteractionDown: findPointInChart,
            onChartTouchInteractionUp: finishPointDrag,
            onChartTouchInteractionMove: dragPoint,
          ),
        ),
        if (_editing) Positioned(
          right: 5,
          bottom: 0,
          child: Wrap(
            spacing: 10,
            children: [
              ElevatedButton(
                onPressed: () {
                  mapChartData();
                  _editing = false;
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (widget.onApplyPressed != null) {
                    print("appling profile");
                    widget.onApplyPressed!(buildFanProfile());
                  }
                },
                child: const Text("Apply"),
              ),
            ],
          )
        ),
      ],
    );
  }
}

class ChartData {
  ChartData(this.temp, this.speed);
  final int temp;
  final int speed;
}