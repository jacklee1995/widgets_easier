import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:widgets_easier/widgets_easier.dart';

import '../widgets/docs_widget.dart';

class ShadowDocs extends StatelessWidget {
  const ShadowDocs({super.key});

  @override
  Widget build(BuildContext context) {
    return DocsWidget(
      children: [
        Write.paragraph(
            '受到Element的启发，典型的阴影效果被封装为以下四个组件：BasicShadow、LightShadow、LighterShadow、DarkShadow，每个组件都使用 DecoratedBox 来实现特定的阴影效果。'),
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BasicShadow(
              child: Container(
                height: 100,
                width: 100,
                color: Colors.white,
                child: const Center(
                  child: Text('BasicShadow'),
                ),
              ),
            ),
            const Gap(20),
            LightShadow(
              child: Container(
                height: 100,
                width: 100,
                color: Colors.white,
                child: const Center(
                  child: Text('LightShadow'),
                ),
              ),
            ),
            const Gap(20),
            LighterShadow(
              child: Container(
                height: 100,
                width: 100,
                color: Colors.white,
                child: const Center(
                  child: Text('LighterShadow'),
                ),
              ),
            ),
            const Gap(20),
            DarkShadow(
              child: Container(
                height: 100,
                width: 100,
                color: Colors.white,
                child: const Center(
                  child: Text('DarkShadow'),
                ),
              ),
            ),
          ],
        ),
        const Gap(20),
      ],
    );
  }
}
