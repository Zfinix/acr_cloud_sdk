import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'viewmodel/home_vm.dart';

final homeVM = ChangeNotifierProvider((_) => HomeViewModel());
