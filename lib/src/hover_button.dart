import 'package:flutter/cupertino.dart';

class HoverButtonWidget extends StatefulWidget{
  final Widget child;
  const HoverButtonWidget({super.key, required this.child});

  @override
  State<HoverButtonWidget> createState() => _HoverButtonWidgetState();
}

class _HoverButtonWidgetState extends State<HoverButtonWidget> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    final hoveredTransform = Matrix4.identity()..scale(1.1);
    final transform = isHovered ?  hoveredTransform : Matrix4.identity();
    return MouseRegion(
        onEnter: (event)=> onEntered(true),
        onExit: (event) => onExit(false),
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: transform,
            child: widget.child));
  }

  onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }

  onExit(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }
}