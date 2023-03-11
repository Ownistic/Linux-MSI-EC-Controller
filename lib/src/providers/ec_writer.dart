import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:linux_msi_ec_controller/src/providers/ec_reader.dart';

import 'ec_map.dart';


class EcWriter {
  final String _ecPath;
  late Uint8List _ecFile;

  EcWriter({String ecPath = '/dev/ec'}) : _ecPath = ecPath;

  Future<void> readFile() async {
    _ecFile = await File(_ecPath).readAsBytes();
  }

  Future<void> _writeFilePos(int pos, int value) async {
    if (!validatePosAndValue(pos, value)) {
      return;
    }

    await readFile();
    
    _ecFile[pos] = value;
    await File(_ecPath).writeAsBytes(
      _ecFile.buffer.asUint8List(),
      mode: FileMode.write,
    );
  }

  Future<void> _writeFileMap(Map<int, int> values) async {
    for (int pos in values.keys) {
      final int value = values[pos] ?? -1;
      if (!validatePosAndValue(pos, value)) {
        return;
      }
    }

    await readFile();
    values.forEach((pos, value) {
      _ecFile[pos] = value;
    });

    await File(_ecPath).writeAsBytes(
      _ecFile.buffer.asInt8List(),
      mode: FileMode.write,
    );
  }

  bool validatePosAndValue(int pos, int value) {
    if (pos < 0x0 || pos > 0xFF) {
      if (kDebugMode) {
        print("Error, the position is out of range");
      }
      return false;
    }

    if (value < 0x0 || value > 0xFF) {
      if (kDebugMode) {
        print("Error, the value is out of range");
      }
      return false;
    }

    return true;
  }

  void setTurboBost(bool enabled) {
    _writeFilePos(ECMap.turbo, enabled ? 0x80 : 0x02);
  }

  Future<void> applyCpuProfile(ProfileValues profile) async {
    if (profile.temps.length != ECMap.cpuTemps.length || profile.speeds.length != ECMap.cpuSpeeds.length) {
      return;
    }

    final Map<int, int> profileTempValues = {};
    for (int index = 0; index < profile.temps.length; index++) {
      int pos = ECMap.cpuTemps[index];
      int temp = profile.temps[index];
      profileTempValues[pos] = temp;
    }

    final Map<int, int> profileSpeedValues = {};
    for (int index = 0; index < profile.speeds.length; index++) {
      int pos = ECMap.cpuSpeeds[index];
      int speed = profile.speeds[index];
      profileSpeedValues[pos] = speed;
    }

    await _writeFileMap(profileTempValues);
    await _writeFileMap(profileSpeedValues);
  }

  Future<void> applyGpuProfile(ProfileValues profile) async {
    if (profile.temps.length != ECMap.gpuTemps.length || profile.speeds.length != ECMap.gpuSpeeds.length) {
      return;
    }

    final Map<int, int> profileTempValues = {};
    for (int index = 0; index < profile.temps.length; index++) {
      int pos = ECMap.gpuTemps[index];
      int temp = profile.temps[index];
      profileTempValues[pos] = temp;
    }

    final Map<int, int> profileSpeedValues = {};
    for (int index = 0; index < profile.speeds.length; index++) {
      int pos = ECMap.gpuSpeeds[index];
      int speed = profile.speeds[index];
      profileSpeedValues[pos] = speed;
    }

    await _writeFileMap(profileTempValues);
    await _writeFileMap(profileSpeedValues);
  }
}