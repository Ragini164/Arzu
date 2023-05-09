import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String data;
  final VoidCallback ontap;
  final bool loading;
  final Color color;
  final Color textColor;

  const RoundButton({
    Key? key,
    required this.data,
    required this.ontap,
    this.loading = false,
    this.color = Colors.white,
    this.textColor =  const Color.fromARGB(255, 46, 1, 26),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: loading
              ? CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textColor,
                )
              : Text(
                  data,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800

                  ),
                ),
        ),
      ),
    );
  }
}

