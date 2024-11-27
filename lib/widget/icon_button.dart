import 'package:flutter/material.dart';

class IconButtonApp extends StatelessWidget {
  final IconData iconData;
  final void Function()? onTap;

  final bool isSelected;
  const IconButtonApp({
    super.key,
    required this.iconData,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey[500],
          border: Border.all(
            color: isSelected ? Colors.red : Colors.grey[500]!,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: Icon(
          iconData,
          color: Colors.white,
        ),
      ),
    );
  }
}
