import 'package:flutter/material.dart';
import 'package:flutter_easy_animations/flutter_easy_animations.dart';

class AnimateExamples extends StatefulWidget {
  const AnimateExamples({super.key});

  @override
  State<AnimateExamples> createState() => _AnimateExamplesState();
}

class _AnimateExamplesState extends State<AnimateExamples>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animates = [
      AnimateStyles.bounce(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'bounce',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.flash(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'flash',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.pulse(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'pulse',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.rubberBand(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'rubberBand',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.shakeX(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'shakeX',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.shakeY(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'shakeY',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.headShake(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'headShake',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.swing(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'swing',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.tada(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'tada',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.wobble(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'wobble',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.jello(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'jello',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.heartBeat(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'heartBeat',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.backInDown(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'backInDown',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.backInLeft(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'backInLeft',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.backInRight(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'backInRight',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.backInUp(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'backInUp',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.backOutDown(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'backOutDown',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.backOutLeft(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'backOutLeft',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.backOutRight(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'backOutRight',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.backOutUp(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'backOutUp',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.bounceInDown(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'bounceInDown',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.bounceInLeft(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'bounceInLeft',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.bounceInRight(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'bounceInRight',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.bounceInUp(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'bounceInUp',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.bounceOut(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'bounceOut',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.bounceOutDown(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'bounceOutDown',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.bounceOutLeft(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'bounceOutLeft',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.bounceOutRight(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'bounceOutRight',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.bounceOutUp(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'bounceOutUp',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.fadeIn(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'fadeIn',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.fadeInDown(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'fadeInDown',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.fadeInDownBig(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'fadeInDownBig',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.fadeInLeft(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'fadeInLeft',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.fadeInLeftBig(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'fadeInLeftBig',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.fadeInRight(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'fadeInRight',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.fadeInRightBig(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'fadeInRightBig',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.fadeInUp(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'fadeInUp',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.fadeInUpBig(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'fadeInUpBig',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.fadeOut(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'fadeOut',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.fadeOutDown(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'fadeOutDown',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.fadeOutDownBig(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'fadeOutDownBig',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.fadeOutLeft(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'fadeOutLeft',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.fadeOutLeftBig(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'fadeOutLeftBig',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.fadeOutRight(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'fadeOutRight',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.fadeOutRightBig(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'fadeOutRightBig',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.fadeOutUp(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'fadeOutUp',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.fadeOutUpBig(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'fadeOutUpBig',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.flipInX(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'flipInX',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.flipInY(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'flipInY',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.flipOutX(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'flipOutX',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.flipOutY(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'flipOutY',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.lightSpeedInRight(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'lightSpeedInRight',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.lightSpeedInLeft(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'lightSpeedInLeft',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.lightSpeedOutRight(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'lightSpeedOutRight',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.lightSpeedOutLeft(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'lightSpeedOutLeft',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.rotateIn(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'rotateIn',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.rotateInDownLeft(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'rotateInDownLeft',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.rotateInDownRight(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'rotateInDownRight',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.rotateInUpLeft(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'rotateInUpLeft',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.rotateInUpRight(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'rotateInUpRight',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.rotateOut(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'rotateOut',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.rotateOutDownLeft(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'rotateOutDownLeft',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.rotateOutDownRight(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'rotateOutDownRight',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.rotateOutUpLeft(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'rotateOutUpLeft',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.rotateOutUpRight(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'rotateOutUpRight',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.slideInDown(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'slideInDown',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.slideInLeft(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'slideInLeft',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.slideInRight(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'slideInRight',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.slideInUp(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'slideInUp',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.slideOutDown(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'slideOutDown',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.slideOutLeft(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'slideOutLeft',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.slideOutRight(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'slideOutRight',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.slideOutUp(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'slideOutUp',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.zoomIn(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'zoomIn',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.zoomInDown(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'zoomInDown',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.zoomInLeft(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'zoomInLeft',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.zoomInRight(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'zoomInRight',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.zoomInUp(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'zoomInUp',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.zoomOut(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'zoomOut',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.zoomOutDown(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'zoomOutDown',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.zoomOutLeft(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'zoomOutLeft',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.zoomOutRight(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'zoomOutRight',
          style: TextStyle(fontSize: 16),
        ),
      ),
      AnimateStyles.zoomOutUp(
        _controller,
        const Text(
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          'zoomOutUp',
          style: TextStyle(fontSize: 16),
        ),
      ),
    ];
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true, // 根据子组件的总高度来设置GridView的高度
      physics: const NeverScrollableScrollPhysics(),
      children: animates
          .map((e) => Center(
                child: e,
              ))
          .toList(),
    );
  }
}
