import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:vision/network_client.dart' as backend;
import 'dart:typed_data';

import 'package:vision/upload_files_data.dart';

uploadFiles(UploadFilesData data, List<MultipartFile> files) {
  FormData formData = FormData.fromMap({
    "title": data.title == "" ? " " : data.title,
    "description": data.description == "" ? " " : data.description,
    "files": files,
    "tag": data.tag == "" ? " " : data.tag,
    "compressed": data.compressed
  });
  backend.post(formData, '/images/');
}

uploadFilesDevice(UploadFilesData data, File filePath, String name) async {
  List<MultipartFile> toUploadFiles = [];
  toUploadFiles.add(await MultipartFile.fromFile(filePath.path, filename: name));
  uploadFiles(data, toUploadFiles);
}

/// converts bytes to MultipartFiles for upload
uploadFilesWeb(UploadFilesData data, List<PlatformFile> files) async {
  List<MultipartFile> toUploadFiles = [];
  for (var file in files) {
    toUploadFiles.add(MultipartFile.fromBytes(List<int>.from(file.bytes ?? []), filename: file.name));
    //print(file.name);
  }
  uploadFiles(data, toUploadFiles);
}