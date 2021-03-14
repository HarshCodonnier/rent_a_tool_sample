import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rent_a_tool_sample/widgets/widgets.dart';

import '../extras/extras.dart';
import '../models/user_item.dart';

class UserProfile extends StatefulWidget {
  static const userProfileSizeH = 0.15;
  static const userProfileSizeW = 0.3;

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _uploadImageSize = 60;

  @override
  Widget build(BuildContext context) {
    final UserItem userItem = ModalRoute.of(context).settings.arguments;

    _userNameController.text = userItem.username;
    _emailController.text = userItem.email;
    _addressController.text = userItem.address;

    _overLapPaddingWidget() {
      return Container(
        height: ((mediaQueryH(context) * UserProfile.userProfileSizeH) / 2) +
            (_uploadImageSize / 2) -
            4,
        width: mediaQueryW(context) * UserProfile.userProfileSizeW,
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Edit Profile"),
        backgroundColor: secondaryColor,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                30.addHSpace(),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width:
                          mediaQueryW(context) * UserProfile.userProfileSizeW,
                      // 120,
                      height:
                          mediaQueryH(context) * UserProfile.userProfileSizeH,
                      // 120,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: secondaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ImageWidget(
                            imageUrl: userItem.profileImage,
                            placeHolderImage: placeHolderImage,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        _overLapPaddingWidget(),
                        Image.asset(
                          uploadImage,
                          width: _uploadImageSize,
                          height: _uploadImageSize,
                        )
                      ],
                    )
                  ],
                ),
                20.addHSpace(),
                Container(
                  width: double.infinity,
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "Username".labelText(),
                        10.addHSpace(),
                        EditProfileTextField(
                          hintText: "UserName",
                          controller: _userNameController,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Please enter username.";
                            }
                            return null;
                          },
                        ),
                        15.addHSpace(),
                        "Email".labelText(),
                        10.addHSpace(),
                        EditProfileTextField(
                          hintText: "Email",
                          controller: _emailController,
                          textInputType: TextInputType.emailAddress,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Please enter email.";
                            } else {
                              if (!value.isValidEmail()) {
                                return "Please enter valid email.";
                              }
                            }
                            return null;
                          },
                        ),
                        15.addHSpace(),
                        "Address".labelText(),
                        10.addHSpace(),
                        EditProfileTextField(
                          hintText: "Address",
                          controller: _addressController,
                          maxLines: 3,
                          vContentPadding: 10.toDouble(),
                        ),
                      ],
                    ),
                  ),
                ),
                50.addHSpace(),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: secondaryColor,
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        print("Update");
                      } else {
                        print("Update");
                      }
                    },
                    child: Container(
                      child: Text(
                        "UPDATE PROFILE",
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
                15.addHSpace(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
