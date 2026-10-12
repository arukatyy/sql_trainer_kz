import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TactileButton extends StatefulWidget {
  final Widget child;
  final Color color;
  final Color shadowColor;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double depth;

  const TactileButton({
    super.key,
    required this.child,
    required this.color,
    required this.shadowColor,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    this.borderRadius = 16,
    this.depth = 4.0,
  });

  @override
  State<TactileButton> createState() => _TactileButtonState();
}

class _TactileButtonState extends State<TactileButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null;
    final Color currentColor = isEnabled ? widget.color : Colors.grey.shade400;
    final Color currentShadowColor = isEnabled ? widget.shadowColor : Colors.grey.shade600;

    return GestureDetector(
      onTapDown: isEnabled ? (_) {
        HapticFeedback.lightImpact();
        setState(() => _isPressed = true);
      } : null,
      onTapUp: isEnabled ? (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      } : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 70),
        curve: Curves.easeOut,
        margin: EdgeInsets.only(top: _isPressed ? widget.depth : 0, bottom: _isPressed ? 0 : widget.depth),
        decoration: BoxDecoration(
          color: currentColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            if (!_isPressed && isEnabled)
              BoxShadow(
                color: currentShadowColor,
                offset: Offset(0, widget.depth),
                blurRadius: 0,
              ),
          ],
        ),
        padding: widget.padding,
        child: Center(
          child: DefaultTextStyle(
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
