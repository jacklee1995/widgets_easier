import 'package:flutter/material.dart';
import 'package:widgets_easier/widgets_easier.dart';

import 'data_api.dart';
import 'search_pagination_view_delegate.dart';

// 使用分页器的示例页面
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: Colors.amber,
              height: 60,
              child: const Row(
                children: [
                  BackButton(),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              width: 1120,
              child: PaginationView<Map<String, dynamic>>(
                controller: PaginationLoadingController<Map<String, dynamic>>(
                  pageSize: 10,
                  onLoad: DataApi.onLoad,
                ),
                delegate: SearchPaginationViewDelegate(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
