import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:linux_msi_ec_controller/src/providers/ec_reader.dart';
import 'package:linux_msi_ec_controller/src/providers/ec_writer.dart';
import 'package:linux_msi_ec_controller/src/widgets/bottom_section.dart';
import 'package:linux_msi_ec_controller/src/widgets/actions_bar.dart';

import 'package:linux_msi_ec_controller/src/widgets/top_section.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ecReader = EcReader();
  final ecWriter = EcWriter();

  EcValues? _ecValues;

  final ValueNotifier<ProfileValues?> _cpuProfile = ValueNotifier(null);
  final ValueNotifier<ProfileValues?> _gpuProfile = ValueNotifier(null);

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

      if (!listEquals(_cpuProfile.value?.temps, ecValues.cpuProfile.temps) || !listEquals(_cpuProfile.value?.speeds, ecValues.cpuProfile.speeds)) {
        _cpuProfile.value = ecValues.cpuProfile;
      }

      if (!listEquals(_gpuProfile.value?.temps, ecValues.gpuProfile.temps) || !listEquals(_gpuProfile.value?.speeds, ecValues.gpuProfile.speeds)) {
        _gpuProfile.value = ecValues.gpuProfile;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TopSection(
              cpuTemp: _ecValues?.cpuTemp,
              gpuTemp: _ecValues?.gpuTemp,
              maxCpuTemp: _maxCpuTemp,
              maxGpuTemp: _maxGpuTemp,
              cpuFanSpeed: _ecValues?.cpuFanSpeed,
              gpuFanSpeed: _ecValues?.gpuFanSpeed,
              cpuFanSpeedPercent: _ecValues?.cpuFanSpeedPercent,
              gpuFanSpeedPercent: _ecValues?.gpuFanSpeedPercent,
            ),
            Expanded(
              child: BottomSection(
                cpuProfile: _cpuProfile,
                gpuProfile: _gpuProfile,
                applyCpuProfile: (ProfileValues profile) {
                  ecWriter.applyCpuProfile(profile);
                },
                applyGpuProfile: (ProfileValues profile) {
                  ecWriter.applyGpuProfile(profile);
                }
              ),
            ),
            ActionsBar(
              turbo: _ecValues?.turbo ?? false,
              onTurboToggled: (bool value) {
                ecWriter.setTurboBost(value);
              },
            ),
          ]
        )
      )
    );

  }
}
