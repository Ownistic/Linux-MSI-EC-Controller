import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linux_msi_ec_controller/src/providers/ec_reader.dart';
import 'package:linux_msi_ec_controller/src/providers/ec_writer.dart';
import 'package:linux_msi_ec_controller/src/widgets/labeled_switch.dart';

import 'package:linux_msi_ec_controller/src/widgets/top_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ecReader = EcReader();
  final ecWriter = EcWriter();
  EcValues? _ecValues;
  int _maxCpuTemp = 0;
  int _maxGpuTemp = 0;
  late Timer _timer;
  
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  void deactivate() {
    super.deactivate();
    _timer.cancel();
  }

  @override
  void activate() {
    super.activate();
    if (_timer.isActive) {
      return;
    }

    startTimer();
  }

  void startTimer() {
    setState(() {
      _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        updateEcValues();
      });
    });
  }

  void updateEcValues() async {
    EcValues ecValues = await ecReader.getValues();
    setState(() {
      _ecValues = ecValues;
      _maxCpuTemp = ecValues.cpuTemp > _maxCpuTemp ? ecValues.cpuTemp : _maxCpuTemp;
      _maxGpuTemp = ecValues.gpuTemp > _maxGpuTemp ? ecValues.gpuTemp : _maxGpuTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Wrap(
          spacing: 20,
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            TopCard(
              cpuTemp: _ecValues?.cpuTemp,
              gpuTemp: _ecValues?.gpuTemp,
              maxCpuTemp: _maxCpuTemp,
              maxGpuTemp: _maxGpuTemp,
              cpuFanSpeed: _ecValues?.cpuFanSpeed,
              gpuFanSpeed: _ecValues?.gpuFanSpeed,
              cpuFanSpeedPercent: _ecValues?.cpuFanSpeedPercent,
              gpuFanSpeedPercent: _ecValues?.gpuFanSpeedPercent,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        LabeledSwitch(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          label: 'Turbo',
                          value: _ecValues?.turbo ?? false,
                          onChanged: (bool value) {
                            ecWriter.setTurboBost(value);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ]
        )
      )
    );
  }
}
