import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gui_desktop/mdi/default_window.dart';

class MdiController {
  final VoidCallback _onUpdate;
  final List<DefaultWindow> _windows = List.empty(growable: true);
  MdiController({required void Function() onUpdate}) : _onUpdate = onUpdate;

  List<DefaultWindow> get windows => _windows;

  void addWindow() {
    _createNewWindowedApp();
  }

  void _createNewWindowedApp() {
    var rng = Random();
    DefaultWindow resizableWindow = DefaultWindow(
      x: rng.nextDouble() * 500,
      y: rng.nextDouble() * 500,
    );

    resizableWindow.onWindowDragged = (dx, dy) {
      resizableWindow.x += dx;
      resizableWindow.y += dy;
      _windows.remove(resizableWindow);
      _windows.add(resizableWindow);
      _onUpdate();
    };

    resizableWindow.onClosed = () {
      _windows.remove(resizableWindow);
      _onUpdate();
    };

    resizableWindow.onMaximized = (width, height) {
      resizableWindow.x = 0;
      resizableWindow.y = 0;
      resizableWindow.currentWidth = width;
      resizableWindow.currentHeight = height;
      _onUpdate();
    };

    _windows.add(resizableWindow);
    _onUpdate();
  }
}
