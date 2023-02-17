import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gui_desktop/mdi/default_window.dart';
import 'package:gui_desktop/mdi/minimized_state.dart';

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
      resizableWindow.minimizedState = MinimizedState.saveState(
        resizableWindow.currentWidth,
        resizableWindow.currentHeight,
        resizableWindow.x,
        resizableWindow.y,
      );
      resizableWindow.x = 0;
      resizableWindow.y = 0;
      resizableWindow.currentWidth = width;
      resizableWindow.currentHeight = height;
      resizableWindow.maximized = true;
      _onUpdate();
    };

    resizableWindow.onResize = (MinimizedState state) {
      resizableWindow.x = state.minimizedXPosition;
      resizableWindow.y = state.minimizedYPosition;
      resizableWindow.currentWidth = state.minimizedWidth;
      resizableWindow.currentHeight = state.minimizedHeight;
      resizableWindow.maximized = false;
      _onUpdate();
    };

    resizableWindow.onMinimize = () {
      resizableWindow.minimized = true;
      _onUpdate();
    };

    resizableWindow.openTab = () {
      resizableWindow.minimized = false;
      _onUpdate();
    };

    _windows.add(resizableWindow);
    _onUpdate();
  }
}
