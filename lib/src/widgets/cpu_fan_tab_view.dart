import 'package:flutter/material.dart';

import 'package:linux_msi_ec_controller/src/providers/ec_reader.dart';
import 'package:linux_msi_ec_controller/src/widgets/fan_curve.dart';

class CpuFanTabView extends StatefulWidget {
  final ValueNotifier<ProfileValues?> cpuProfile;
  final ValueChanged<ProfileValues>? applyCpuProfile;

  const CpuFanTabView({
    Key? key,
    required this.cpuProfile,
    this.applyCpuProfile,
  }) : super(key: key);

  @override
  State<CpuFanTabView> createState() => _CpuFanTabViewState();
}

class _CpuFanTabViewState extends State<CpuFanTabView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
      child: FanCurve(
        fanProfile: widget.cpuProfile,
        interactive: true,
        onApplyPressed: widget.applyCpuProfile,
      )
    );
  }
}
