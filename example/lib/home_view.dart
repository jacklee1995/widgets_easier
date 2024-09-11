import 'package:example/docs/buttons_docs.dart';
import 'package:example/docs/picture_docs.dart';
import 'package:example/docs/tag/tag_docs.dart';
import 'package:flutter/material.dart';
import 'package:widgets_easier/widgets_easier.dart';
import 'docs/animation_docs.dart';
import 'docs/border_docs.dart';
import 'docs/bottom_sheet_docs.dart';
import 'docs/button_group_docs.dart';
import 'docs/card_docs.dart';
import 'docs/counter_input_docs.dart';
import 'docs/dialog_docs.dart';
import 'docs/notify_toast_docs.dart';
import 'docs/other_widgets_docs.dart';
import 'docs/paginated_loader/paginated_loader_docs.dart';
import 'docs/shadow_docs.dart';
import 'docs/slider_docs.dart';
import 'docs/tip_toast_docs.dart';
import 'theme_mode.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Examples'),
        actions: [
          ValueListenableBuilder(
            valueListenable: themeMode,
            builder: (context, value, child) => IconButton(
              onPressed: () {
                if (value == ThemeMode.system) {
                  themeMode.value = ThemeMode.light;
                } else if (value == ThemeMode.light) {
                  themeMode.value = ThemeMode.dark;
                } else {
                  themeMode.value = ThemeMode.system;
                }
              },
              icon: Icon(
                value == ThemeMode.system
                    ? Icons.brightness_auto
                    : value == ThemeMode.light
                        ? Icons.brightness_high
                        : Icons.brightness_low,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Write.header1('1. 语义'),
              Write.header1('2. 色彩'),
              const BorderDocs(3),
              const ShadowDocs(4),
              const ButtonDocs(5),
              const ButtonGroupDocs(6),
              const CounterInputDocs(7),
              Write.header1('8. 指示器'),
              Write.header2('百分比指示器（水平）'),
              Write.paragraph('指示器'),
              Write.header2('百分比指示器（环形）'),
              const SliderDocs(9),
              const AnimationDocs(10),
              const PictureDocs(11),
              const CardDocs(12),
              const DialogDocs(11),
              const BottomSheetDocs(12),
              const NotifyToastDocs(13),
              const TipToastDocs(14),
              const TagDocs(15),
              const PaginatedLoaderDocs(16),
              const OtherWidgetsDocs(17),
            ],
          ),
        ),
      ),
    );
  }
}
