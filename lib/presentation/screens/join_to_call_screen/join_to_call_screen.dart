import 'package:leanware_test/core/utils/app_colors.dart';
import 'package:leanware_test/core/utils/constants.dart';
import 'package:leanware_test/presentation/cubits/call_cubit/call_cubit.dart';
import 'package:leanware_test/presentation/screens/auth/widgets/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinToCallScreen extends StatefulWidget {
  final String? userName;
  final VoidCallback? onJoinMeeting;

  const JoinToCallScreen({
    Key? key,
    this.userName,
    this.onJoinMeeting,
  }) : super(key: key);

  @override
  _JoinToCallScreenState createState() => _JoinToCallScreenState();
}

class _JoinToCallScreenState extends State<JoinToCallScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CallCubit>().getUserName(AppConstants.userName);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CallCubit, CallState>(
      listener: (context, state) {
        if (state is AskForUserName) {
          _showUsernameDialog(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Image.asset('assets/leanware_io_logo.jpg')),
            const SizedBox(
              height: 15,
            ),
            BlocBuilder<CallCubit, CallState>(
              builder: (context, state) {
                if (state is UserNameLoaded) {
                  return Text(
                    "Welcome ${state.userName}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 15),
              child: ElevatedButton(
                key: Key('join-call-button'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  context.push('/call');
                  // final prefs = await SharedPreferences.getInstance();
                  // await prefs.clear();
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.video_call,
                        color: AppColors.secondaryBackground),
                    SizedBox(width: 8),
                    Text(
                      'Join Call',
                      style: TextStyle(
                        color: AppColors.secondaryBackground,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUsernameDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          key: Key('popup-username-field'),
          canPop: false,
          child: AlertDialog(
            backgroundColor: AppColors.secondaryBackground,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 20), // Reduce padding
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text("Please enter your username to continue"),
            titleTextStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            content: AppTextFormField(
              controller: controller,
              labelText: 'Username',
            ),
            actions: [
              TextButton(
                key: Key('popup-save-button'),
                onPressed: () async {
                  if (controller.text.isNotEmpty) {
                    context.read<CallCubit>().saveUserName(controller.text);
                    await context.read<CallCubit>().getUserId();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  "Save",
                  style: TextStyle(color: AppColors.background),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
