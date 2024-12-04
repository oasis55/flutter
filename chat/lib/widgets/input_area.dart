import 'package:flutter/material.dart';

class InputArea extends StatefulWidget {
  const InputArea({
    super.key,
    required this.onPressed,
    required this.controller
  });

  final VoidCallback? onPressed;
  final TextEditingController controller;

  @override
  State<StatefulWidget> createState() => _InputAreaState();
}

class _InputAreaState extends State<InputArea> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Row(
        children: [
          Expanded(
            child: BottomAppBar(
              child: TextField(
                controller: widget.controller,
                decoration: const InputDecoration(labelText: 'Message'),
              ),
            ),
          ),
          IconButton(
            onPressed: widget.onPressed,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
