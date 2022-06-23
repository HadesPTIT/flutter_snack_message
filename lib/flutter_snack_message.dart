import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

enum SnackMessageType { success, info, warning, error }

enum SnackMessageDuration { short, medium, long }

class PrettySnackMessage {
  factory PrettySnackMessage({
    Key? key,
    required String title,
    String? subTitle,
    String? actionTitle,
    VoidCallback? onActionTap,
    VoidCallback? onDismiss,
    double? bottomPadding,
    SnackMessageType? type,
    SnackMessageDuration? duration,
  }) =>
      PrettySnackMessage._(
        key,
        title,
        subTitle ?? '',
        actionTitle ?? '',
        onActionTap,
        onDismiss,
        bottomPadding,
        type ?? SnackMessageType.info,
        duration ?? SnackMessageDuration.medium,
      );

  PrettySnackMessage._(
    this._key,
    this._title,
    this._subTitle,
    this._actionTitle,
    this._onActionTap,
    this._onDismiss,
    this._bottomPadding,
    this._type,
    this._duration,
  );

  final Key? _key;

  final String _title;

  final String _subTitle;

  final String _actionTitle;

  final VoidCallback? _onActionTap;

  final VoidCallback? _onDismiss;

  final double? _bottomPadding;

  final SnackMessageType _type;

  final SnackMessageDuration _duration;

  /// Check the status of [PrettySnackMessage] whether it is hidden or shown
  bool _isShowing = false;

  // Provide support for overlay
  OverlaySupportEntry? _overlaySupportEntry;

  final Map<SnackMessageType, Color> _colorMap = {
    SnackMessageType.success: Colors.green,
    SnackMessageType.info: Colors.blue,
    SnackMessageType.error: Colors.red,
    SnackMessageType.warning: Colors.orange
  };

  final Map<SnackMessageDuration, Duration> _durationMap = {
    SnackMessageDuration.short: const Duration(seconds: 1),
    SnackMessageDuration.medium: const Duration(seconds: 3),
    SnackMessageDuration.long: const Duration(seconds: 5),
  };

  final Map<SnackMessageType, IconData> _iconMap = {
    SnackMessageType.success: Icons.check_circle_outlined,
    SnackMessageType.info: Icons.info_outline,
    SnackMessageType.error: Icons.cancel_outlined,
    SnackMessageType.warning: Icons.warning_rounded
  };

  OverlaySupportEntry? show() {
    if (!_isShowing) {
      _isShowing = true;
      _overlaySupportEntry = _buildOverlay()
        ..dismissed.then(
          (_) {
            _isShowing = false;
            _onDismiss?.call();
          },
        );
    }
    return _overlaySupportEntry;
  }

  void dismiss([bool animate = true]) {
    if (_isShowing) {
      _overlaySupportEntry?.dismiss(animate: animate);
    }
  }

  OverlaySupportEntry _buildOverlay() {
    return showOverlay(
      (context, progress) => SlideUpNotification(
        bottomPadding: _bottomPadding ?? 32,
        progress: progress,
        builder: (context) => Dismissible(
          onDismissed: (_) => dismiss(),
          key: const ValueKey(null),
          child: _buildSnackMessage(context),
        ),
      ),
      duration: _durationMap[_duration],
      key: _key,
    );
  }

  Widget _buildSnackMessage(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 48,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: IntrinsicHeight(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: Colors.white,
              child: Row(
                children: [_leading(), _iconData(), _body(), _cta()],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _cta() {
    if (_actionTitle.isEmpty) return const SizedBox(width: 16);
    return GestureDetector(
      onTap: _onActionTap,
      child: Row(
        children: [
          Container(
            height: 24,
            width: 1,
            color: const Color(0x66FFFFFF),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Center(
              child: Text(
                _actionTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF22313F),
                  fontSize: 16,
                  height: 20 / 16,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _leading() {
    return Container(color: _colorMap[_type], width: 8);
  }

  Widget _iconData() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Icon(_iconMap[_type], size: 26, color: _colorMap[_type]),
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(
              _title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF22313F),
                fontSize: 16,
                height: 20 / 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _subTitle,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Color(0x80011222),
                fontSize: 14,
                height: 20 / 16,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class SlideUpNotification extends StatelessWidget {
  final double? progress;

  final WidgetBuilder? builder;

  final double? bottomPadding;

  const SlideUpNotification({this.progress, this.builder, this.bottomPadding});

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: lerpDouble(0, bottomPadding, progress!)!,
            child: FractionalTranslation(
              translation: Offset.lerp(
                const Offset(0, 1),
                const Offset(0, 0),
                progress!,
              )!,
              child: Material(
                color: Colors.transparent,
                child: builder!(context),
              ),
            ),
          )
        ],
      );
}
