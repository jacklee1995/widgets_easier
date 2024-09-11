import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:widgets_easier/widgets_easier.dart';

import '../widgets/docs_widget.dart';

class CardDocs extends StatelessWidget {
  final int c;
  const CardDocs(this.c, {super.key});

  @override
  Widget build(BuildContext context) {
    return DocsWidget(
      children: [
        Write.header1('$c. 卡片'),
        Write.header2(''),
        const Gap(20),
      ],
    );
  }
}
