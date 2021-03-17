import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_tool_sample/data/data.dart';
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
  UserItem _userItem;
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _uploadImageSize = 60;
  File _image;
  bool _imageUploading = false;
  RequestNotifier _auth;
  String _profileImage = "";

  @override
  void initState() {
    super.initState();
    _profileImage = preferences.getString(SharedPreference.PROFILE_IMAGE);
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<RequestNotifier>(context);
    _userItem = ModalRoute.of(context).settings.arguments;

    _userNameController.text = _userItem.username;
    _emailController.text = _userItem.email;
    _addressController.text = _userItem.address;

    _overLapPaddingWidget() {
      return Container(
        height: ((mediaQueryH(context) * UserProfile.userProfileSizeH) / 2) +
            (_uploadImageSize / 2) -
            (Platform.isIOS ? -8 : 4),
        width: mediaQueryW(context) * UserProfile.userProfileSizeW,
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Edit Profile"),
        backgroundColor: secondaryColor,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                          width: mediaQueryW(context) *
                              UserProfile.userProfileSizeW,
                          height: mediaQueryH(context) *
                              UserProfile.userProfileSizeH,
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
                                imageFile: _image,
                                imageUrl: _profileImage,
                                placeHolderImage: placeHolderImage,
                                isUserProfile: true,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            _overLapPaddingWidget(),
                            Material(
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.transparent,
                              child: InkResponse(
                                child: Image.asset(
                                  uploadImage,
                                  width: _uploadImageSize,
                                  height: _uploadImageSize,
                                ),
                                onTap: () {
                                  _openImageChooser();
                                },
                              ),
                            ),
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
                    ContainerRaisedButton(
                      text: "UPDATE PROFILE",
                      formKey: _formKey,
                    ),
                    15.addHSpace(),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            child: loaderWidget(context),
            visible: _imageUploading,
          )
        ],
      ),
    );
  }

  void _openImageChooser() {
    Platform.isIOS
        ? showModalBottomSheet(
            context: context,
            builder: (context) {
              return SafeArea(
                child: Container(
                  child: Wrap(
                    children: [
                      ListTile(
                        title: Text("Gallery"),
                        leading: Icon(Icons.photo_library),
                        onTap: () {
                          _imageFormGallery();
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text("Camera"),
                        leading: Icon(Icons.photo_camera),
                        onTap: () {
                          _imageFromCamera();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Text("Select Image"),
                children: [
                  ListTile(
                    title: Text("Photo Library"),
                    leading: Icon(Icons.photo_library),
                    onTap: () {
                      _imageFormGallery();
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text("Camera"),
                    leading: Icon(Icons.photo_camera),
                    onTap: () {
                      _imageFromCamera();
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
  }

  void _imageFormGallery() async {
    if (await Permission.storage.request().isGranted) {
      final pickedFile = await ImagePicker()
          .getImage(source: ImageSource.gallery, imageQuality: 100);
      if (pickedFile != null) {
        _uploadImage(pickedFile);
        print(pickedFile.path);
      }
      return;
    } else if (await Permission.storage.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Without this permission app can not change profile picture."),
        ),
      );
      return;
    } else if (await Permission.storage.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "To access this feature please grant permission from settings."),
          action: SnackBarAction(
            label: "Settings",
            textColor: secondaryColor,
            onPressed: openAppSettings,
          ),
        ),
      );
      return;
    }
  }

  void _imageFromCamera() async {
    if (await Permission.camera.request().isGranted) {
      final pickedFile = await ImagePicker()
          .getImage(source: ImageSource.camera, imageQuality: 100);
      if (pickedFile != null) {
        _uploadImage(pickedFile);
        print(pickedFile.path);
      }
    } else if (await Permission.camera.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Without this permission app can not change profile picture."),
          action: Platform.isIOS
              ? SnackBarAction(
                  label: "Settings",
                  textColor: secondaryColor,
                  onPressed: openAppSettings,
                )
              : null,
        ),
      );
      return;
    } else if (await Permission.camera.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "To access this feature please grant permission from settings."),
          action: SnackBarAction(
            label: "Settings",
            textColor: secondaryColor,
            onPressed: openAppSettings,
          ),
        ),
      );
      return;
    }
  }

  void _uploadImage(PickedFile pickedFile) async {
    setState(() {
      _imageUploading = true;
    });
    _auth.uploadImage(_userItem, File(pickedFile.path)).then((response) {
      _image = null;
      setState(() {
        _imageUploading = false;
        if (response["status"]) {
          _userItem = UserItem.fromJson(response["data"]);
          preferences.saveUser(_userItem);
          _profileImage = _userItem.profileImage;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response["message"]),
      ));
    });
  }
}
