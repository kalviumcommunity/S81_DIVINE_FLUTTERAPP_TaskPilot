import 'package:flutter/material.dart';
import '../constants/retro_theme.dart';

/// Retro Card Widget with 3D Depth Effect
class RetroCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Color borderColor;
  final double elevation;
  final VoidCallback? onTap;
  final bool hasBorder;

  const RetroCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor = RetroColors.retroWhite,
    this.borderColor = RetroColors.neonPurple,
    this.elevation = 8,
    this.onTap,
    this.hasBorder = true,
  }) : super(key: key);

  @override
  State<RetroCard> createState() => _RetroCardState();
}

class _RetroCardState extends State<RetroCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: widget.hasBorder
                ? Border.all(
                    color: _isHovered
                        ? widget.borderColor
                        : widget.borderColor.withOpacity(0.5),
                    width: 2,
                  )
                : null,
            borderRadius: BorderRadius.circular(RetroBorderRadius.md),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: widget.borderColor.withOpacity(0.4),
                  blurRadius: widget.elevation + 4,
                  spreadRadius: 2,
                )
              else
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: widget.elevation,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Padding(
            padding: widget.padding,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// Retro Button Widget
class RetroButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double? width;
  final double height;
  final bool isOutlined;

  const RetroButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = RetroColors.neonPurple,
    this.textColor = RetroColors.retroWhite,
    this.width,
    this.height = 48,
    this.isOutlined = false,
  }) : super(key: key);

  @override
  State<RetroButton> createState() => _RetroButtonState();
}

class _RetroButtonState extends State<RetroButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.isOutlined ? Colors.transparent : widget.backgroundColor,
          border: Border.all(
            color: widget.backgroundColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(RetroBorderRadius.sm),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: widget.backgroundColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        transform: Matrix4.translationValues(0, _isPressed ? 2 : 0, 0),
        child: Center(
          child: Text(
            widget.label,
            style: RetroTypography.retroTitle.copyWith(
              color: widget.isOutlined
                  ? widget.backgroundColor
                  : widget.textColor,
            ),
          ),
        ),
      ),
    );
  }
}

/// Retro Task Card for Dashboard
class RetroTaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String deadline;
  final String status;
  final Color priorityColor;
  final VoidCallback? onTap;

  const RetroTaskCard({
    Key? key,
    required this.title,
    required this.description,
    required this.deadline,
    required this.status,
    this.priorityColor = RetroColors.neonPurple,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RetroCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with priority indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: RetroTypography.retroTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: priorityColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: priorityColor.withOpacity(0.5),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: RetroSpacing.sm),
          // Description
          Text(
            description,
            style: RetroTypography.retroBody.copyWith(
              color: RetroColors.retroGray,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: RetroSpacing.md),
          // Footer with deadline and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Due: $deadline',
                style: RetroTypography.retroLabel,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: RetroSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(RetroBorderRadius.sm),
                ),
                child: Text(
                  status,
                  style: RetroTypography.retroLabel.copyWith(
                    color: priorityColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Retro Header Widget
class RetroHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  const RetroHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(RetroSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            RetroColors.neonPurple.withOpacity(0.1),
            RetroColors.neonCyan.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(
          bottom: BorderSide(
            color: RetroColors.neonPurple.withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: RetroTypography.retroHeadline,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: RetroSpacing.xs),
                Text(
                  subtitle!,
                  style: RetroTypography.retroLabel,
                ),
              ],
            ],
          ),
          if (actions != null)
            Row(
              children: actions!,
            ),
        ],
      ),
    );
  }
}

/// Retro Status Badge
class RetroStatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const RetroStatusBadge({
    Key? key,
    required this.label,
    this.backgroundColor = RetroColors.neonGreen,
    this.textColor = RetroColors.retroBlack,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: RetroSpacing.md,
        vertical: RetroSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(RetroBorderRadius.sm),
        border: Border.all(
          color: backgroundColor.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: RetroSpacing.xs),
          ],
          Text(
            label,
            style: RetroTypography.retroLabel.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
