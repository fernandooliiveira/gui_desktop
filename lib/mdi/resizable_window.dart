import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class ResizableWindow extends StatefulWidget {
  double x;
  double y;
  double currentWidth;
  double currentHeight;
  final double defaultSize;

  late Function(double, double) onWindowDragged;

  ResizableWindow({
    Key? key,
    required this.x,
    required this.y,
    this.currentWidth = 400,
    this.currentHeight = 400,
    this.defaultSize = 400,
  }) : super(key: UniqueKey());

  @override
  State<ResizableWindow> createState() => _ResizableWindowState();
}

class _ResizableWindowState extends State<ResizableWindow> {
  late SystemMouseCursor _cursor;
  _setDragStart() => setState(() => _cursor = SystemMouseCursors.move);
  _setDragEnd() => setState(() => _cursor = SystemMouseCursors.click);
  _setDragHorizontalStart() => setState(() => _cursor = SystemMouseCursors.resizeLeftRight);
  _setDragHorizontalEnd() => setState(() => _cursor = SystemMouseCursors.move);

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
    _cursor = SystemMouseCursors.click;
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
