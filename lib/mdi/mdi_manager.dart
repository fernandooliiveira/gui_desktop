import 'package:flutter/material.dart';

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
        children: widget.mdiController.windows.map((e){
          e.maxHeight = MediaQuery.of(context).size.height;
          e.maxWidth = MediaQuery.of(context).size.width;
          return Positioned(
            left: e.x,
            top: e.y,
            key: e.key,
            child: e,
          );
        }).toList()
    );
  }
}
