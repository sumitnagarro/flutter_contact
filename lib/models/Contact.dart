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
  String mobileNumber;
  String landLine;
  int blocked;

  Contact(
      {this.contactId,
      this.name,
      this.image = 'fromasset',
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

  //This will be used to update the contact
  Contact copyWith(
      {int contactId,
      String name,
      String image,
      int isFavorite,
      String mobileNumber,
      int blocked,
      String landLine}) {
    return Contact(
        contactId: contactId ?? this.contactId,
        name: name ?? this.name,
        image: image ?? this.image,
        isFavorite: isFavorite ?? this.isFavorite,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        blocked: blocked ?? this.blocked,
        landLine: landLine ?? this.landLine);
  }
}
