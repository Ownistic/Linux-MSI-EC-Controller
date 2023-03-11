import 'dart:io';
import 'dart:typed_data';

import 'ec_map.dart';


class EcReader {
  final String _ecPath;
  late Uint8List _ecFile;

  EcReader({String ecPath = '/dev/ec'}) : _ecPath = ecPath;

  Future<void> readFile() async {
    _ecFile = await File(_ecPath).readAsBytes();
  }

  Future<EcValues> getValues() async {
    await readFile();

    int cpuTemp = _ecFile[ECMap.cpuTemp];
    double cpuFanSpeed = 478000 / _ecFile[ECMap.cpuFanSpeed];
    int cpuFanSpeedPercent = _ecFile[ECMap.cpuFanSpeedPercent];

    int gpuTemp = _ecFile[ECMap.gpuTemp];
    double gpuFanSpeed = _ecFile[ECMap.gpuFanSpeed] > 0 ? 478000 / _ecFile[ECMap.gpuFanSpeed] : 0;
    int gpuFanSpeedPercent = _ecFile[ECMap.gpuFanSpeedPercent];

    bool turbo = _ecFile[ECMap.turbo] == 0x80;

    ProfileValues cpuProfile = ProfileValues(_getCpuProfileTemps(), _getCpuProfileSpeeds());
    ProfileValues gpuProfile = ProfileValues(_getGpuProfileTemps(), _getGpuProfileSpeeds());

    return EcValues(
      cpuTemp,
      cpuFanSpeed,
      cpuFanSpeedPercent,
      gpuTemp,
      gpuFanSpeed,
      gpuFanSpeedPercent,
      turbo,
      cpuProfile,
      gpuProfile,
    );
  }

  List<int> _getCpuProfileTemps() {
    List<int> temps = ECMap.cpuTemps
        .map((pos) => _ecFile[pos]).toList();

    return temps;
  }

  List<int> _getCpuProfileSpeeds() {
    List<int> temps = ECMap.cpuSpeeds
        .map((pos) => _ecFile[pos]).toList();

    return temps;
  }

  List<int> _getGpuProfileTemps() {
    List<int> temps = ECMap.gpuTemps
        .map((pos) => _ecFile[pos]).toList();

    return temps;
  }

  List<int> _getGpuProfileSpeeds() {
    List<int> temps = ECMap.gpuSpeeds
        .map((pos) => _ecFile[pos]).toList();

    return temps;
  }
}

class EcValues {
  final int cpuTemp;
  final double cpuFanSpeed;
  final int cpuFanSpeedPercent;
  final int gpuTemp;
  final double gpuFanSpeed;
  final int gpuFanSpeedPercent;
  final bool turbo;
  final ProfileValues cpuProfile;
  final ProfileValues gpuProfile;

  EcValues(
    this.cpuTemp,
    this.cpuFanSpeed,
    this.cpuFanSpeedPercent,
    this.gpuTemp,
    this.gpuFanSpeed,
    this.gpuFanSpeedPercent,
    this.turbo,
    this.cpuProfile,
    this.gpuProfile,
  );
}

class ProfileValues {
  final List<int> temps;
  final List<int> speeds;

  ProfileValues(
    this.temps,
    this.speeds,
  );
}