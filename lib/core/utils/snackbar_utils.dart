import 'package:flutter/material.dart';

class SnackBarUtils {
  static void showTimeoutSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.timer_off, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: const Text(
                'Han pasado 10 minutos sin interacción por lo que hemos finalizado la llamada',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
