import 'dart:io';
import 'package:universal_html/html.dart' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:leanware_test/core/utils/app_colors.dart';
import 'package:leanware_test/core/utils/formats.dart';
import 'package:leanware_test/presentation/cubits/call_cubit/call_cubit.dart';
import 'package:leanware_test/presentation/cubits/timer_cubit/timer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaitingRoom extends StatefulWidget {
  const WaitingRoom({
    super.key,
  });

  @override
  State<WaitingRoom> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom> {
  @override
  void initState() {
    super.initState();
    // Agregar un estado a la historia del navegador
    if (kIsWeb) {
      html.window.history.pushState(null, '', '#');

      // Escuchar el evento popstate (botón atrás del navegador)
      html.window.onPopState.listen((event) {
        // Tu lógica aquí
        context.read<CallCubit>().clearRoom();

        if (context.mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) {
            return;
          }

          context.read<CallCubit>().clearRoom();

          Navigator.of(context).pop();
        },
        child: Scaffold(
          appBar: kIsWeb ? null : (Platform.isIOS ? AppBar() : null),
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
      ),
    );
  }
}
