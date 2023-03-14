import 'package:flutter/material.dart';
import 'package:linux_msi_ec_controller/src/providers/ec_reader.dart';
import 'package:linux_msi_ec_controller/src/widgets/cpu_fan_tab_view.dart';
import 'package:linux_msi_ec_controller/src/widgets/gpu_fan_tab_view.dart';

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
    _tabController = TabController(vsync: this, length: bottomSectionTabs.length);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                  CpuFanTabView(
                    cpuProfile: widget.cpuProfile,
                    applyCpuProfile: widget.applyCpuProfile,
                  ),
                  GpuFanTabView(
                    gpuProfile: widget.gpuProfile,
                    applyGpuProfile: widget.applyGpuProfile,
                  )
                ],
              )
            )
          ],
        )
      )
    );
  }
}
