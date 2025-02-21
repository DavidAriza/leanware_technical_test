import 'package:leanware_test/core/utils/app_colors.dart';
import 'package:leanware_test/core/utils/formats.dart';
import 'package:leanware_test/presentation/cubits/timer_cubit/timer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaitingRoom extends StatelessWidget {
  const WaitingRoom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Barra superior

            // Vista previa de la cámara
            Expanded(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[900],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: const Center(
                      child: Icon(
                        Icons.video_call,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Nombre del usuario
            const Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Waiting room',
                style: const TextStyle(
                  color: AppColors.secondaryBackground,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: BlocBuilder<TimerCubit, TimerState>(
                builder: (context, state) {
                  if (state is TimerRunning) {
                    return Text(
                      formatTimeFromSeconds(state.timeLeft),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
