import 'dart:convert';

//import 'package:flutter_contact/models/base_model.dart';

List<Contact> contactFromJson(String str) =>
    List<Contact>.from(json.decode(str).map((x) => Contact.fromJson(x)));

//Contact contactFromJson(String str) => Contact.fromJson(json.decode(str));

String contactToJson(Contact data) => json.encode(data.toJson());

class Contact {
  int contactId;
  String name;
  String image;
  int isFavorite;
  int mobileNumber;
  int landLine;
  int blocked;

  Contact(
      {this.contactId,
      this.name,
      this.image,
      this.isFavorite,
      this.mobileNumber,
      this.blocked,
      this.landLine});

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        contactId: json["contactId"],
        name: json["name"],
        image: json["image"],
        isFavorite: json["isFavorite"],
        mobileNumber: json["mobileNumber"],
        blocked: json["blocked"],
        landLine: json["landLine"],
      );

  Map<String, dynamic> toJson() => {
        "contactId": contactId,
        "name": name,
        "image": image,
        "isFavorite": isFavorite,
        "mobileNumber": mobileNumber,
        "blocked": blocked,
        "landLine": landLine,
      };
}
