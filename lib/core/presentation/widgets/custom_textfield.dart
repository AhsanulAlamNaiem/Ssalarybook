import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget{
  final String label;
  final Function updater;
  final Icon? icon;

  const CustomTextField({
    required this.label,
    required this.updater,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextFormField(
      keyboardType: label.contains("email")?
      TextInputType.emailAddress
          :label.contains('phone')?
      TextInputType.phone
        :TextInputType.text,
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: icon,
          border: OutlineInputBorder(),
          labelText: label,
        ),
        onChanged: (value) => updater(value)
    );
  }
}



class PassWordTextField extends StatefulWidget {
  final String? label;
  final Function updater;

  const PassWordTextField({super.key, this.label, required this.updater});

  @override
  _PassWordTextFieldState createState() => _PassWordTextFieldState();
}

class _PassWordTextFieldState extends State<PassWordTextField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final label = widget.label?? "Password";
    return TextFormField(
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword; // Toggle password visibility
            });
          },
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
        ),
        hintText: 'Enter $label', // Dynamically uses label text
        border: const OutlineInputBorder(),
        labelText: label, // Sets the label dynamically
      ),
      onChanged: (value) =>widget.updater(value),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '${widget.label} should not be empty'; // Validation message
        }
        return null; // No validation error
      },
    );
  }
}