import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'app.dart';
import 'core/core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory.web,
  );

  await setupDependencies();

  await preloadSVGs([
    'assets/svgs/github.svg',
    'assets/svgs/yin-yang.svg',
  ]);

  runApp(const MainApp());
}
