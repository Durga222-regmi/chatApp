import 'package:flutter/material.dart';

import '../../../../app_constant.dart';

class SearchField extends StatefulWidget {
  TextEditingController textEditingController;
  FocusNode focusNode;
  String? hintText;

  SearchField(
      {Key? key,
      required this.textEditingController,
      required this.focusNode,
      this.hintText})
      : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  static const double BORDER_RADIUS = 20;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Center(
        child: TextFormField(
          focusNode: widget.focusNode,
          style: const TextStyle(fontSize: 14),
          controller: widget.textEditingController,
          cursorColor: AppConstant.PRIMARY_COLOR,
          decoration: InputDecoration(
              hintText: widget.hintText ?? "Search for the user",
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(BORDER_RADIUS),
                  borderSide: const BorderSide(
                      width: 0.5, color: AppConstant.PRIMARY_COLOR)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(BORDER_RADIUS),
                  borderSide: const BorderSide(
                      width: 0.5, color: AppConstant.BORDER_COLOR)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(BORDER_RADIUS),
                  borderSide: const BorderSide(
                      width: 0.5, color: AppConstant.PRIMARY_COLOR)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(BORDER_RADIUS),
                  borderSide: const BorderSide(
                      width: 0.5, color: AppConstant.PRIMARY_COLOR)),
              suffixIcon: GestureDetector(
                  onTap: () {
                    if (widget.focusNode.hasPrimaryFocus) {
                      setState(() {
                        widget.focusNode.unfocus();
                      });
                    } else {}

                    widget.textEditingController.clear();
                  },
                  child: Icon(
                    widget.focusNode.hasPrimaryFocus
                        ? Icons.close_outlined
                        : Icons.search_outlined,
                    size: 16,
                    color: AppConstant.PRIMARY_COLOR,
                  ))),
        ),
      ),
    );
  }
}
