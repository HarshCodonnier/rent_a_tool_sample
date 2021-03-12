import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rent_a_tool_sample/widgets/widgets.dart';

import '../data/data.dart';
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

  @override
  Widget build(BuildContext context) {
    final UserItem userItem = ModalRoute.of(context).settings.arguments;

    _userNameController.text = userItem.username;
    _emailController.text = userItem.email;
    _addressController.text = userItem.address;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Edit Profile"),
        backgroundColor: secondaryColor,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                30.addHSpace(),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: mediaQueryW(context) * UserProfile.userProfileSizeW,
                      height: mediaQueryH(context) * UserProfile.userProfileSizeH,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: secondaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    Container(
                      width: mediaQueryW(context) * UserProfile.userProfileSizeW,
                      height: mediaQueryH(context) * UserProfile.userProfileSizeH,
                      padding: EdgeInsets.all(5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: userItem.profileImage == null ||
                                userItem.profileImage.isEmpty
                            ? Image.asset(
                                placeHolderImage,
                                fit: BoxFit.cover,
                              )
                            : FadeInImage.assetNetwork(
                                placeholder: placeHolderImage,
                                image:
                                    "${AppUrls.IMAGE_BASE_URL}${userItem.profileImage}",
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Positioned(
                      top: mediaQueryH(context) * 0.12,
                      left: mediaQueryW(context) * 0.09,
                      child: Container(
                        child: Image.asset(uploadImage),
                      ),
                    ),
                  ],
                ),
                60.addHSpace(),
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
                      if(_formKey.currentState.validate()){
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
