import 'package:emergency/store/emergency_provider.dart';
import 'package:emergency/store/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider(create: (_) => UserProvider()),
  ChangeNotifierProvider(create: (_) => EmergencyProvider()),
];
