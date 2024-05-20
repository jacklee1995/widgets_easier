import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:widgets_easier/widgets_easier.dart';

import 'tile_item.dart';

class TileListPaginationViewDelegate extends PaginationViewDelegate<TileItem> {
  late EasyRefreshController _refreshController;
  @override
  Widget refreshableView(
    BuildContext context,
    PaginationLoadingController<TileItem> controller,
    Widget child,
  ) {
    _refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    // 这里允许使用第三方刷新进行包装
    return EasyRefresh(
      controller: _refreshController,
      header: const ClassicHeader(
        dragText: 'Pull to refresh',
        armedText: 'Release ready',
        readyText: 'Refreshing...',
        processingText: 'Refreshing...',
        processedText: 'Succeeded',
        noMoreText: 'No more',
        failedText: 'Failed',
        messageText: 'Last updated at %T',
        safeArea: false,
      ),
      footer: const ClassicFooter(
        dragText: 'Pull to load',
        armedText: 'Release ready',
        readyText: 'Loading...',
        processingText: 'Loading...',
        processedText: 'Succeeded',
        noMoreText: 'No more',
        failedText: 'Failed',
        messageText: 'Last updated at %T',
      ),
      onRefresh: () async {
        await controller.onRefresh();
        _refreshController.finishRefresh();
        _refreshController.resetFooter();
      },
      onLoad: () async {
        print('onLoad called, hasNext: ${controller.hasNext}');
        if (controller.hasNext) {
          await controller.loadNextPage();
          print('loadNextPage completed, hasNext: ${controller.hasNext}');
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _refreshController.finishLoad(IndicatorResult.success);
          });
          _refreshController.finishLoad(IndicatorResult.success);
        } else {
          print('No more data');
          _refreshController.finishLoad(IndicatorResult.noMore);
        }
      },
      child: child,
    );
  }

  @override
  Widget childrenLayoutView(
    BuildContext context,
    PaginationLoadingController<TileItem> controller,
    List<TileItem> children,
    IndexedWidgetBuilder itemBuilder,
  ) {
    return ListView.separated(
      itemCount: children.length,
      itemBuilder: itemBuilder,
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  @override
  Widget itemBuilder(
    BuildContext context,
    PaginationLoadingController<TileItem> controller,
    TileItem item,
  ) {
    return ListTile(
      leading: item.icon,
      title: Text(item.title),
      subtitle: Text(item.subtitle),
    );
  }

  @override
  Widget loadingIndicator(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget emptyIndicator(BuildContext context) {
    return const Center(child: Text('No data'));
  }
}
