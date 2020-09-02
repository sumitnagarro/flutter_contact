abstract class BaseModel {
  BaseModel(fromJson(Map<String, dynamic> json), toJson());
  fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
