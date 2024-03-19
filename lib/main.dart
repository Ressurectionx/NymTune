import 'package:flutter/material.dart';
import 'package:nymtune/src/bloc/presentation/views/home_view.dart';

void main() {
  runApp(const NymTune());
}

class NymTune extends StatelessWidget {
  const NymTune({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeView());
  }
}
