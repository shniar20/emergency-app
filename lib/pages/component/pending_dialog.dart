import 'package:flutter/material.dart';

class PendingDialog extends StatefulWidget {
  const PendingDialog({super.key});

  @override
  State<PendingDialog> createState() => _PendingDialogState();
}

class _PendingDialogState extends State<PendingDialog> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text(
          'تکایە چاوەڕوان بە',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'rabar',
            color: Colors.black,
          ),
        ),
        content: const Text(
          'تکایە چاوەڕوان بە تا فریاکەوتنەکەی پێشووت وەڵام دەدرێتەوە',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'rabar',
            color: Colors.black,
          ),
        ),
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
