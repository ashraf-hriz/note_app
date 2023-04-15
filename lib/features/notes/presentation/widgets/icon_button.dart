import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';

class MyIconButton extends StatelessWidget {
  final IconData? icon;
  final VoidCallback onTap;
  final String txt;

  const MyIconButton({Key? key, this.icon, required this.onTap, this.txt = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: icon != null ? 44 : 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).primaryColor,
        ),
        child: Center(
          child: icon != null
              ? Icon(icon, color: Colors.white)
              : Text(
                  txt,
                  style: ThemeHelper.titleTextStyle.copyWith(fontSize: 18),
                ),
        ),
      ),
    );
  }
}
