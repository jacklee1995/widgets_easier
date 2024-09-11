import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:widgets_easier/widgets_easier.dart';

import '../../widgets/docs_widget.dart';
import 'tile_loading_page/tilelist_page.dart';
import 'web_pagination/search_page.dart';

class PaginatedLoaderDocs extends StatelessWidget {
  final int c;
  const PaginatedLoaderDocs(this.c, {super.key});
  @override
  Widget build(BuildContext context) {
    return DocsWidget(children: [
      Write.header1('$c. 分页加载框架'),
      Write.paragraph('数据分页就是将一个庞大的数据分为若干份，每次仅仅加载其中的一个数据单元。'),
      Write.paragraph(
          '后端框架（如Django），一般提供了比较完善的数据分页方案，这些方案使得我们在前端中可以比较方便地获得以下几个方面的数据：'),
      Write.orderedList([
        Write.listItem('next：表示下一页'),
        Write.listItem('previous：表示上一页'),
        Write.listItem('has_next：表示是否有下一页'),
        Write.listItem('has_previous：表示是否有上一页'),
        Write.listItem('total_pages：表示分页的总页面数量'),
        Write.listItem('current_page：当前的页码'),
        Write.listItem('results：本页数据'),
      ]),
      Write.paragraph(
          '分页框架中的 PaginatedResponse<T> 是一个数据模型，表示一个分页单元，它完整地包含了上面地分页信息和数据。'),
      Write.paragraph('PaginatedResponse提供了一个fromMap工厂构造方法，这个方法需要指定两个参数：'),
      Write.orderedList([
        Write.listItem('map：是一个包含了所有地分页参数和数据的映射；'),
        Write.listItem('fromMap：是一个解析 map[\'results\'] 为 List<T> 的解析函数。'),
      ]),
      Write.paragraph('PaginationLoadingController'),
      SemanticButton(
        text: '一个列表页面案例',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const TileListPage(),
          ),
        ),
      ),
      const Gap(20),
      SemanticButton(
        text: 'Web搜索分页器案例',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SearchPage(),
          ),
        ),
      ),
      const Gap(60),
    ]);
  }
}
