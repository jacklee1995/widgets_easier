import 'package:flutter/material.dart';
import 'package:widgets_easier/widgets_easier.dart';

import 'result_item.dart';

class BaiduPaginationViewDelegate
    extends PaginationViewDelegate<Map<String, dynamic>> {
  @override
  Widget refreshableView(
    BuildContext context,
    PaginationLoadingController<Map<String, dynamic>> controller,
    Widget child,
  ) {
    return RefreshIndicator(
      onRefresh: controller.onRefresh,
      child: child,
    );
  }

  @override
  Widget childrenLayoutView(
    BuildContext context,
    PaginationLoadingController<Map<String, dynamic>> controller,
    List<Map<String, dynamic>> children,
    IndexedWidgetBuilder itemBuilder,
  ) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: children.length,
            itemBuilder: (context, index) => itemBuilder(context, index),
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
        Container(
          color: Colors.grey,
          child: _buildPagination(context, controller),
        ),
      ],
    );
  }

  @override
  Widget itemBuilder(
    BuildContext context,
    PaginationLoadingController<Map<String, dynamic>> controller,
    Map<String, dynamic> item,
  ) {
    return ResultItem(item: item);
  }

  // 正在加载时的页面UI
  @override
  Widget loadingIndicator(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  // 数据为空时的页面
  @override
  Widget emptyIndicator(BuildContext context) {
    return const Center(child: Text('No search results'));
  }

  // 分页器行
  Widget _buildPagination(
    BuildContext context,
    PaginationLoadingController<Map<String, dynamic>> controller,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed:
              controller.currentPage > 1 ? () => controller.loadPage(1) : null,
          icon: const Icon(Icons.first_page),
        ),
        IconButton(
          onPressed: controller.hasPrevious
              ? () => controller.loadPage(controller.currentPage - 1)
              : null,
          icon: const Icon(Icons.chevron_left),
        ),
        for (int i = 1; i <= controller.totalPages; i++)
          TextButton(
            onPressed: i != controller.currentPage
                ? () => controller.loadPage(i)
                : null,
            style: TextButton.styleFrom(
              backgroundColor: i == controller.currentPage
                  ? Theme.of(context).primaryColor
                  : null,
              foregroundColor:
                  i == controller.currentPage ? Colors.white : null,
            ),
            child: Text(i.toString()),
          ),
        IconButton(
          onPressed: controller.hasNext
              ? () => controller.loadPage(controller.currentPage + 1)
              : null,
          icon: const Icon(Icons.chevron_right),
        ),
        IconButton(
          onPressed: controller.currentPage < controller.totalPages
              ? () => controller.loadPage(controller.totalPages)
              : null,
          icon: const Icon(Icons.last_page),
        ),
      ],
    );
  }
}
