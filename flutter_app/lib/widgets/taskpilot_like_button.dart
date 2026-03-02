import 'package:flutter/material.dart';

class TaskPilotLikeButton extends StatefulWidget {
  final bool initialLiked;
  final ValueChanged<bool>? onChanged;

  const TaskPilotLikeButton({
    Key? key,
    this.initialLiked = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<TaskPilotLikeButton> createState() => _TaskPilotLikeButtonState();
}

class _TaskPilotLikeButtonState extends State<TaskPilotLikeButton> {
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.initialLiked;
  }

  void _toggle() {
    setState(() {
      _isLiked = !_isLiked;
    });
    widget.onChanged?.call(_isLiked);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      tooltip: _isLiked ? 'Liked' : 'Like',
      onPressed: _toggle,
      icon: Icon(
        _isLiked ? Icons.favorite : Icons.favorite_border,
        color: _isLiked ? colorScheme.error : colorScheme.onSurfaceVariant,
      ),
    );
  }
}
