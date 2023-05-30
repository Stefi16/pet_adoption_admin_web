import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_user.g.dart';

@JsonSerializable()
class AppUser {
  String id;
  String email;
  String? username;
  List<String> favouritePosts;
  DateTime dateJoined;
  String? picture;
  String? phone;
  @JsonKey(defaultValue: false)
  bool isAdmin;
  @JsonKey(defaultValue: FlexScheme.aquaBlue)
  FlexScheme theme;
  @JsonKey(defaultValue: false)
  bool isDarkMode;

  AppUser({
    required this.id,
    required this.email,
    this.username,
    required this.favouritePosts,
    required this.dateJoined,
    this.picture,
    this.phone,
    required this.isAdmin,
    required this.theme,
    required this.isDarkMode,
  });

  factory AppUser.createNew(String id, String email) {
    return AppUser(
      id: id,
      email: email,
      favouritePosts: [],
      dateJoined: DateTime.now(),
      isAdmin: false,
      theme: FlexScheme.aquaBlue,
      isDarkMode: false,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
