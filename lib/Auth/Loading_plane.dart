import 'package:flutter/material.dart';

class PlaneLoadingDialog extends StatefulWidget {
  @override
  _PlaneLoadingDialogState createState() => _PlaneLoadingDialogState();
}

class _PlaneLoadingDialogState extends State<PlaneLoadingDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset(1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: SlideTransition(
                  position: _animation,
                  child: Transform.rotate(
                    angle: 1.57, // Rotate by 90 degrees (pi/2 radians)
                    child: Icon(Icons.airplanemode_active, size: 60, color: Colors.tealAccent,weight: 2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
