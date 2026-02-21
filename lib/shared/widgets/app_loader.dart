import 'package:flutter/material.dart';

import 'app_lottie.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: AppLottie(assetName: "loader.", width: 100, height: 100));
  }
}
