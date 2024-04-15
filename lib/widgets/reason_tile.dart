import 'package:flutter/material.dart';
import '../models/reason_model.dart';

class ReasonTile extends StatelessWidget {
  final ReasonModel reason;
  final VoidCallback onSelect;

  const ReasonTile({super.key, required this.reason, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(reason.description),
      onTap: onSelect,
    );
  }
}
