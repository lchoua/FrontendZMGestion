import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_icon_button.dart';
import 'package:getflutter/shape/gf_icon_button_shape.dart';

class IconButtonTableAction extends StatelessWidget {
  final IconData iconData;
  final Function onPressed;
  final double iconSize;
  final Color color;

  const IconButtonTableAction({
    Key key, 
    this.iconData,
    this.onPressed,
    this.iconSize = 18,
    this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GFIconButton(
      icon: Icon(
        iconData != null ? iconData : Icons.image,
        size: iconSize,
        color: color != null ? color : Theme.of(context).primaryTextTheme.bodyText1.color.withOpacity(0.6),
      ),
      shape: GFIconButtonShape.circle,
      color: Colors.transparent,
      hoverColor: Colors.black.withOpacity(0.1),
      disabledColor: Colors.black.withOpacity(0.16),
      onPressed: onPressed
    );
  }
}