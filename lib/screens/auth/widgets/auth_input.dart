import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_theme.dart';

class AuthInput extends StatefulWidget {
  final String text;
  final String? validationError;
  final String? serverError;
  final TextEditingController textController;
  final bool isPass;

  const AuthInput({
    super.key,
    required this.textController,
    required this.text,
    this.validationError,
    this.serverError,
    this.isPass = false,
  });

  @override
  State<AuthInput> createState() => _AuthInputState();
}

class _AuthInputState extends State<AuthInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: AppColors.secondary, fontWeight: FontWeight.w500),
            ),
            TextField(
              controller: widget.textController,
              obscureText: widget.isPass,
              style: const TextStyle(color: AppColors.black),
              decoration: InputDecoration(
                fillColor: Theme.of(context).colorScheme.background,
                filled: true,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 0.8,
          color: AppColors.secondary,
        ),
        const SizedBox(height: 8),
        widget.validationError != null || widget.serverError != null
            ? Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.validationError ?? widget.serverError ?? "",
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
              )
            : Container(),
      ],
    );
  }
}
