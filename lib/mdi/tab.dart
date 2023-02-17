import 'package:flutter/material.dart';

class TabMdi extends StatelessWidget {
  final Key componentKey;
  final bool tabMinimized;
  final Function() openTab;

  const TabMdi({
    Key? key,
    required this.componentKey,
    required this.tabMinimized,
    required this.openTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openTab(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              width: 2,
              color: tabMinimized ? Colors.black : Colors.orange,
            )),
      ),
    );
  }
}
