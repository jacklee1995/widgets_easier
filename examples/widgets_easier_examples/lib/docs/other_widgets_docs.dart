import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:widgets_easier/widgets_easier.dart';

import '../widgets/docs_widget.dart';
import 'privacy_guard/guarded_page.dart';

class OtherWidgetsDocs extends StatelessWidget {
  final int c;
  const OtherWidgetsDocs(this.c, {super.key});

  @override
  Widget build(BuildContext context) {
    return DocsWidget(
      children: [
        Write.header1('$c. 其它部件'),
        Write.header1('$c.1 隐私守卫'),
        SemanticButton(
          text: '跳转到被守卫页的面',
          shrink: true,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const GuardedPage(),
          )),
        ),
        const Gap(20),
      ],
    );
  }
}
