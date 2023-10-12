import 'package:cloud_firestore/cloud_firestore.dart';

class PasswordInfo {
  String title;
  String name;

  PasswordInfo(
    this.title,
    this.name,
  );

  // formatting for upload to Firbase when creating the trip
  Map<String, dynamic> toJson() => {
        'title': title,
        'name': name,
      };

  // creating a Trip object from a firebase snapshot
  PasswordInfo.fromSnapshot(DocumentSnapshot snapshot)
      : title = snapshot['title'],
        name = snapshot['name'];
}
