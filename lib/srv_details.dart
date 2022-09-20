import 'package:firebase_database/firebase_database.dart';

class SrvDet {
  String? key;
  String servDate;
  String clientName;
  String location;
  String fault;
  String fix;
  // ignore: non_constant_identifier_names
  String job_status;

  SrvDet(this.key, this.servDate, this.clientName, this.location, this.fault,
      this.fix, this.job_status);

  SrvDet.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        servDate = snapshot.value['servDate'],
        clientName = snapshot.value['clientName'],
        location = snapshot.value['location'],
        fault = snapshot.value['fault'],
        fix = snapshot.value['fix'],
        job_status = snapshot.value['job_status'];

  // ignore: non_consant_identifier_names
  toJson() {
    return {
      'servDate': servDate,
      'clientName': clientName,
      'location': location,
      'fault': fault,
      'fix': fix,
      'job_status': job_status,
    };
  }
}
