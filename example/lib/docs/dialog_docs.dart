import 'package:example/widgets/docs_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:widgets_easier/widgets_easier.dart';

import '../login/login_view.dart';

class DialogDocs extends StatelessWidget {
  const DialogDocs({super.key});
  @override
  Widget build(BuildContext context) {
    return DocsWidget(
      children: [
        Write.header2('11.1 警告弹窗（AlertDialog）'),
        Write.header2('11.2 消息弹窗（InfoDialog）'),
        Write.paragraph('用于显示简短的信息或反馈。'),
        Write.paragraph(
            '除了InfoDialog外，吐丝（Toast）也是一种消息型弹窗。但是Toast通常自动消失，不需要用户操作；InfoDialog则需要用户手动关闭。一般来说，如果消息不是那么重要，则可以使用Toast；反之，如果需要引起用户更多的注意，则使用InfoDialog。'),
        Write.header3('11.2.1 消息窗体的构成'),
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
        InfoDialog(
          title: "操作成功",
          message: "您的文件已成功保存。",
          buttonText: "好的",
          onTapDismiss: () {
            print('InfoDialog-用户点击确认');
          },
          type: SemanticEnum.success, // 使用成功类型的颜色主题
          noImage: false, // 显示默认的成功图标
        ),
        Write.header3('11.2.2 消息弹窗的使用'),
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
        Write.header2('11.3 确认弹窗（ConfirmDialog）'),
        Write.header3('11.3.1 确认弹窗的构成'),
        Write.paragraph(
            '确认型弹窗（Confirmation Dialog）用于在执行某些可能具有重大影响的操作前，要求用户确认其决定。这种弹窗通常包含以下元素：'),
        Write.orderedList([
          Write.listItem('图标（可选）；'),
          Write.listItem('标题：简洁明了地描述所需确认的操作;'),
          Write.listItem('内容：提供操作的详细信息，帮助用户做出决策;'),
          Write.listItem('操作按钮：通常是“确认”和“取消”，有时可能包括其他选项，如“保存”，“不保存”，“取消”;'),
        ]),
        const Gap(10),
        ConfirmDialogBody(
          title: "确认删除",
          message: "您确定要删除这个文件吗？这个操作是不可逆的。",
          confirmButtonText: "删除",
          cancelButtonText: "取消",
          onTapConfirm: () {
            // 执行删除操作
          },
          onTapCancel: () {},
          type: SemanticEnum.warning, // 使用警告类型的颜色主题
          noImage: true,
        ),
        const Gap(10),
        Write.header3('11.3.2 确认型弹窗的使用'),
        Write.paragraph('下面的例子展示了确认型弹窗的基本用法'),
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
        Write.header2('11.4 Windows风格的弹窗（WinDialogs）'),
        Write.paragraph('Windows风格弹窗有三个部分组成，分别是Header、Body、Footer。'),
        WinStyleDialog(
          icon: const Icon(Icons.run_circle_outlined),
          title: 'title',
          text:
              '在这个世界上，我们每个人都应该深刻理解，生活中，若能够不断地反思和自省，那么我们就能更好地理解生活的真谛。然而，问题的关键究竟是什么？问题的答案其实非常简单。生活，到底应该如何实现。而这些并不是完全重要，更加重要的问题是，生活的发生，到底需要如何做到，不生活的发生，又会如何产生。每个人都不得不面对这些问题。',
          actions: [
            SemanticButton(
              text: '确定',
              width: 90,
              isOutlined: true,
              radius: 2,
              color: Colors.black,
              onTap: () {},
            ),
            const Gap(10),
            SemanticButton(
              text: '取消',
              width: 90,
              isOutlined: true,
              radius: 2,
              color: Colors.black,
              onTap: () {},
            ),
            const Gap(10),
            SemanticButton(
              text: '浏览',
              width: 90,
              isOutlined: true,
              radius: 2,
              color: Colors.black,
              onTap: () {},
            ),
          ],
        ),
        const Gap(10),
        Write.paragraph('下面的示例展示了调用一个Windoiws风格的弹窗。'),
        const Gap(10),
        Center(
          child: SemanticButton(
            text: '显示Windows风格弹窗',
            isOutlined: true,
            shrink: true,
            radius: 2,
            color: Colors.black,
            onTap: () => WinDialogs.show(
              context,
              title: 'title',
              icon: const Icon(Icons.run_circle_outlined),
              text: '在这个世界上，我们每个人都应该深刻理解，生活中，若能够不断地反思和自省，那么我们就能更好地理解生活的真谛。',
              contents: Row(
                children: [
                  const Text('打开(O):'),
                  const Gap(10),
                  Expanded(
                    child: Container(
                      height: 25,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                SemanticButton(
                  text: '确定',
                  width: 90,
                  isOutlined: true,
                  radius: 2,
                  color: Colors.black,
                  onTap: () {},
                ),
                const Gap(10),
                SemanticButton(
                  text: '取消',
                  width: 90,
                  isOutlined: true,
                  radius: 2,
                  color: Colors.black,
                  onTap: () {},
                ),
                const Gap(10),
                SemanticButton(
                  text: '浏览',
                  width: 90,
                  isOutlined: true,
                  radius: 2,
                  color: Colors.black,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        const Gap(20),
        Write.paragraph('可以看出的是，你不需要考虑图标的大小，即使你指定了图标大小，这在内部也是自动大小的。'),
        const Gap(20),
        Write.header2('11.4 Future型弹窗案例'),
        const Gap(20),
        SemanticButton(
          text: '案例',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          ),
        ),
        const Gap(20),
      ],
    );
  }
}
