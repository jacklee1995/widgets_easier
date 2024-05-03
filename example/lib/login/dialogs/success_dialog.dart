import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

class SuccessDialog extends StatelessWidget {
  final String data;
  const SuccessDialog(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 200,
          height: 200,
          margin: const EdgeInsets.all(26),
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check,
                color: Colors.green,
                size: 60,
              ),
              const Gap(20),
              Text(data, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
