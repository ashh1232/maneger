import 'package:flutter/material.dart';
import 'package:maneger/widget/shimmer_loading.dart';
// import 'package:talabat/widget/shimmer_loading.dart';

class LoadingCard extends StatelessWidget {
  final double height;
  const LoadingCard({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        margin: EdgeInsets.all(20),
        width: double.infinity,
        height: height,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Color(0xFFEBEBF4),
        ),
        child: const UnconstrainedBox(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}
