import 'package:flutter/material.dart';
import 'package:flutter_developer_assessment/utils/custom_colloer.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.validator,
    required this.errorText,
    this.obscureText = false,
    this.onTap,
    this.suffixText = 'Show'
  });

  final String hintText;
  final String errorText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? Function()? onTap;
  bool obscureText;
  String suffixText;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showErrorMessage = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: widget.validator,
        // onChanged: (value) {
        //   if (value.isNotEmpty) {
        //     setState(() {
        //       widget.controller.text = value;
        //     });
        //   }
        // },
        obscureText: widget.obscureText,
        controller: widget.controller,
        cursorColor: CustomColor().customBalck,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          filled: true,
          fillColor: CustomColor().lightGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          errorText: widget.errorText,
          hintText: widget.hintText,
          suffixStyle: TextStyle(color: CustomColor().customGreen),
          suffix: GestureDetector(
            onTap: widget.onTap,
            child: Text(widget.suffixText.toString()),
          ),
        ));
  }
}
