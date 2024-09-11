import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormController extends GetxController {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var hasError = false.obs;

  void validate() {
    if (formKey.currentState?.validate() ?? false) {
      hasError.value = false;
    } else {
      hasError.value = true;
    }
  }
  void clearEmail() {
    emailController.clear();
    validate(); // Validate after clearing the email
  }
}
