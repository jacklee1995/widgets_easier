

### 14. 加载框架

数据分页就是将一个庞大的数据分为若干份，每次仅仅加载其中的一个数据单元。后端框架（如Django），一般提供了比较完善的数据分页方案，这些方案使得我们在前端中可以比较方便地获得以下几个方面的数据：

- `next`：表示下一页
- `previous`：表示上一页
- `has_next`：表示是否有下一页
- `has_previous`：表示是否有上一页
- `total_pages`：表示分页的总页面数量
- `current_page`：当前的页码
- `results`：本页数据

加载框架用于方便处理各种分页加载数据问题，它基于委托类为完成具体子项和子项组织，使得可以在框架的基础上灵活构建UI，这意味这还可以使用各种第三方库来完成不同的的加载效果。例如，如果分页对象时一个懒加载的列表，你可以结合第三方的刷新库来实现加载特效。

分页框架中的 `PaginatedResponse<T>` 是一个数据模型，表示一个分页单元，它完整地包含了上面地分页信息和数据。**PaginatedResponse**提供了一个`fromMap`工厂构造方法，这个方法需要指定两个参数：

1. `map`：是一个包含了所有地分页参数和数据的映射；
2. `fromMap`：是一个解析 `map['results']` 为 `List<T>` 的解析函数。



例如下面的例子集合第三方的EasyRefresh完成率新加载：



![studio64_KgDZISJ8cE](https://raw.githubusercontent.com/jacklee1995/widgets_easier/master/readme_pics/studio64_KgDZISJ8cE.gif)

现在假设后端又一个返回数据的**API**，这用**Django**自带分页很容易实现（哦，字符串约定是因为我喜欢用Django写后端，但是这里仅仅是在Flutter中提供一个Mock伪数据）：

```dart
/// 这个是一个虚拟的API，来表示后端返回数据
class MockApi {
  static Future<Map<String, dynamic>> post(String url,
      {Map<String, dynamic>? data}) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(seconds: 1));

    // 模拟的API响应数据
    final page = data?['page'] ?? 1;
    final pageSize = data?['pageSize'] ?? 20;

    return {
      'next': page < 5 ? 'next_page_url' : null,
      'previous': page > 1 ? 'previous_page_url' : null,
      'has_next': page < 5,
      'has_previous': page > 1,
      'total_pages': 5,
      'current_page': page,
      'results': List.generate(pageSize, (index) {
        final id = (page - 1) * pageSize + index;
        return {
          'id': id,
          'title': 'Item $id',
          'subtitle': 'Subtitle $id',
        };
      }),
    };
  }
}

```

然后假装我们有一个具体的**API**类用于请求这里需要的分页数据：



我们先定义一个数据单元的**Model**：

```dart
import 'package:flutter/material.dart';

class TileItem {
  final Widget icon;
  final String title;
  final String subtitle;

  TileItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
```

然后在委托子类中实现样式：

```dart
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
```

最后用于我们的UI：

```dart
import 'package:flutter/material.dart';
import 'package:widgets_easier/widgets_easier.dart';

import 'data_api.dart';
import 'tile_item.dart';
import 'tile_list_pagination_view_delegate.dart';

class TileListPage extends StatefulWidget {
  const TileListPage({super.key});

  @override
  State<TileListPage> createState() => _TileListPageState();
}

class _TileListPageState extends State<TileListPage> {
  late final PaginationLoadingController<TileItem> _controller;

  @override
  void initState() {
    super.initState();
    _controller = PaginationLoadingController<TileItem>(
      pageSize: 20,
      onLoad: (page, pageSize) async {
        final response = await DataApi.onLoad(page, pageSize);
        return PaginatedResponse(
          currentPage: response.currentPage,
          totalPages: response.totalPages,
          hasNext: response.hasNext,
          hasPrevious: response.hasPrevious,
          results: response.results.map((item) {
            return TileItem(
              icon: const Icon(Icons.person),
              title: item['title'],
              subtitle: item['subtitle'],
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tile List')),
      body: PaginationView<TileItem>(
        controller: _controller,
        delegate: TileListPaginationViewDelegate(),
      ),
    );
  }
}

```



