import 'package:example/widgets/docs_widget.dart';
import 'package:flutter/material.dart';
import 'package:widgets_easier/widgets_easier.dart';

class CardDocs extends StatelessWidget {
  const CardDocs({super.key});

  @override
  Widget build(BuildContext context) {
    return DocsWidget(
      children: [
        Write.header2(''),
      ],
    );
  }
}
