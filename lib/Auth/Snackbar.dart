import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

void showSuccessSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: AwesomeSnackbarContent(
      title: 'Done!',
      message: message,
      contentType: ContentType.success,
    ),
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

void showErrorSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: AwesomeSnackbarContent(
      title: 'Error!',
      message: message,
      contentType: ContentType.failure,
    ),
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
