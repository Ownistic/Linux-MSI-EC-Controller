

import 'package:flutter/material.dart';

import 'card_speed.dart';
import 'card_temp.dart';

class TopCard extends StatelessWidget {
  final int? cpuTemp;
  final int? gpuTemp;
  final double? cpuFanSpeed;
  final double? gpuFanSpeed;
  final int? cpuFanSpeedPercent;
  final int? gpuFanSpeedPercent;
  final int? maxCpuTemp;
  final int? maxGpuTemp;

  const TopCard({
    super.key,
    this.cpuTemp,
    this.gpuTemp,
    this.cpuFanSpeed,
    this.gpuFanSpeed,
    this.cpuFanSpeedPercent,
    this.gpuFanSpeedPercent,
    this.maxCpuTemp,
    this.maxGpuTemp,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        CardTemp(
          text: 'CPU Temp',
          temp: cpuTemp,
          maxTemp: maxCpuTemp,
        ),
        CardTemp(
          text: 'GPU Temp',
          temp: gpuTemp,
          maxTemp: maxGpuTemp,
        ),
        CardSpeed(
          text: 'CPU Fan Speed',
          speed: cpuFanSpeed,
          speedPercent: cpuFanSpeedPercent,
        ),
        CardSpeed(
          text: 'GPU Fan Speed',
          speed: gpuFanSpeed,
          speedPercent: gpuFanSpeedPercent,
        ),
      ],
    );
  }
}