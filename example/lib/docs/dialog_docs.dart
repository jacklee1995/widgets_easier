import 'package:example/widgets/docs_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:widgets_easier/widgets_easier.dart';

import '../login_view.dart';

class DialogDocs extends StatelessWidget {
  const DialogDocs({super.key});
  @override
  Widget build(BuildContext context) {
    return DocsWidget(
      children: [
        Write.header2('.1 警告弹窗（AlertDialog）'),
        Write.header2('.2 消息弹窗（InfoDialog）'),
        Write.paragraph('用于显示简短的信息或反馈。'),
        Write.paragraph(
            '除了InfoDialog外，吐丝（Toast）也是一种消息型弹窗。但是Toast通常自动消失，不需要用户操作；InfoDialog则需要用户手动关闭。一般来说，如果消息不是那么重要，则可以使用Toast；反之，如果需要引起用户更多的注意，则使用InfoDialog。'),
        Write.header3('.2.1 消息窗体的构成'),
        const Gap(10),
        Write.paragraph(
            '消息弹窗（InfoDialog）通常用于在移动应用中显示重要信息，需要用户明确地关闭弹窗以确保信息被看到。以下是InfoDialog的主要构成元素：'),
        Write.orderedList([
          Write.listItem('标题（Title）', [
            Write.unorderedList([
              Write.listItem('作用：提供弹窗的主题或概述。'),
              Write.listItem('示例场景：「更新通知」、「系统消息」等。')
            ])
          ]),
          Write.listItem('内容（Content）', [
            Write.unorderedList([
              Write.listItem('作用：提详细描述消息的具体内容。'),
              Write.listItem('示例：「您的应用已更新至最新版本。」或「我们的服务条款已更新。」等。')
            ])
          ]),
          Write.listItem('关闭按钮（Close Button）', [
            Write.unorderedList([
              Write.listItem('作用：允许用户手动关闭弹窗。'),
              Write.listItem('示例：通常是一个标有“关闭”、“确定”或包含一个图标（如X或箭头）的按钮。')
            ])
          ]),
          Write.listItem('图标（Icon）', [
            Write.unorderedList([
              Write.listItem('作用：视觉上表示消息的性质（如信息、警告等）。'),
              Write.listItem('示例：一个i字符（Information）信息图标表示表示一般消息。')
            ])
          ]),
          Write.listItem(' 辅助操作（Auxiliary Actions） (可选)', [
            Write.unorderedList([
              Write.listItem('作用：提供与消息相关的额外操作。'),
              Write.listItem('示例：「查看详情」按钮，可以链接到更详细的说明或相关设置。')
            ])
          ]),
        ]),
        InfoDialogBody(
          title: "操作成功",
          message: "您的文件已成功保存。",
          buttonText: "好的",
          onTapDismiss: () {
            print('InfoDialogBody-用户点击确认');
          },
          type: SemanticEnum.success, // 使用成功类型的颜色主题
          noImage: false, // 显示默认的成功图标
        ),
        Write.header3('.2.2 消息弹窗的使用'),
        Write.paragraph('现在，你可以点击下面的按钮测试对应的消息弹窗。'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SemanticButton(
              text: 'primary弹窗',
              type: SemanticEnum.primary,
              isOutlined: true,
              onTap: () => InfoDialogs.show(
                context,
                title: "你好啊！",
                message: "这是一个primary消息弹窗",
                buttonText: "我知道了",
                onTapDismiss: () {
                  Navigator.of(context).pop();
                },
                type: SemanticEnum.primary,
              ),
            ),
            const Gap(10),
            SemanticButton(
              text: 'secondary弹窗',
              type: SemanticEnum.secondary,
              isOutlined: true,
              onTap: () => InfoDialogs.show(
                context,
                title: "你好啊！",
                message: "这是一个secondary消息弹窗",
                buttonText: "我知道了",
                onTapDismiss: () {
                  Navigator.of(context).pop();
                },
                type: SemanticEnum.secondary,
              ),
            ),
            const Gap(10),
            SemanticButton(
              text: 'info弹窗',
              type: SemanticEnum.info,
              isOutlined: true,
              onTap: () => InfoDialogs.show(
                context,
                title: "你好啊！",
                message: "这是一个info消息弹窗",
                buttonText: "我知道了",
                onTapDismiss: () {
                  Navigator.of(context).pop();
                },
                type: SemanticEnum.info,
              ),
            ),
            const Gap(10),
            SemanticButton(
              text: 'success弹窗',
              type: SemanticEnum.success,
              isOutlined: true,
              onTap: () => InfoDialogs.show(
                context,
                title: "你好啊！",
                message: "这是一个success消息弹窗",
                buttonText: "我知道了",
                onTapDismiss: () {
                  Navigator.of(context).pop();
                },
                type: SemanticEnum.success,
              ),
            ),
            const Gap(10),
            SemanticButton(
              text: 'warning弹窗',
              type: SemanticEnum.warning,
              isOutlined: true,
              onTap: () => InfoDialogs.show(
                context,
                title: "你好啊！",
                message: "这是一个warning消息弹窗",
                buttonText: "我知道了",
                onTapDismiss: () {
                  Navigator.of(context).pop();
                },
                type: SemanticEnum.warning,
              ),
            ),
            const Gap(10),
            SemanticButton(
              text: 'danger弹窗',
              type: SemanticEnum.danger,
              isOutlined: true,
              onTap: () => InfoDialogs.show(
                context,
                title: "你好啊！",
                message: "这是一个danger消息弹窗",
                buttonText: "我知道了",
                onTapDismiss: () {
                  Navigator.of(context).pop();
                },
                type: SemanticEnum.danger,
              ),
            ),
            const Gap(10),
            SemanticButton(
              text: 'fatal弹窗',
              type: SemanticEnum.fatal,
              isOutlined: true,
              onTap: () => InfoDialogs.show(
                context,
                title: "你好啊！",
                message: "这是一个fatal消息弹窗",
                buttonText: "我知道了",
                onTapDismiss: () {
                  Navigator.of(context).pop();
                },
                type: SemanticEnum.fatal,
              ),
            ),
          ],
        ),
        const Gap(10),
        Write.header2('.3 确认弹窗（ConfirmDialog）'),
        Write.header3('.3.1 确认弹窗的构成'),
        Write.paragraph(
            '确认弹窗（ConfirmDialogs）是设计中用于在执行重要或潜在影响较大的操作前要求用户确认的一种界面元素。这种类型的弹窗帮助防止用户意外执行不可逆操作，确保用户明确其行为的后果。以下是ConfirmDialog的主要构成元素：'),
        Write.orderedList([
          Write.listItem('图标（Icon）', [
            Write.unorderedList([
              Write.listItem('作用：帮助视觉上传达消息的严重性或类型。'),
              Write.listItem('示例：垃圾桶图标表示删除，警告图标表示警告或重要提示。'),
            ]),
          ]),
          Write.listItem('标题（Title）', [
            Write.listItem('作用：简洁地表达弹窗的目的或询问。'),
            Write.listItem('示例：「确认删除」、「退出登录确认」等。'),
          ]),
          Write.listItem('消息内容（Message Content）', [
            Write.listItem('作用：详细说明需要用户确认的操作及其可能的后果。'),
            Write.listItem('示例：「您确定要删除此文件吗？此操作无法撤销。」或「退出后将需要重新登录，继续吗？」'),
          ]),
          Write.listItem('确认按钮（Confirm Button）', [
            Write.listItem('作用：用户点击以同意并继续执行操作。'),
            Write.listItem('示例：通常标记为“确认”，“删除”，“退出”等，明确表示操作的性质。'),
          ]),
          Write.listItem('取消按钮（Cancel Button）', [
            Write.listItem('作用：提供用户一个退出弹窗而不执行操作的选项。'),
            Write.listItem('例：标记为“取消”，“返回”，或简单的“X”图标。'),
          ]),
        ]),
        const Gap(10),
        ConfirmDialogBody(
          title: "确认删除",
          message: "您确定要删除这个文件吗？这个操作是不可逆的。",
          confirmButtonText: "删除",
          cancelButtonText: "取消",
          onTapConfirm: () {
            // 执行删除操作
            Navigator.of(context).pop(); // 关闭对话框
          },
          onTapCancel: () {
            Navigator.of(context).pop(); // 只关闭对话框，不执行操作
          },
          type: SemanticEnum.warning, // 使用警告类型的颜色主题
          noImage: true, // 不显示图片
        ),
        const Gap(10),
        Write.header3('.3.2 确认弹窗的使用'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SemanticButton(
              text: 'primary弹窗',
              type: SemanticEnum.primary,
              onTap: () => ConfirmDialogs.zoomIn(
                context,
                title: "你确定吗",
                message: "这个是primary确认弹窗",
                confirmButtonText: "确定",
                cancelButtonText: "真的确定",
                onTapCancel: () {
                  Navigator.of(context).pop();
                },
                onTapConfirm: () {
                  Navigator.of(context).pop();
                },
                type: SemanticEnum.primary,
              ),
            ),
            const Gap(10),
            SemanticButton(
              text: 'secondary弹窗',
              type: SemanticEnum.secondary,
              onTap: () => ConfirmDialogs.zoomIn(
                context,
                title: "你确定吗",
                message: "这个是secondary确认弹窗",
                confirmButtonText: "确定",
                cancelButtonText: "真的确定",
                onTapCancel: () {
                  Navigator.of(context).pop();
                },
                onTapConfirm: () {
                  Navigator.of(context).pop();
                },
                type: SemanticEnum.secondary,
              ),
            ),
            const Gap(10),
            SemanticButton(
              text: 'info弹窗',
              type: SemanticEnum.info,
              onTap: () => ConfirmDialogs.zoomIn(
                context,
                title: "你确定吗",
                message: "这个是info确认弹窗",
                confirmButtonText: "确定",
                cancelButtonText: "真的确定",
                onTapCancel: () {
                  Navigator.of(context).pop();
                },
                onTapConfirm: () {
                  Navigator.of(context).pop();
                },
                type: SemanticEnum.info,
              ),
            ),
            const Gap(10),
            SemanticButton(
              text: 'success弹窗',
              type: SemanticEnum.success,
              onTap: () => ConfirmDialogs.zoomIn(
                context,
                title: "你确定吗",
                message: "这个是success确认弹窗",
                confirmButtonText: "确定",
                cancelButtonText: "真的确定",
                onTapCancel: () {
                  Navigator.of(context).pop();
                },
                onTapConfirm: () {
                  Navigator.of(context).pop();
                },
                type: SemanticEnum.success,
              ),
            ),
            const Gap(10),
            SemanticButton(
              text: 'warning弹窗',
              type: SemanticEnum.warning,
              onTap: () => ConfirmDialogs.zoomIn(
                context,
                title: "你确定吗",
                message: "这个是warning确认弹窗",
                confirmButtonText: "确定",
                cancelButtonText: "真的确定",
                onTapCancel: () {
                  Navigator.of(context).pop();
                },
                onTapConfirm: () {
                  Navigator.of(context).pop();
                },
                type: SemanticEnum.warning,
              ),
            ),
            const Gap(10),
            SemanticButton(
              text: 'danger弹窗',
              type: SemanticEnum.danger,
              onTap: () => ConfirmDialogs.zoomIn(
                context,
                title: "你确定吗",
                message: "这个是danger确认弹窗",
                confirmButtonText: "确定",
                cancelButtonText: "真的确定",
                onTapCancel: () {
                  Navigator.of(context).pop();
                },
                onTapConfirm: () {
                  Navigator.of(context).pop();
                },
                type: SemanticEnum.danger,
              ),
            ),
            const Gap(10),
            SemanticButton(
              text: 'fatal弹窗',
              type: SemanticEnum.fatal,
              onTap: () => ConfirmDialogs.zoomIn(
                context,
                title: "你确定吗",
                message: "这个是fatal确认弹窗",
                confirmButtonText: "确定",
                cancelButtonText: "真的确定",
                onTapCancel: () {
                  Navigator.of(context).pop();
                },
                onTapConfirm: () {
                  Navigator.of(context).pop();
                },
                type: SemanticEnum.fatal,
              ),
            ),
          ],
        ),
        const Gap(10),
        Write.header2('.4 输入弹窗'),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
          child: const Text('primary'),
        ),
      ],
    );
  }
}
