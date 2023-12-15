import 'package:flutter/material.dart';

class CounterTextField extends StatefulWidget {
  final String label;
  final double initialValue;
  final TextEditingController textEditingController;
  final String? errorText;

  const CounterTextField(
      {Key? key,
      required this.label,
      required this.initialValue,
      required this.textEditingController,
      required this.errorText})
      : super(key: key);

  @override
  CounterTextFieldState createState() => CounterTextFieldState();
}

class CounterTextFieldState extends State<CounterTextField> {
  double _counter = 0;

  @override
  void initState() {
    super.initState();
    _counter = widget.initialValue;
    widget.textEditingController.text = _counter.toStringAsFixed(2);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter += 0.25;
      widget.textEditingController.text = _counter.toStringAsFixed(2);
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter >= 0.25) {
        _counter -= 0.25;
        widget.textEditingController.text = _counter.toStringAsFixed(2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: _decrementCounter,
          child: const Icon(
            Icons.remove,
            size: 40,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextField(
              controller: widget.textEditingController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: widget.label,
                errorText: widget.errorText,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: _incrementCounter,
          child: const Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ],
    );
  }
}
