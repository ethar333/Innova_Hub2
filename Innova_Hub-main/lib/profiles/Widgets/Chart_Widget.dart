
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';


class AnimatedRevenueWidget extends StatefulWidget {
  final double revenue;

  const AnimatedRevenueWidget({super.key, required this.revenue});

  @override
  State<AnimatedRevenueWidget> createState() => _AnimatedRevenueWidgetState();
}

class _AnimatedRevenueWidgetState extends State<AnimatedRevenueWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0, end: widget.revenue)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxRevenue = (widget.revenue * 1.3).ceilToDouble();

    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.stacked_line_chart,
                    color: Colors.deepPurple, size: 28),
                SizedBox(width: 10),
                Text(
                  'Predicted Revenue (AI)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Text(
                  '${_animation.value.toStringAsFixed(2)} EGP',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return SfLinearGauge(
                  minimum: 0,
                  maximum: maxRevenue,
                  barPointers: [
                    LinearBarPointer(
                      value: _animation.value,
                      thickness: 20,
                      edgeStyle: LinearEdgeStyle.bothCurve,
                      color: Colors.deepPurple,
                    ),
                  ],
                  axisTrackStyle: const LinearAxisTrackStyle(
                    thickness: 20,
                    edgeStyle: LinearEdgeStyle.bothCurve,
                    color: Color(0xFFEEEEEE),
                  ),
                  showTicks: false,
                  showLabels: false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
