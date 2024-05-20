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
