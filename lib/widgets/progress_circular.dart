import 'package:flutter/material.dart';

class ProgressIndicatorCircle extends StatefulWidget {
  const ProgressIndicatorCircle({super.key});

  @override
  State<ProgressIndicatorCircle> createState() =>
      _ProgressIndicatorCircleState();
}

class _ProgressIndicatorCircleState extends State<ProgressIndicatorCircle>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
      duration: const Duration(seconds: 1),
    )..addListener(() {
      setState(() {});
    });
    controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              value: controller.value,
              semanticsLabel: 'Circular progress indicator',
              backgroundColor: Colors.transparent,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
