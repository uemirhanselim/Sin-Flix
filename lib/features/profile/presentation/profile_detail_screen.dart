import 'dart:io';
import 'package:dating_app/core/themes/app_theme.dart';
import 'package:dating_app/features/user/domain/usecases/upload_user_photo.dart';
import 'package:dating_app/shared/widgets/lottie_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/locator.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../user/presentation/bloc/user_bloc.dart';
import '../../user/presentation/bloc/user_event.dart';
import '../../user/presentation/bloc/user_state.dart';
import 'bloc/profile_detail_bloc.dart';
import 'bloc/profile_detail_event.dart';
import 'bloc/profile_detail_state.dart';

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => ProfileDetailBloc(
                uploadUserPhoto: locator<UploadUserPhoto>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => UserBloc(
                uploadUserPhoto: locator(),
                logger: locator(),
                getUserProfile: locator(),
              ),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder:
                      (_) => Center(
                        child: LottieAnimation(
                          "assets/lottie/loading.json",
                          width: 70.w,
                          height: 70.h,
                        ),
                      ),
                );
              } else if (state is UserPhotoUploaded) {
                Navigator.of(context).pop(); // Pop the loading dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(tr('photoUploadedSuccessfully'))),
                );
                context.go('/home'); // Navigate to home screen
              } else if (state is UserError) {
                Navigator.of(context).pop(); // Pop the loading dialog
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
                context.pop(); // Pop the current screen (ProfileDetailScreen)
              }
            },
          ),
          BlocListener<ProfileDetailBloc, ProfileDetailState>(
            listener: (context, state) {
              if (state is ProfileDetailUploadRequested) {
                if (state.profileImage != null) {
                  context.read<UserBloc>().add(
                    UploadUserPhotoEvent(photo: state.profileImage!),
                  );
                }
              }
            },
          ),
        ],
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2a2a2a),
                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  ),
                  child: Image.asset("assets/icons/back_arrow.png"),
                ),
              ),
            ),
            title: Text(tr('profileDetail'), style: textTheme.titleLarge),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Builder(
              builder: (innerContext) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      tr('uploadYourPhoto'),
                      textAlign: TextAlign.center,
                      style: textTheme.headlineMedium,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      tr('uploadPhotoInfo'),
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium!.copyWith(
                        color: AppColors.text,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    BlocBuilder<ProfileDetailBloc, ProfileDetailState>(
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () async {
                            final ImagePicker _picker = ImagePicker();
                            final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (image != null) {
                              innerContext.read<ProfileDetailBloc>().add(
                                ProfileImagePicked(File(image.path)),
                              );
                            }
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 164.h,
                              width: 180.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2a2a2a),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18),
                                ),
                                image:
                                    state.profileImage != null
                                        ? DecorationImage(
                                          image: FileImage(state.profileImage!),
                                          fit: BoxFit.cover,
                                        )
                                        : null,
                              ),
                              child:
                                  state.profileImage == null
                                      ? Image.asset("assets/icons/plus.png")
                                      : null,
                            ),
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    PrimaryButton(
                      text: tr('continueButton'),
                      onPressed:
                          () => innerContext.read<ProfileDetailBloc>().add(
                            ContinuePressed(),
                          ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
