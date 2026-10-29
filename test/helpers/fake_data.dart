/// Sara, as GET /api/auth/me describes a brand-new account:
/// no photo and no bio yet (both are null in the API).
Map<String, dynamic> saraJson() => {
  "id": 57,
  "name": "Sara Ahmed",
  "username": "sara_ahmed",
  "email": "sara@example.com",
  "is_demo": false,
  "photo": null,
  "bio": null,
  "role": "user",
  "stats": {
    "posts_count": 12,
    "reels_count": 0,
    "stories_count": 0,
    "comments_count": 3,
    "likes_count": 40,
    "files_count": 12,
    "reposts_count": 0,
    "mentioned_in_count": 0,
    "followers_count": 180,
    "followings_count": 75,
  },
  "highlights": [],
  "posts": [],
  "stories": [],
  "reposts": [],
  "mentioned_in_posts": [],
  "created_at": "2026-10-29T10:00:00.000000Z",
  "updated_at": "2026-10-29T10:00:00.000000Z",
};

/// The answer to a successful POST /api/auth/login.
Map<String, dynamic> loginAnswer() => {
  "message": "Login successful",
  "data": {
    "user": {
      "id": 57,
      "name": "Sara Ahmed",
      "username": "sara_ahmed",
      "email": "sara@example.com",
      "photo": null,
    },
    "token": "1|fake-token",
  },
};

/// Laravel's answer to wrong credentials (422).
Map<String, dynamic> wrongPasswordAnswer() => {
  "message": "The provided credentials are incorrect.",
  "errors": {
    "email": ["The provided credentials are incorrect."],
  },
};

/// The answer to GET /api/auth/me for Sara.
Map<String, dynamic> meAnswer() => {
  "message": "Current user profile retrieved successfully.",
  "data": saraJson(),
};

/// The answer to GET /api/auth/check-username.
Map<String, dynamic> usernameAnswer(String username, bool available) => {
  "message": available
      ? "Username is available."
      : "Username is already taken.",
  "data": {"username": username, "available": available},
};
