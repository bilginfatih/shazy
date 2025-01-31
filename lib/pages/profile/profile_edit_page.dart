import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shazy/models/user/user_model.dart';
import 'package:shazy/models/user/user_profile_model.dart';
import 'package:shazy/pages/profile/controller/profile_controller.dart';
import 'package:shazy/utils/extensions/context_extension.dart';
import 'package:shazy/widgets/app_bars/back_app_bar.dart';
import 'package:shazy/widgets/buttons/primary_button.dart';
import 'package:shazy/widgets/buttons/secondary_button.dart';
import 'package:shazy/widgets/textfields/email_text_form_field.dart';
import 'package:shazy/widgets/textfields/name_text_from_field.dart';

import '../../core/init/navigation/navigation_manager.dart';
import '../../utils/constants/app_constant.dart';
import '../../utils/helper/helper_functions.dart';
import '../../widgets/padding/base_padding.dart';
import 'package:image/image.dart' as img;

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final TextEditingController _aboutYouTextController = TextEditingController();
  final ProfileController _controller = ProfileController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _nameTextController = TextEditingController();
  final _picker = ImagePicker();
  final TextEditingController _surnameTextController = TextEditingController();
  String _imagePath = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.userProfile =
          ModalRoute.of(context)?.settings.arguments as UserProfileModel;
      setState(() {});
    });
    super.initState();
  }

  Future<void> _addImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        Uint8List imageBytes = await imageFile.readAsBytes();
        img.Image? image = img.decodeImage(imageBytes);
        if (image != null) {
          img.Image resizedImage = img.copyResize(image, width: 400);
          Uint8List resizedImageBytes = Uint8List.fromList(
            img.encodeJpg(resizedImage, quality: 75),
          );
          String base64String = base64Encode(resizedImageBytes);
          log('Base64 String Length: ${base64String.length}');
          log('Base64 String: $base64String');
          setState(() {
            _imagePath = base64String;
          });
        }
      }
    } catch (e) {
      if (context.mounted) {
        HelperFunctions.instance
            .showErrorDialog(context, 'addImageError'.tr(), 'cancel'.tr(), () {
          NavigationManager.instance.navigationToPop();
        });
      }
    }
  }

  SingleChildScrollView _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: BasePadding(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: context.responsiveHeight(30),
            ),
            _buildPhoto(context),
            _buildName(context),
            _buildSurname(context),
            _buildEmail(context),
            _buildAboutYou(context),
            SizedBox(
              height:
                  context.responsiveHeight(context.height < 620 ? 130 : 207),
            ),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Padding _buildSurname(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.responsiveHeight(20),
      ),
      child: NameTextFormField(
        hintText: _controller.userProfile?.userModel != null
            ? _controller.userProfile?.userModel!.surname
            : 'surname'.tr(),
        context: context,
        controller: _surnameTextController,
      ),
    );
  }

  GestureDetector _buildPhoto(BuildContext context) {
    return GestureDetector(
      onTap: _addImage,
      child: Center(
        child: Stack(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              child: _buildImage(_imagePath),
            ),
            Positioned(
              left: 50,
              bottom: 0,
              child: SvgPicture.asset(
                'assets/svg/camera-2.svg',
                width: context.responsiveWidth(20),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding _buildName(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.responsiveHeight(47),
      ),
      child: NameTextFormField(
        hintText: _controller.userProfile?.userModel != null
            ? _controller.userProfile?.userModel!.name
            : 'name'.tr(),
        context: context,
        controller: _nameTextController,
      ),
    );
  }

  Padding _buildEmail(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.responsiveHeight(20),
      ),
      child: EmailTextFormField(
        text: _controller.userProfile?.userModel != null
            ? '${_controller.userProfile?.userModel!.email}'
            : 'Email'.tr(),
        context: context,
        controller: _emailTextController,
      ),
    );
  }

  Padding _buildAboutYou(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.responsiveHeight(20),
      ),
      child: NameTextFormField(
        hintText: _controller.userProfile?.description != ''
            ? '${_controller.userProfile?.description}'
            : 'aboutYou'.tr(),
        context: context,
        controller: _aboutYouTextController,
      ),
    );
  }

  Row _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SecondaryButton(
          width: 174,
          text: 'cancel'.tr(),
          context: context,
          onPressed: _controller.goToBackPage,
        ),
        PrimaryButton(
          width: 174,
          text: 'save'.tr(),
          context: context,
          onPressed: _onPressed,
        ),
      ],
    );
  }

  void _onPressed() {
    String? name = _nameTextController.text == ''
        ? _controller.userProfile?.userModel!.name
        : _nameTextController.text;
    String? surname = _surnameTextController.text == ''
        ? _controller.userProfile?.userModel!.surname
        : _surnameTextController.text;
    String? email = _emailTextController.text == ''
        ? _controller.userProfile?.userModel!.email
        : _emailTextController.text;
    String? description = _aboutYouTextController.text == ''
        ? _controller.description
        : _aboutYouTextController.text;
    UserProfileModel model = UserProfileModel(
      description: description,
      profilePicturePath: _imagePath,
      userModel: UserModel(
        name: name,
        surname: surname,
        email: email,
      ),
    );
    _controller.updateUserProfile(context, model);
  }

  ClipOval _buildImage(String? path) {
    return ClipOval(
      child: path != null && path != ''
          ? Image.memory(
              base64Decode(path),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, exception, stackTrack) => Image.asset(
                'assets/png/no_data.png',
              ),
            )
          : Image.network(
              _controller.userProfile?.profilePicturePath ?? '',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, exception, stackTrack) => Image.asset(
                'assets/png/no_data.png',
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        context: context,
        mainTitle: 'profile'.tr(),
      ),
      body: _buildBody(context),
    );
  }
}
