import 'package:flutter/material.dart';

import 'package:linux_msi_ec_controller/src/providers/ec_reader.dart';
import 'package:linux_msi_ec_controller/src/widgets/fan_curve.dart';

class GpuFanTabView extends StatefulWidget {
  final ValueNotifier<ProfileValues?> gpuProfile;
  final ValueChanged<ProfileValues>? applyGpuProfile;

  const GpuFanTabView({
    Key? key,
    required this.gpuProfile,
    this.applyGpuProfile,
  }) : super(key: key);

  @override
  State<GpuFanTabView> createState() => _GpuFanTabViewState();
}

class _GpuFanTabViewState extends State<GpuFanTabView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
      child: FanCurve(
        fanProfile: widget.gpuProfile,
        interactive: true,
        onApplyPressed: widget.applyGpuProfile,
      )
    );
  }
}
