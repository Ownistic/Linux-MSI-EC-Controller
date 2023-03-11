import 'package:flutter/material.dart';
import 'package:linux_msi_ec_controller/src/providers/ec_reader.dart';

import 'fan_curve.dart';

class BottomSection extends StatefulWidget {
  final ValueNotifier<ProfileValues?> cpuProfile;
  final ValueNotifier<ProfileValues?> gpuProfile;
  final ValueChanged<ProfileValues>? applyCpuProfile;
  final ValueChanged<ProfileValues>? applyGpuProfile;

  const BottomSection({
    Key? key,
    required this.cpuProfile,
    required this.gpuProfile,
    this.applyCpuProfile,
    this.applyGpuProfile,
  }) : super(key: key);

  @override
  State<BottomSection> createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> with SingleTickerProviderStateMixin {
  static const List<Tab> bottomSectionTabs = <Tab>[
    Tab(text: 'CPU Fan Curve'),
    Tab(text: 'GPU Fan Curve'),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: bottomSectionTabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        child: Column(
          children: [
            TabBar(
              tabs: bottomSectionTabs,
              controller: _tabController,
            ),
            Expanded(
              child:
              TabBarView(
                controller: _tabController,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                    child: FanCurve(
                      fanProfile: widget.cpuProfile,
                      interactive: true,
                      onApplyPressed: widget.applyCpuProfile,
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                    child: FanCurve(
                      fanProfile: widget.gpuProfile,
                      interactive: true,
                      onApplyPressed: widget.applyGpuProfile,
                    )
                  ),
                ],
              )
            )
          ],
        )
      )
    );
  }
}
