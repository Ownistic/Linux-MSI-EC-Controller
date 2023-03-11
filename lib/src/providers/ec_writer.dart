import 'dart:io';
import 'dart:typed_data';

import 'ec_map.dart';


class EcWriter {
  final String _ecPath;
  late Uint8List _ecFile;

  EcWriter({String ecPath = '/dev/ec'}) : _ecPath = ecPath;

  Future<void> readFile() async {
    _ecFile = await File(_ecPath).readAsBytes();
  }

  Future<void> _writeFile(pos, value) async {
    await readFile();
    
    _ecFile[pos] = value;
    await File(_ecPath).writeAsBytes(
      _ecFile.buffer.asUint8List(),
      mode: FileMode.write,
    );
  }

  void setTurboBost(bool enabled) {
    _writeFilePos(ECMap.turbo, enabled ? 0x80 : 0x02);
  }
}