import 'dart:io';
import 'dart:typed_data';


class EcReader {
  final String _ecPath;
  late Uint8List _ecFile;

  EcReader({String ecPath = '/dev/ec'}) : _ecPath = ecPath;

  Future<void> readFile() async {
    _ecFile = await File(_ecPath).readAsBytes();
  }

  Future<EcValues> getValues() async {
    await readFile();

    int cpuTemp = _ecFile[0x68];
    double cpuFanSpeed = 478000 / _ecFile[0xCD];
    int cpuFanSpeedPercent = _ecFile[0x71];

    int gpuTemp = _ecFile[0x80];
    double gpuFanSpeed = _ecFile[0xCB] > 0 ? 478000 / _ecFile[0xCB] : 0;
    int gpuFanSpeedPercent = _ecFile[0x89];

    bool turbo = _ecFile[0x98] == 0x80;

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
    List<int> temps = [];

    temps.add(_ecFile[0x6A]);
    temps.add(_ecFile[0x6B]);
    temps.add(_ecFile[0x6C]);
    temps.add(_ecFile[0x6D]);
    temps.add(_ecFile[0x6E]);
    temps.add(_ecFile[0x6F]);

    return temps;
  }

  List<int> _getCpuProfileSpeeds() {
    List<int> temps = [];

    temps.add(_ecFile[0x72]);
    temps.add(_ecFile[0x73]);
    temps.add(_ecFile[0x74]);
    temps.add(_ecFile[0x75]);
    temps.add(_ecFile[0x76]);
    temps.add(_ecFile[0x77]);
    temps.add(_ecFile[0x78]);

    return temps;
  }

  List<int> _getGpuProfileTemps() {
    List<int> temps = [];

    temps.add(_ecFile[0x82]);
    temps.add(_ecFile[0x83]);
    temps.add(_ecFile[0x84]);
    temps.add(_ecFile[0x85]);
    temps.add(_ecFile[0x86]);
    temps.add(_ecFile[0x87]);

    return temps;
  }

  List<int> _getGpuProfileSpeeds() {
    List<int> temps = [];

    temps.add(_ecFile[0x8A]);
    temps.add(_ecFile[0x8B]);
    temps.add(_ecFile[0x8C]);
    temps.add(_ecFile[0x8D]);
    temps.add(_ecFile[0x8E]);
    temps.add(_ecFile[0x8F]);
    temps.add(_ecFile[0x90]);

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