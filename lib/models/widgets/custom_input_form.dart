import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputText extends StatelessWidget {
  final ValueChanged<String> valueCallback;
  final String label;
  final String initialValue;
  final IconData icon;
  final bool showText;
  final TextInputType keyboardType;
  final FormFieldValidator<String> validator;
  final int maxLines;
  final inputFormatters;
  final enabled;
  final AutovalidateMode autovalidateMode;
  final Function onEditingComplete;

  const CustomInputText({
    Key key,
    @required this.valueCallback,
    @required this.label,
    @required this.icon,
    this.initialValue,
    this.showText = true,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.inputFormatters,
    this.enabled = true,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          autovalidateMode: autovalidateMode,
          enabled: enabled,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: valueCallback,
          cursorColor: Theme.of(context).primaryColor,
          style: Theme.of(context).textTheme.bodyText1,
          initialValue: initialValue,
          obscureText: !showText,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
