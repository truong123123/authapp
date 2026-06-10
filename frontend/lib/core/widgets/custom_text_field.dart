import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint = '',
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final scale = (MediaQuery.of(context).size.width / 375).clamp(0.5, 1.5);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4 * scale),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0D000000),
            blurRadius: 8 * scale,
            offset: Offset(0, 1 * scale),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        style: GoogleFonts.inter(
          fontSize: 14 * scale,
          color: const Color(0xFF2D2D2D),
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: GoogleFonts.inter(
            fontSize: 14 * scale,
            color: const Color(0xFF9B9B9B),
          ),
          floatingLabelStyle: GoogleFonts.inter(
            fontSize: 11 * scale,
            color: const Color(0xFF9B9B9B),
          ),
          hintStyle: GoogleFonts.inter(
            fontSize: 14 * scale,
            color: const Color(0xFF2D2D2D),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          contentPadding: EdgeInsets.symmetric(
              horizontal: 20 * scale, vertical: 21 * scale),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4 * scale),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4 * scale),
            borderSide: BorderSide(color: const Color(0xFFE0E0E0), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4 * scale),
            borderSide: BorderSide(color: const Color(0xFFDB3022), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4 * scale),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4 * scale),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
