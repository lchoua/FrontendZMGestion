import 'package:get_it/get_it.dart';
import 'package:zmgestion/src/services/NavigationService.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
}