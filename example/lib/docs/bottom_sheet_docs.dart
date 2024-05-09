import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:widgets_easier/widgets_easier.dart';

import '../widgets/docs_widget.dart';

class BottomSheetDocs extends StatelessWidget {
  final int c;

  const BottomSheetDocs(
    this.c, {
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return DocsWidget(
      children: [
        Write.header1('$c. 底部弹窗'),
        Write.header2('$c.1 底部消息弹窗'),
        const Gap(20),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    SemanticButton(
      text: 'Primary',
      type: SemanticEnum.primary,
      onTap: () => BottomSheets.showInfoSheet(
        context,
        title: "Primary Sheet",
        message: "This is a info bottom sheet.",
        buttonText: "Close",
        onTapDismiss: () => Navigator.pop(context),
        type: SemanticEnum.primary,
      ),
    ),
    SemanticButton(
      text: 'Secondary',
      type: SemanticEnum.secondary,
      onTap: () => BottomSheets.showInfoSheet(
        context,
        title: "Secondary Sheet",
        message: "This is a info bottom sheet.",
        buttonText: "Close",
        onTapDismiss: () => Navigator.pop(context),
        type: SemanticEnum.secondary,
      ),
    ),
    SemanticButton(
      text: 'Info',
      type: SemanticEnum.info,
      onTap: () => BottomSheets.showInfoSheet(
        context,
        title: "Info Sheet",
        message: "This is a info bottom sheet.",
        buttonText: "Close",
        onTapDismiss: () => Navigator.pop(context),
        type: SemanticEnum.info,
      ),
    ),
    SemanticButton(
      text: 'Success',
      type: SemanticEnum.success,
      onTap: () => BottomSheets.showInfoSheet(
        context,
        title: "Success Sheet",
        message: "This is a info bottom sheet.",
        buttonText: "Close",
        onTapDismiss: () => Navigator.pop(context),
        type: SemanticEnum.success,
      ),
    ),
    SemanticButton(
      text: 'Warning',
      type: SemanticEnum.warning,
      onTap: () => BottomSheets.showInfoSheet(
        context,
        title: "Warning Sheet",
        message: "This is a info bottom sheet.",
        buttonText: "Close",
        onTapDismiss: () => Navigator.pop(context),
        type: SemanticEnum.warning,
      ),
    ),
    SemanticButton(
      text: 'Danger',
      type: SemanticEnum.danger,
      onTap: () => BottomSheets.showInfoSheet(
        context,
        title: "Danger Sheet",
        message: "This is a info bottom sheet.",
        buttonText: "Close",
        onTapDismiss: () => Navigator.pop(context),
        type: SemanticEnum.danger,
      ),
    ),
    SemanticButton(
      text: 'Fatal',
      type: SemanticEnum.fatal,
      onTap: () => BottomSheets.showInfoSheet(
        context,
        title: "Fatal Sheet",
        message: "This is a info bottom sheet.",
        buttonText: "Close",
        onTapDismiss: () => Navigator.pop(context),
        type: SemanticEnum.fatal,
      ),
    ),
  ],
),
        const Gap(20),
        Write.header2('$c.2 底部确认弹窗'),
        const Gap(20),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
    SemanticButton(
      text: 'Primary',
      type: SemanticEnum.primary,
      isOutlined: true,
      onTap: () => BottomSheets.showConfirmSheet(
        context,
        title: "Primary Sheet",
        message: "This is a confirm bottom sheet.",
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        onTapConfirm: () {
          // 处理确认操作
          Navigator.pop(context);
        },
        onTapCancel: () {
          // 处理取消操作
          Navigator.pop(context);
        },
        type: SemanticEnum.primary,
      ),
    ),
    SemanticButton(
      text: 'Secondary',
      type: SemanticEnum.secondary,
      isOutlined: true,
      onTap: () => BottomSheets.showConfirmSheet(
        context,
        title: "Secondary Sheet",
        message: "This is a confirm bottom sheet.",
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        onTapConfirm: () {
          // 处理确认操作
          Navigator.pop(context);
        },
        onTapCancel: () {
          // 处理取消操作
          Navigator.pop(context);
        },
        type: SemanticEnum.secondary,
      ),
    ),
    SemanticButton(
      text: 'Info',
      type: SemanticEnum.info,
      isOutlined: true,
      onTap: () => BottomSheets.showConfirmSheet(
        context,
        title: "Info Sheet",
        message: "This is a confirm bottom sheet.",
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        onTapConfirm: () {
          // 处理确认操作
          Navigator.pop(context);
        },
        onTapCancel: () {
          // 处理取消操作
          Navigator.pop(context);
        },
        type: SemanticEnum.info,
      ),
    ),
    SemanticButton(
      text: 'Success',
      type: SemanticEnum.success,
      isOutlined: true,
      onTap: () => BottomSheets.showConfirmSheet(
        context,
        title: "Success Sheet",
        message: "This is a confirm bottom sheet.",
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        onTapConfirm: () {
          // 处理确认操作
          Navigator.pop(context);
        },
        onTapCancel: () {
          // 处理取消操作
          Navigator.pop(context);
        },
        type: SemanticEnum.success,
      ),
    ),
    SemanticButton(
      text: 'Warning',
      type: SemanticEnum.warning,
      isOutlined: true,
      onTap: () => BottomSheets.showConfirmSheet(
        context,
        title: "Warning Sheet",
        message: "This is a confirm bottom sheet.",
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        onTapConfirm: () {
          // 处理确认操作
          Navigator.pop(context);
        },
        onTapCancel: () {
          // 处理取消操作
          Navigator.pop(context);
        },
        type: SemanticEnum.warning,
      ),
    ),
    SemanticButton(
      text: 'Danger',
      type: SemanticEnum.danger,
      isOutlined: true,
      onTap: () => BottomSheets.showConfirmSheet(
        context,
        title: "Danger Sheet",
        message: "This is a confirm bottom sheet.",
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        onTapConfirm: () {
          // 处理确认操作
          Navigator.pop(context);
        },
        onTapCancel: () {
          // 处理取消操作
          Navigator.pop(context);
        },
        type: SemanticEnum.danger,
      ),
    ),
    SemanticButton(
      text: 'Fatal',
      type: SemanticEnum.fatal,
      isOutlined: true,
      onTap: () => BottomSheets.showConfirmSheet(
        context,
        title: "Fatal Sheet",
        message: "This is a confirm bottom sheet.",
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        onTapConfirm: () {
          // 处理确认操作
          Navigator.pop(context);
        },
        onTapCancel: () {
          // 处理取消操作
          Navigator.pop(context);
        },
        type: SemanticEnum.fatal,
      ),
    ),
  ],
),
        const Gap(20),
        Write.header2('$c.3 底部选择器'),
        const Gap(20),
        Center(
child: SemanticButton(
  text: '一级选择表单',
  shrink: true,
  type: SemanticEnum.primary,
  isOutlined: true,
  onTap: () => BottomSheets.showCascadeSheet(
    context,
    items: [
      {'label': ''},
      {'label': '中国'},
      {'label': '俄罗斯'},
      {'label': '美国'},
      {'label': '法国'},
      {'label': '德国'},
      {'label': '意大利'},
    ],
  ).then((value) {
    debugPrint('value = $value');
  }),
),
        ),
        const Gap(20),
        Center(
child: SemanticButton(
  text: '多级联动选择表单',
  shrink: true,
  type: SemanticEnum.primary,
  isOutlined: true,
  onTap: () => BottomSheets.showCascadeSheet(
    context,
    items: [
      {
        'label': '中国',
        'children': [
          {
            'label': '北京市',
            'children': [
              {
                'label': '东城区',
                'children': [
                  {'label': '安定门街道'},
                  {'label': '建国门街道'},
                  {'label': '朝阳门街道'},
                ],
              },
              {
                'label': '西城区',
                'children': [
                  {'label': '德胜门街道'},
                  {'label': '新街口街道'},
                  {'label': '月坛街道'},
                ],
              },
            ],
          },
          {
            'label': '上海市',
            'children': [
              {
                'label': '黄浦区',
                'children': [
                  {'label': '南京东路街道'},
                  {'label': '外滩街道'},
                  {'label': '半淞园路街道'},
                ],
              },
              {
                'label': '徐汇区',
                'children': [
                  {'label': '湖南路街道'},
                  {'label': '斜土路街道'},
                  {'label': '枫林路街道'},
                ],
              },
            ],
          },
        ],
      },
      {
        'label': '美国',
        'children': [
          {
            'label': '加利福尼亚州',
            'children': [
              {
                'label': '旧金山市',
                'children': [
                  {'label': '唐人街'},
                  {'label': '金融区'},
                  {'label': '渔人码头'},
                ],
              },
              {
                'label': '洛杉矶市',
                'children': [
                  {'label': '好莱坞'},
                  {'label': '比佛利山'},
                  {'label': '圣莫尼卡'},
                ],
              },
            ],
          },
          {
            'label': '纽约州',
            'children': [
              {
                'label': '纽约市',
                'children': [
                  {'label': '曼哈顿'},
                  {'label': '布鲁克林'},
                  {'label': '皇后区'},
                ],
              },
              {
                'label': '布法罗市',
                'children': [
                  {'label': '尼亚加拉广场'},
                  {'label': '艾伦敦'},
                  {'label': '拉萨尔公园'},
                ],
              },
            ],
          },
        ],
      },
    ],
  ).then((value) {
    debugPrint('value = $value');
  }),
),
        ),
        const Gap(40),
      ],
    );
  }
}
