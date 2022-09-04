import 'package:bonemeal/bonemeal.dart';
import 'package:model_generators/model_generators.dart';

final doctorSpecialty = JsonSerializable('DoctorSpecialty', {
  field('id', refer('String')),
  jsonField('displayFr', refer('String'), name: 'libelleFR'),
});

final doctorJob = JsonSerializable('DoctorJob', {
  field('id', refer('String')),
  jsonField('displayFr', refer('String'), name: 'libelleFR'),
});

final doctor = JsonSerializable('Doctor', {
  refer('String').toField('job'),
  jsonField(
    'id',
    refer('String'),
    name: 'numeroCompteUtilisateur',
  ),
  jsonField(
    'firstName',
    refer('String'),
    name: 'prenomUtilisateur',
  ),
  jsonField(
    'lastName',
    refer('String'),
    name: 'nomUtilisateur',
  ),
  jsonField(
    'job',
    refer('DoctorJob', 'doctor_job.dart'),
    name: 'PrestataireProfession',
  ),
  jsonField(
    'specialty',
    refer('DoctorSpecialty', 'doctor_specialty.dart'),
    name: 'PrestataireSpecialite',
  ),
});

final networkDoctor = JsonSerializable('NetworkDoctor', {'j'});

final doctors = Root('doctor/', [
  doctorSpecialty,
  doctorJob,
  doctor,
]);