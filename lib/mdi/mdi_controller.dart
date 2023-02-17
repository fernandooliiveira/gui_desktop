import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gui_desktop/mdi/resizable_window.dart';
import 'package:uuid/uuid.dart';

class MdiController {
  final VoidCallback _onUpdate;
  final List<ResizableWindow> _windows = List.empty(growable: true);
  MdiController({required void Function() onUpdate}) : _onUpdate = onUpdate;

  List<ResizableWindow> get windows => _windows;

  void addWindow() {
    _createNewWindowedApp();
  }

  void _createNewWindowedApp() {
    var rng = Random();
    var uuid = const Uuid();
    ResizableWindow resizableWindow = ResizableWindow(
      x: rng.nextDouble() * 500,
      y: rng.nextDouble() * 500,
      key: Key(uuid.v1()),
    );

    resizableWindow.onWindowDragged = (dx, dy) {
      resizableWindow.x += dx;
      resizableWindow.y += dy;
      _windows.remove(resizableWindow);
      _windows.add(resizableWindow);
      _onUpdate();
    };

    _windows.add(resizableWindow);
    _onUpdate();
  }
}
