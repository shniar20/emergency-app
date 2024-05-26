import 'package:emergency/store/user_provider.dart';
import 'package:flutter/material.dart';

class AnsweredDialog extends StatefulWidget {
  final UserProvider userProvider;
  final bool approved;
  const AnsweredDialog({
    super.key,
    required this.userProvider,
    required this.approved,
  });

  @override
  State<AnsweredDialog> createState() => _AnsweredDialogState();
}

class _AnsweredDialogState extends State<AnsweredDialog> {
  @override
  void dispose() {
    super.dispose();
    widget.userProvider.answeredDialogClosed(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text(
          widget.approved
              ? 'فریاکەوتنەکەت وەڵام درایەوە'
              : 'ببورە، فریاکەوتنەکەت ڕەت کرایەوە',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'rabar',
            color: Colors.black,
          ),
        ),
        // content: const Text(
        //   'ت',
        //   style: TextStyle(
        //     fontFamily: 'rabar',
        //     color: Colors.black,
        //   ),
        // ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22427f),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'باشە',
              style: TextStyle(
                fontFamily: 'rabar',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
