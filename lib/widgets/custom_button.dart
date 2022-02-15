import 'package:flutter/material.dart';

import './../styles/app_colors.dart';
import './../styles/text_styles.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final Function() onTap;

  const AuthButton({Key key, @required this.onTap, @required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50.0,
        margin: const EdgeInsets.only(left: 20, right: 20),
        decoration: const BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Text(
            text,
            style: KTextStyle.authButtonTextStyle,
          ),
        ),
      ),
    );
  }
}
