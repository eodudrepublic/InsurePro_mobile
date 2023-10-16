import 'package:flutter/material.dart';
import 'app_color.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final IconData iconData;
  final String hintText;
  final ValueChanged<String>? onChanged; // 콜백을 추가합니다
  final FocusNode? focusNode;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.iconData = Icons.person_rounded,
    this.hintText = 'User Name',
    this.onChanged, // 콜백을 초기화합니다
    this.focusNode,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _isFocused = widget.controller.text.isNotEmpty; // controller의 값이 있으면 _isFocused를 true로 설정
    // 컨트롤러의 리스너를 추가하여 텍스트가 변경될 때마다 _isFocused를 업데이트
    widget.controller.addListener(() {
      setState(() {
        _isFocused = widget.controller.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: (text) {
        if (widget.onChanged != null) {
          widget.onChanged!(text); // 콜백을 호출합니다
        }
      },
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.iconData,
          color: _isFocused ? Colors.black : disabled_gray,
        ),
        hintText: widget.hintText,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _isFocused ? Colors.black : disabled_gray),
        ),
      ),
    );
  }
}

class CustomPwField extends StatefulWidget {
  final TextEditingController controller;
  final IconData iconData;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final bool isError;
  final String? errorMessage;

  const CustomPwField({super.key,
    required this.controller,
    this.iconData = Icons.lock_outlined,
    this.hintText = 'Hint',
    this.onChanged,
    this.isError = false,
    this.errorMessage = 'Error',
  });

  @override
  _CustomPwFieldState createState() => _CustomPwFieldState();
}

class _CustomPwFieldState extends State<CustomPwField> {
  bool _obscureText = true;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _isFocused = widget.controller.text.isNotEmpty; // controller의 값이 있으면 _isFocused를 true로 설정
    // 컨트롤러의 리스너를 추가하여 텍스트가 변경될 때마다 _isFocused를 업데이트
    widget.controller.addListener(() {
      setState(() {
        _isFocused = widget.controller.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: (text) {
        if (widget.onChanged != null) {
          widget.onChanged!(text); // 콜백을 호출합니다
        }
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.iconData,
          color: _isFocused ? Colors.black : disabled_gray,
        ),
        hintText: widget.hintText,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _isFocused ? Colors.black : disabled_gray),
        ),
        errorText: widget.isError ? widget.errorMessage : null,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: _isFocused ? Colors.black : disabled_gray,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      obscureText: _obscureText,
    );
  }
}

