import 'package:flutter/material.dart';
import 'package:gui_desktop/mdi/tab.dart';

import 'mdi_controller.dart';

class MdiManager extends StatefulWidget {
  final MdiController mdiController;

  const MdiManager({
    Key? key,
    required this.mdiController,
  }) : super(key: key);

  @override
  State<MdiManager> createState() => _MdiManagerState();
}

class _MdiManagerState extends State<MdiManager> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
            children: widget.mdiController.windows.map((e){
              e.maxHeight = MediaQuery.of(context).size.height;
              e.maxWidth = MediaQuery.of(context).size.width;
              return Positioned(
                left: e.x,
                top: e.y,
                key: e.key,
                child: Visibility(visible: !e.minimized,child: e),
              );
            }).toList()
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.mdiController.windows.map((e){
              return TabMdi(componentKey: e.key!, tabMinimized: e.minimized, openTab: e.openTab,);
            }).toList(),
          ),
        )
      ],
    );
  }
}
