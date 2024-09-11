import 'package:flutter/material.dart';

import 'pagination_loading_controller.dart';
import 'pagination_view_delegate.dart';

/// 一个用于显示分页数据的视图组件。
///
/// [PaginationView] 负责根据分页控制器的状态显示不同的内容。
/// 它使用 [PaginationViewDelegate] 来构建具体的UI组件。
class PaginationView<T> extends StatelessWidget {
  /// 分页控制器，用于管理分页数据的加载和状态。
  final PaginationLoadingController<T> controller;

  /// 分页视图委托，用于构建具体的UI组件。
  final PaginationViewDelegate<T> delegate;

  /// 创建一个 [PaginationView] 实例。
  ///
  /// [controller] 和 [delegate] 参数不能为空。
  const PaginationView({
    super.key,
    required this.controller,
    required this.delegate,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        if (controller.items.isEmpty) {
          if (controller.isLoading) {
            return delegate.loadingIndicator(context);
          } else {
            return delegate.emptyIndicator(context);
          }
        }

        return delegate.refreshableView(
          context,
          controller,
          delegate.childrenLayoutView(
            context,
            controller,
            controller.items,
            (context, index) => delegate.itemBuilder(
                context, controller, controller.items[index]),
          ),
        );
      },
    );
  }
}
