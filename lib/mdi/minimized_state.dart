class MinimizedState {
  final double _minimizedWidth;
  final double _minimizedHeight;
  final double _minimizedXPosition;
  final double _minimizedYPosition;

  MinimizedState.saveState(
    this._minimizedWidth,
    this._minimizedHeight,
    this._minimizedXPosition,
    this._minimizedYPosition,
  );

  double get minimizedWidth => _minimizedWidth;

  double get minimizedHeight => _minimizedHeight;

  double get minimizedXPosition => _minimizedXPosition;

  double get minimizedYPosition => _minimizedYPosition;
}
