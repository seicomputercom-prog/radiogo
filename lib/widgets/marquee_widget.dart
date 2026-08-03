import 'package:flutter/material.dart';

/// A marquee widget that scrolls text horizontally when the text overflows.
/// Provides smooth infinite scrolling animation similar to TuneIn.
class MarqueeWidget extends StatefulWidget {
  final String text;
  final double velocity;
  final double startPadding;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;

  const MarqueeWidget({
    super.key,
    required this.text,
    this.velocity = 30.0,
    this.startPadding = 20.0,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines,
  });

  @override
  State<MarqueeWidget> createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ScrollController _scrollController;

  double _textWidth = 0.0;
  double _containerWidth = 0.0;
  bool _needsMarquee = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: (widget.text.length * 100).clamp(2000, 15000),
      ),
    )..repeat();

    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(MarqueeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _controller.duration = Duration(
        milliseconds: (widget.text.length * 100).clamp(2000, 15000),
      );
      _scrollController.jumpTo(0);
    }
  }

  void _checkOverflow() {
    if (mounted) {
      final textPainter = TextPainter(
        text: TextSpan(text: widget.text, style: widget.style),
        maxLines: widget.maxLines,
        textDirection: TextDirection.ltr,
      )..layout(minWidth: 0, maxWidth: double.infinity);

      _textWidth = textPainter.width;
      _containerWidth = context.size?.width ?? 0;

      final needsMarquee = _textWidth > _containerWidth && _containerWidth > 0;
      if (_needsMarquee != needsMarquee) {
        setState(() {
          _needsMarquee = needsMarquee;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _containerWidth = constraints.maxWidth;

        final textSpan = TextSpan(
          text: widget.text,
          style: widget.style ??
              DefaultTextStyle.of(context).style,
        );

        final textPainter = TextPainter(
          text: textSpan,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        )..layout(minWidth: 0, maxWidth: double.infinity);

        _textWidth = textPainter.width;
        _needsMarquee = _textWidth > _containerWidth && _containerWidth > 0;

        if (!_needsMarquee) {
          return Text(
            widget.text,
            style: widget.style,
            textAlign: widget.textAlign,
            maxLines: widget.maxLines,
            overflow: TextOverflow.ellipsis,
          );
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                -(_textWidth + widget.startPadding) * _controller.value,
                0,
              ),
              child: Text(
                widget.text,
                style: widget.style,
                maxLines: widget.maxLines,
                softWrap: false,
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

/// An animated builder that rebuilds on every frame.
class AnimatedBuilder extends StatelessWidget {
  final Animation<double> animation;
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilderImpl(
      listenable: animation,
      builder: builder,
      child: child,
    );
  }
}

/// A simpler marquee using ListView for smooth scrolling.
class SimpleMarquee extends StatefulWidget {
  final String text;
  final double velocity;
  final TextStyle? style;
  final Widget? leading;
  final Widget? trailing;

  const SimpleMarquee({
    super.key,
    required this.text,
    this.velocity = 40.0,
    this.style,
    this.leading,
    this.trailing,
  });

  @override
  State<SimpleMarquee> createState() => _SimpleMarqueeState();
}

class _SimpleMarqueeState extends State<SimpleMarquee> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScrolling();
    });
  }

  void _startScrolling() async {
    if (!mounted || _scrollController.hasClients == false) return;

    final textWidth = _getTextWidth();
    final containerWidth = _scrollController.position.maxScrollExtent;

    if (containerWidth <= 0) {
      // No overflow, no scrolling needed
      return;
    }

    // Scroll right to left
    await Future.delayed(const Duration(seconds: 1));

    while (mounted) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        if (maxScroll <= 0) break;

        final duration = Duration(
          milliseconds: ((maxScroll / widget.velocity) * 1000).round(),
        );

        await _scrollController.animateTo(
          maxScroll,
          duration: duration,
          curve: Curves.linear,
        );

        if (!mounted) break;

        await Future.delayed(const Duration(seconds: 1));

        if (!mounted) break;

        _scrollController.jumpTo(0);

        await Future.delayed(const Duration(seconds: 1));
      } else {
        break;
      }
    }
  }

  double _getTextWidth() {
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.width;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.leading != null) widget.leading!,
          Text(
            widget.text,
            style: widget.style,
            softWrap: false,
          ),
          const SizedBox(width: 40),
          Text(
            widget.text,
            style: widget.style,
            softWrap: false,
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
