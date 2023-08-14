import 'package:flutter/material.dart';

import 'package:feather_client/utils/utils.dart';

import 'box.dart';

class WatermarkComponent extends StatelessWidget {
  const WatermarkComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          EnvUtils.kWatermark,
          style: StyleUtils.smallDarkStyle,
          textAlign: TextAlign.center,
        ),
        BoxComponent.customHeight(5),
        const Text(
          "Version ${EnvUtils.kVersion}",
          style: StyleUtils.smallDarkStyle,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
