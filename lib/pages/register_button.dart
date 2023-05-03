import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final String text;
  final Function onTapCallback;
  final Color color;
  final Color colorText;
  final Image img_icon;
  final Color color_cont;

  const RegisterButton({
    super.key,
    required this.text,
    required this.onTapCallback,
    required this.color,
    required this.colorText,
    required this.img_icon,
    required this.color_cont}
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapCallback(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          border: Border.all(
            color: color_cont,
            width: 2,
          ),
          color: color,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: img_icon,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                text,
                style: TextStyle(
                  color: colorText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
