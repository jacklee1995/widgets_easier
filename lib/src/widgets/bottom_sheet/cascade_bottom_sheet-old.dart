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

  @override
  void initState() {
    super.initState();
    _levelItems = [widget.items];
    _selectedItems = List.generate(4, (index) => '');
    _scrollControllers =
        List.generate(4, (index) => FixedExtentScrollController());
  }

  void _onSelectItem(int level, int index) {
    setState(() {
      _selectedItems[level] = _levelItems[level][index]['label'];

      if (level < 3) {
        _levelItems = _levelItems.sublist(0, level + 1);
        if (_levelItems[level][index].containsKey('children')) {
          _levelItems.add(_levelItems[level][index]['children']);
        } else {
          _levelItems.add([]);
        }

        _selectedItems = _selectedItems.sublist(0, level + 1);
        _selectedItems.addAll(List.generate(4 - level - 1, (index) => ''));

        _scrollControllers = _scrollControllers.sublist(0, level + 1);
        _scrollControllers.addAll(List.generate(
            4 - level - 1, (index) => FixedExtentScrollController()));
      }

      // 平滑滚动到选中的项
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
                      const TextStyle(
                        color: Colors.black,
                      ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, _selectedItems),
                child: Text(
                  widget.confirmButtonText,
                  style: widget.confirmButtonStyle ??
                      TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              children: List.generate(
                4,
                (level) => Expanded(
                  child: Stack(
                    children: [
                      ListWheelScrollView.useDelegate(
                        controller: _scrollControllers[level],
                        // 每个子项目主轴上的长度，以此调节文本行宽
                        itemExtent: 30,
                        onSelectedItemChanged: (index) =>
                            _onSelectItem(level, index),
                        childDelegate: widget.enableLoop
                            ? ListWheelChildLoopingListDelegate(
                                children: _levelItems.length > level
                                    ? _levelItems[level].map((item) {
                                        return Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            item['label'],
                                            style: TextStyle(
                                              color: _selectedItems[level] ==
                                                      item['label']
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
                                              color: _selectedItems[level] ==
                                                      item['label']
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
                      // 绘制两条横线
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
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
