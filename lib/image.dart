import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vision/services/ui_helper.dart'
if (dart.library.io) 'package:vision/services/mobile_ui_helper.dart'
if (dart.library.html) 'package:vision/services/web_ui_helper.dart';
import 'package:vision/upload_files.dart' as image_upload_client;
import 'package:vision/upload_files_data.dart';


class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});
  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _imageFile;
  Uint8List? img;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 30,
    );
    final imagedata = await pickedFile?.readAsBytes();
    setState(() {
      _imageFile = File(pickedFile!.path);
      img = imagedata;
    });
  }

  Future<void> _cropImage() async {
    if (_imageFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: _imageFile!.path,
        uiSettings: buildUiSettings(context),
      );
      if (croppedFile != null) {
        setState(() {
          _imageFile = File(croppedFile.path);
        });
      }
    }
  }
  var idcard;

  @override
  Widget build(BuildContext context) {
    UploadFilesData upload;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56.h,
        backgroundColor: const Color(0Xff15609c),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 12.w,
            ),
            Text("Vision", style: TextStyle(fontSize: 21.sp)),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50.h),
            Text(
              "Capture Your Image",
              style: TextStyle(
                color: const Color(0Xff15609c),
                fontSize: 19.h,
              ),
            ),
            SizedBox(height: 30.h),
            SizedBox(
              height: 300.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: _imageFile != null
                    ? kIsWeb ? Image.memory(img!) : Image.file(_imageFile!)
                    : TextButton(
                  onPressed: pickImage,
                  child: Icon(
                    Icons.add_a_photo,
                    color: const Color(0Xff15609c),
                    size: 50.sp,
                    semanticLabel: "Take Picture",
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            Container(
              child: _imageFile != null
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Icon(
                      Icons.add_a_photo,
                      color: const Color(0Xff15609c),
                      size: 30.sp,
                    ),
                    onTap: () {
                      setState(() {
                        _imageFile = null;
                      });
                    },
                  ),
                  SizedBox(
                    width: 100.w,
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.edit,
                      color: const Color(0Xff15609c),
                      size: 30.sp,
                    ),
                    onTap: () {
                      _cropImage();
                    },
                  )
                ],
              )
                  : const Text(""),
            ),

            SizedBox(
              height: 60.h,
            ),
            //uploadImageButton(context),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: const EdgeInsets.all(12),
                    minimumSize: Size(MediaQuery.of(context).size.width,38.h),
                    alignment: Alignment.center,
                    backgroundColor: const Color(0xFF14619C)),
                onPressed: () async => {
                  if (_imageFile != null)
                    {
                      upload = UploadFilesData(title: "title", description: "description", tag: "tag", compressed: false),
                      image_upload_client.uploadFilesDevice(upload ,_imageFile!, "image")
                    }
                  else
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Image not selected')),
                      ),
                    }
                },
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget uploadImageButton(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding:
          const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
          margin: const EdgeInsets.only(
              top: 30, left: 20.0, right: 20.0, bottom: 20.0),
          child: ElevatedButton(
            onPressed: () {},
            child: const Text(
              "Upload Image",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
