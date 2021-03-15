import 'package:flutter/material.dart';

class MyNavigators {}

extension MyNavigator on BuildContext {
  navigateReplace(Widget route, {isDialog = false}) =>
      Navigator.pushReplacement(
        this,
        MaterialPageRoute(
          fullscreenDialog: isDialog,
          builder: (context) => route,
        ),
      );

  navigate(Widget route, {isDialog = false}) => Navigator.push(
        this,
        MaterialPageRoute(
          fullscreenDialog: isDialog,
          builder: (context) => route,
        ),
      );

  popToFirst() => Navigator.of(this).popUntil((route) => route.isFirst);

  popView() => Navigator.pop(this);

  navigateTransparentRoute(Widget route) {
    return Navigator.push(
      this,
      TransparentRoute(
        builder: (context) => route,
      ),
    );
  }
}

class TransparentRoute extends PageRoute<void> {
  TransparentRoute({
    required this.builder,
    RouteSettings? settings,
  }) : super(settings: settings, fullscreenDialog: false);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 350);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: SlideTransition(
          transformHitTests: false,
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: new SlideTransition(
            position: new Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(0.0, -1.0),
            ).animate(secondaryAnimation),
            child: result,
          ),
        ),
      ),
    );
  }
}
