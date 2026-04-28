import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ticket_track/features/auth/presentation/screens/sign_up_screen.dart';

import 'config/App.dart';


void main() {
  runApp(const ProviderScope(child: MyApp()));
}

