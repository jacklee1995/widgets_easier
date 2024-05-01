import 'package:example/docs/buttons_docs.dart';
import 'package:example/docs/picture_docs.dart';
import 'package:example/login_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:widgets_easier/widgets_easier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'docs/animation_docs.dart';
import 'docs/border_docs.dart';
import 'docs/button_group_docs.dart';
import 'docs/card_docs.dart';
import 'docs/counter_input_docs.dart';
import 'docs/dialog_docs.dart';
import 'docs/shadow_docs.dart';
import 'docs/slider_docs.dart';
import 'theme_mode.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.title});
  final String title;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
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
              const Gap(20),
              Write.header1('3. 边框'),
              const BorderDocs(),
              const Gap(20),
              Write.header1('3. 阴影'),
              const ShadowDocs(),
              Write.header1('3. 按钮'),
              const ButtonDocs(),
              Write.header1('4. 按钮组'),
              const ButtonGroupDocs(),
              Write.header1('5. 加减输入器'),
              CounterInputDocs(),
              Write.header1('6. 指示器'),
              Write.header2('百分比指示器（水平）'),
              Write.paragraph('指示器'),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: PercentIndicator(
                  value: 0.7,
                  valueIndicator: '@P%',
                  type: SemanticEnum.primary,
                  // size: SizeEnum.defaultSize,
                  startRadius: 5,
                  endRadius: 15,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: PercentIndicator(
                  value: 0.5,
                  type: SemanticEnum.success,
                  size: SizeEnum.large,
                  height: 20,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: PercentIndicator(
                  value: 0.3,
                  type: SemanticEnum.warning,
                  size: SizeEnum.small,
                  height: 5,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: PercentIndicator(
                  value: 0.8,
                  type: SemanticEnum.danger,
                  size: SizeEnum.large,
                  height: 20,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: PercentIndicator(
                  value: null, // Indeterminate
                  type: SemanticEnum.info,
                  size: SizeEnum.defaultSize,
                  height: 10,
                ),
              ),
              Write.header2('百分比指示器（环形）'),
              Write.header1('7. 滑动器'),
              const SliderDocs(),
              Write.header1('8. 动画'),
              const AnimationDocs(),
              Write.header1('9. 图片'),
              const PictureDocs(),
              Write.header1('10. 卡片'),
              const CardDocs(),
              const Gap(20),
              Write.header1('11. 弹窗'),
              const DialogDocs(),
            ],
          ),
        ),
      ),
    );
  }
}
// Write.orderedList([
//                 Write.listItem('111111', [
//                   Write.listItem('item', [
//                     const Text('text'),
//                     Write.orderedList([
//                       Write.listItem('sub-orderedList-item1'),
//                       Write.listItem('sub-orderedList-item2'),
//                       Write.listItem('sub-orderedList-item3', [
//                         Write.orderedList([
//                           Write.listItem('sub-sub-orderedList-item1'),
//                           Write.listItem('sub-sub-orderedList-item2'),
//                           Write.listItem('sub-sub-orderedList-item3', [
//                             Write.unorderedList([
//                               Write.listItem('sub-sub-sub-unorderedList-item1'),
//                               Write.listItem(
//                                   'sub-sub-sub-unorderedList-item2', [
//                                 Write.unorderedList([
//                                   Write.listItem(
//                                       'Stir both mixtures together.'),
//                                   Write.listItem('Fill muffin tray 3/4 full.'),
//                                   Write.listItem('Bake for 20 minutes.'),
//                                 ]),
//                               ]),
//                             ]),
//                           ]),
//                         ]),
//                       ]),
//                     ]),
//                   ]),
//                 ]),
//                 Write.listItem('222222', [
//                   Write.unorderedList([
//                     Write.listItem('W6ER5F4'),
//                     Write.listItem('w6e5rffvre'),
//                     Write.image(source: 'source'),
//                   ]),
//                 ]),
//                 Write.listItem('333333'),
//               ]),
