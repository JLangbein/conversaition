import 'package:flutter/material.dart';

class RestartWarningDialog extends StatelessWidget {
  const RestartWarningDialog({super.key, required this.restart});

  final VoidCallback restart;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        spacing: 8.0,
        children: [
          Icon(
            Icons.warning_rounded,
            size: 48.0,
            color: Theme.of(context).colorScheme.error,
          ),
          Text('Warning'),
        ],
      ),

      content: Text(
        'Restarting will completely delete your current conversation',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      actions: [
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          onPressed: Navigator.of(context).pop,
          child: Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
          ),
          onPressed: restart,
          child: Text('Restart'),
        ),
      ],
    );
  }
}
