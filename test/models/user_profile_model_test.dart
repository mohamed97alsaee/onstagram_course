import 'package:flutter_test/flutter_test.dart';
import 'package:onstagram/models/user_profile_model.dart';

import '../helpers/fake_data.dart';

void main() {
  test('a new account without photo or bio still parses', () {
    final user = UserProfileModel.fromJson(saraJson());

    expect(user.id, 57);
    expect(user.username, "sara_ahmed");
    expect(user.photo, isNull);
    expect(user.bio, isNull);
    expect(user.stats.postsCount, 12);
    expect(user.stats.followersCount, 180);
    expect(user.stats.followingsCount, 75);
    expect(user.createdAt, DateTime.utc(2026, 10, 29, 10));
  });

  test('photo and bio are read when the account has them', () {
    final user = UserProfileModel.fromJson({
      ...saraJson(),
      "photo": "https://onstagramcourse.com/storage/sara.jpg",
      "bio": "Flutter learner from Amman",
    });

    expect(user.photo, "https://onstagramcourse.com/storage/sara.jpg");
    expect(user.bio, "Flutter learner from Amman");
  });

  test('toJson gives back the API field names', () {
    final json = UserProfileModel.fromJson(saraJson()).toJson();

    expect(json["is_demo"], false);
    expect(json["stats"]["followings_count"], 75);
    expect(json["bio"], isNull);
  });
}
