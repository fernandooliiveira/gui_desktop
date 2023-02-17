import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gui_desktop/mdi/minimized_state.dart';

// ignore: must_be_immutable
class DefaultWindow extends StatefulWidget {
  double? maxWidth;
  double? maxHeight;
  MinimizedState? minimizedState;
  bool maximized = false;
  bool minimized = false;

  double x;
  double y;
  double currentWidth;
  double currentHeight;
  final double defaultSize;

  late Function(double, double) onWindowDragged;
  late Function() onClosed;
  late Function(double, double) onMaximized;
  late Function(MinimizedState state) onResize;
  late Function() onMinimize;
  late Function() openTab;

  DefaultWindow({
    Key? key,
    required this.x,
    required this.y,
    this.currentWidth = 400,
    this.currentHeight = 400,
    this.defaultSize = 400,
  }) : super(key: UniqueKey());

  @override
  State<DefaultWindow> createState() => _DefaultWindowState();
}

class _DefaultWindowState extends State<DefaultWindow> {

  late Size windowSize;
  late SystemMouseCursor _cursor;

  _setDragStart() => setState(() => _cursor = SystemMouseCursors.move);

  _setDragEnd() => setState(() => _cursor = SystemMouseCursors.basic);

  _header() {
    return MouseRegion(
      cursor: _cursor,
      child: GestureDetector(
        onPanStart: (_) => _setDragStart(),
        onPanEnd: (_) => _setDragEnd(),
        onPanUpdate: (details) =>
            widget.onWindowDragged(details.delta.dx, details.delta.dy),
        child: Container(
          width: widget.currentWidth,
          height: 50,
          decoration: const BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: widget.onClosed,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.red,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: !widget.maximized ? () => setState(() => widget.onMaximized(
                            widget.maxWidth!, widget.maxHeight!)) : () => setState(() => widget.onResize(widget.minimizedState!)),
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.yellow,
                          ),
                          child: Center(
                            child: Icon(
                              !widget.maximized ? Icons.square_outlined : Icons.copy,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => widget.onMinimize()),
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.green,
                          ),
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.minus,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _body() {
    return Container(
      width: widget.currentWidth,
      height: widget.currentHeight - 50,
      decoration: const BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: const [],
      ),
    );
  }

  void _onHorizontalDragRight(DragUpdateDetails details) {
    setState(() {
      widget.currentWidth += details.delta.dx;
      if (widget.currentWidth < widget.defaultSize) {
        widget.currentWidth = widget.defaultSize;
      }
    });
  }

  void _onHorizontalDragLeft(DragUpdateDetails details) {
    setState(() {
      widget.currentWidth -= details.delta.dx;
      if (widget.currentWidth < widget.defaultSize) {
        widget.currentWidth = widget.defaultSize;
      } else {
        widget.onWindowDragged(details.delta.dx, 0);
      }
    });
  }

  void _onVerticalDragBottom(DragUpdateDetails details) {
    setState(() {
      widget.currentHeight += details.delta.dy;
      if (widget.currentHeight < widget.defaultSize) {
        widget.currentHeight = widget.defaultSize;
      }
    });
  }

  void _onVerticalDragTop(DragUpdateDetails details) {
    setState(() {
      widget.currentHeight -= details.delta.dy;
      if (widget.currentHeight < widget.defaultSize) {
        widget.currentHeight = widget.defaultSize;
      } else {
        widget.onWindowDragged(0, details.delta.dy);
      }
    });
  }

  void _onDragRightTop(DragUpdateDetails details) {
    _onVerticalDragTop(details);
    _onHorizontalDragRight(details);
  }

  void _onDragRightBottom(DragUpdateDetails details) {
    _onVerticalDragBottom(details);
    _onHorizontalDragRight(details);
  }

  void _onDragLeftTop(DragUpdateDetails details) {
    _onVerticalDragTop(details);
    _onHorizontalDragLeft(details);
  }

  void _onDragLeftBottom(DragUpdateDetails details) {
    _onVerticalDragBottom(details);
    _onHorizontalDragLeft(details);
  }

  @override
  void initState() {
    _cursor = SystemMouseCursors.basic;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.currentHeight,
      width: widget.currentWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color(0x54000000),
              spreadRadius: 2,
              blurRadius: 8,
            ),
          ]),
      child: Stack(
        children: [
          Column(
            children: [
              _header(),
              _body(),
            ],
          ),
          // RIGHT RESIZE
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onHorizontalDragUpdate: _onHorizontalDragRight,
              child: const MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                opaque: true,
                child: SizedBox(
                  width: 4,
                ),
              ),
            ),
          ),
          // LEFT RESIZE
          // TODO: CORRIGIR BUG DE POSIÇÃO
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onHorizontalDragUpdate: _onHorizontalDragLeft,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                opaque: true,
                child: Container(
                  width: 4,
                ),
              ),
            ),
          ),
          // BOTTOM RESIZE
          Positioned(
            left: 4,
            right: 4,
            bottom: 0,
            child: GestureDetector(
              onVerticalDragUpdate: _onVerticalDragBottom,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUpDown,
                opaque: true,
                child: Container(
                  height: 4,
                ),
              ),
            ),
          ),
          // TOP RESIZE
          // TODO: CORRIGIR BUG DE POSIÇÃO
          Positioned(
            left: 4,
            right: 4,
            top: 0,
            child: GestureDetector(
              onVerticalDragUpdate: _onVerticalDragTop,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUpDown,
                opaque: true,
                child: Container(
                  height: 4,
                ),
              ),
            ),
          ),
          // TOP RIGHT RESIZE
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onPanUpdate: _onDragRightTop,
              child: const MouseRegion(
                cursor: SystemMouseCursors.resizeUpRightDownLeft,
                opaque: true,
                child: SizedBox(
                  height: 12,
                  width: 12,
                ),
              ),
            ),
          ),
          // BOTTOM RIGHT RESIZE,
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onPanUpdate: _onDragRightBottom,
              child: const MouseRegion(
                cursor: SystemMouseCursors.resizeUpLeftDownRight,
                opaque: true,
                child: SizedBox(
                  height: 12,
                  width: 12,
                ),
              ),
            ),
          ),
          // TOP LEFT RESIZE
          Positioned(
            left: 0,
            top: 0,
            child: GestureDetector(
              onPanUpdate: _onDragLeftTop,
              child: const MouseRegion(
                cursor: SystemMouseCursors.resizeUpLeftDownRight,
                opaque: true,
                child: SizedBox(
                  height: 12,
                  width: 12,
                ),
              ),
            ),
          ),
          // BOTTOM LEFT RESIZE
          Positioned(
            left: 0,
            bottom: 0,
            child: GestureDetector(
              onPanUpdate: _onDragLeftBottom,
              child: const MouseRegion(
                cursor: SystemMouseCursors.resizeUpRightDownLeft,
                opaque: true,
                child: SizedBox(
                  height: 12,
                  width: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
