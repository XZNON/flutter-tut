import 'package:flutter/material.dart';

class NameInput extends StatefulWidget {
  final Function(String) onSubmit;

  const NameInput({super.key, required this.onSubmit});

  @override
  State<NameInput> createState() => _NameInputState();
}

class _NameInputState extends State<NameInput> {
  final TextEditingController controller = TextEditingController();

  void submit() {
    widget.onSubmit(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Enter name",
          ),
        ),

        const SizedBox(height: 15),

        ElevatedButton(onPressed: submit, child: const Text("Submit")),
      ],
    );
  }
}
