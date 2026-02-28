import 'package:flutter/material.dart';

import '../constants/retro_theme.dart';
import 'retro_widgets.dart';

class TaskPilotPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final bool fullWidth;

  const TaskPilotPrimaryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = RetroColors.neonPurple,
    this.textColor = RetroColors.retroWhite,
    this.fullWidth = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RetroButton(
      label: label,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      textColor: textColor,
      width: fullWidth ? double.infinity : null,
    );
  }
}
