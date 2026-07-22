import 'package:flutter/material.dart';
import 'package:myrideuser/config/utils/colors.dart';

class AnimatedTopToast {
  static void show({
    required BuildContext context,
    required String message,

    /// Customizations
    Color? backgroundColor,
    Color textColor = Colors.white,
    IconData icon = Icons.check_circle_rounded,
    Duration duration = const Duration(seconds: 4),
  }) {
    final Color resolvedBackgroundColor =
        backgroundColor ?? ColorResources.greencolor;
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (_) => _ToastWidget(
        message: message,
        backgroundColor: resolvedBackgroundColor,
        textColor: textColor,
        icon: icon,
        duration: duration,
        onDismiss: () {
          try {
            overlayEntry.remove();
          } catch (_) {}
        },
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;
  final Duration duration;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _progressController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Slide + Fade animation
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOut,
      ),
    );

    // Progress bar animation
    _progressController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _slideController.forward();
    _progressController.forward();

    Future.delayed(widget.duration, () async {
      if (mounted) {
        await _slideController.reverse();
        widget.onDismiss();
      }
    });
  }

  void _dismissManually() async {
    if (mounted) {
      await _slideController.reverse();
      widget.onDismiss();
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 14,
      right: 14,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color.fromRGBO(255, 255, 255, 0.15),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(
                      widget.backgroundColor.red,
                      widget.backgroundColor.green,
                      widget.backgroundColor.blue,
                      0.3,
                    ),
                    blurRadius: 16,
                    spreadRadius: 0,
                    offset: const Offset(0, 6),
                  ),
                  const BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
                    child: Row(
                      children: [
                        // Icon with subtle background circle
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.icon,
                            color: widget.textColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Message text
                        Expanded(
                          child: Text(
                            widget.message,
                            style: TextStyle(
                              color: widget.textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                              letterSpacing: 0.1,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        // Close button
                        GestureDetector(
                          onTap: _dismissManually,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              color: Color.fromRGBO(
                                widget.textColor.red,
                                widget.textColor.green,
                                widget.textColor.blue,
                                0.8,
                              ),
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Progress bar at the bottom
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, _) {
                      return Container(
                        height: 3,
                        width: double.infinity,
                        color: const Color.fromRGBO(255, 255, 255, 0.1),
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: 1.0 - _progressController.value,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 255, 255, 0.5),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}