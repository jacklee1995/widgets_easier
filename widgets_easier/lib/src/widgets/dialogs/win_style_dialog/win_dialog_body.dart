import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class WinDialogBody extends StatelessWidget {
  final Widget icon;
  final String text;
  final Widget? contents;
  const WinDialogBody({
    super.key,
    required this.icon,
    required this.text,
    this.contents,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 17,
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: FittedBox(
                  child: icon,
                ),
              ),
              const Gap(20),
              Expanded(
                child: Text(
                  text,
                ),
              ),
            ],
          ),
          const Gap(20),
          if (contents != null) contents!
        ],
      ),
    );
  }
}
