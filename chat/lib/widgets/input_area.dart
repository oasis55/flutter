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
  bool _isLoading = false;
  double _turns = 0;

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
            onPressed: () {
              setState(() {
                _turns += 1;
                _isLoading = true;
              });
              widget.onPressed?.call();
            },
            icon: AnimatedRotation(
              key: const ValueKey('button'),
              duration: const Duration(seconds: 1),
              onEnd: () {
                setState(() {
                  _isLoading = false;
                });
              },
              turns: _turns,
              child: _isLoading
                  ? const Icon(key: ValueKey('one'), Icons.refresh)
                  : const Icon(key: ValueKey('two'), Icons.send),
            ),
          ),
        ],
      ),
    );
  }
}
