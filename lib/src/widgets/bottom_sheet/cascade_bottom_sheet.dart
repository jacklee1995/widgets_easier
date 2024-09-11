import 'package:flutter/material.dart';

class CascadeBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final String cancelButtonText;
  final String confirmButtonText;
  final TextStyle? cancelButtonStyle;
  final TextStyle? confirmButtonStyle;
  final bool enableLoop;

  const CascadeBottomSheet({
    super.key,
    required this.items,
    required this.cancelButtonText,
    required this.confirmButtonText,
    this.cancelButtonStyle,
    this.confirmButtonStyle,
    this.enableLoop = false,
  });

  @override
  State<CascadeBottomSheet> createState() => _CascadeBottomSheetState();
}

class _CascadeBottomSheetState extends State<CascadeBottomSheet> {
  List<String> _selectedItems = [];
  List<List<Map<String, dynamic>>> _levelItems = [];
  List<FixedExtentScrollController> _scrollControllers = [];
  int _maxDepth = 1; // 最大深度初始化为1

  @override
  void initState() {
    super.initState();
    _maxDepth = _calculateMaxDepth(widget.items); // 计算最大深度
    _levelItems = [widget.items];
    _selectedItems = List.generate(_maxDepth, (index) => '');
    _scrollControllers =
        List.generate(_maxDepth, (index) => FixedExtentScrollController());
  }

  int _calculateMaxDepth(List<Map<String, dynamic>> items, [int depth = 1]) {
    int maxDepth = depth;
    for (var item in items) {
      if (item.containsKey('children')) {
        int childDepth = _calculateMaxDepth(item['children'], depth + 1);
        if (childDepth > maxDepth) {
          maxDepth = childDepth;
        }
      }
    }
    return maxDepth;
  }

  void _onSelectItem(int level, int index) {
    setState(() {
      _selectedItems[level] = _levelItems[level][index]['label'];

      if (level < _maxDepth - 1) {
        _levelItems = _levelItems.sublist(0, level + 1);
        if (_levelItems[level][index].containsKey('children')) {
          _levelItems.add(_levelItems[level][index]['children']);
        } else {
          _levelItems.add([]);
        }

        _selectedItems = _selectedItems.sublist(0, level + 1);
        _selectedItems
            .addAll(List.generate(_maxDepth - level - 1, (index) => ''));

        _scrollControllers = _scrollControllers.sublist(0, level + 1);
        _scrollControllers.addAll(List.generate(
            _maxDepth - level - 1, (index) => FixedExtentScrollController()));
      }

      _scrollControllers[level].animateToItem(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  widget.cancelButtonText,
                  style: widget.cancelButtonStyle ??
                      const TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () {
                  List<String> filteredSelectedItems =
                      _selectedItems.where((item) => item.isNotEmpty).toList();
                  Navigator.pop(context, filteredSelectedItems);
                },
                child: Text(
                  widget.confirmButtonText,
                  style: widget.confirmButtonStyle ??
                      TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              children: List.generate(
                _maxDepth,
                (level) => Expanded(
                  child: _buildWheelScrollView(level),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWheelScrollView(int level) {
    return Stack(
      children: [
        ListWheelScrollView.useDelegate(
          controller: _scrollControllers[level],
          itemExtent: 30,
          onSelectedItemChanged: (index) => _onSelectItem(level, index),
          childDelegate: widget.enableLoop
              ? ListWheelChildLoopingListDelegate(
                  children: _levelItems.length > level
                      ? _levelItems[level].map((item) {
                          return Container(
                            alignment: Alignment.center,
                            child: Text(
                              item['label'],
                              style: TextStyle(
                                color: _selectedItems[level] == item['label']
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          );
                        }).toList()
                      : [],
                )
              : ListWheelChildListDelegate(
                  children: _levelItems.length > level
                      ? _levelItems[level].map((item) {
                          return Container(
                            alignment: Alignment.center,
                            child: Text(
                              item['label'],
                              style: TextStyle(
                                color: _selectedItems[level] == item['label']
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          );
                        }).toList()
                      : [],
                ),
          physics: const FixedExtentScrollPhysics(),
          diameterRatio: 1.5,
          overAndUnderCenterOpacity: 0.5,
          perspective: 0.001,
        ),
        Positioned(
          top: 52.0 * 2 - 1,
          left: 0,
          right: 0,
          child: Container(
            height: 1,
            color: Colors.grey[300],
          ),
        ),
        Positioned(
          top: 45.0 * 3 - 1,
          left: 0,
          right: 0,
          child: Container(
            height: 1,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }
}
