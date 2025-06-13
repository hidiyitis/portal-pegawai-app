import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portal_pegawai_app/data/models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> uploadAvatar(XFile file);

  // ✅ Tambahkan ini:
  Future<List<UserModel>> getAllUsers();
  Future<List<UserModel>> getUsers();
}
