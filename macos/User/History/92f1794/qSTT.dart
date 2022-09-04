import 'package:bonemeal/bonemeal.dart';

import 'consultations/consultations.dart';
import 'doctors.dart';
import 'establishment.dart';
import 'providers/provider_specialty.dart';
import 'records/records.dart';

final models = Root('packages/models/lib/src/', [
  doctors,
  establishment,
  // providers,
  consultations,
  records,
]);