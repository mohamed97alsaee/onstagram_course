# onstagram

The app built in **Onstagram 1: Foundations** (Udemy, by Mohamed Alsaee).
A Flutter client for the real Onstagram API: login, register, a secure token,
one `ScreenRouter`, and your profile. Layers: Screen → Provider → Api.

## Checkpoints

Every lesson ends with a git tag. To start a lesson from where the previous one ended:

```bash
git checkout F-M02-L05-end   # the end of lesson M02-L05
```

`F-M01-L02-end` is this empty state: the project itself is created in lesson
M01-L03 with `flutter create`.

## How to run

1. Get your student key from <https://onstagramcourse.com/student/api-key>.
2. Copy the example file and paste your key into the copy:

   ```bash
   cp .env.example.json .env.json
   ```

   `.env.json` is in `.gitignore`: your key never goes to Git.
3. Run with the key:

   ```bash
   flutter run --dart-define-from-file=.env.json
   ```

   In VS Code, press F5: `.vscode/launch.json` already passes the file.

Changed `.env.json`? Stop the app and run it again: the key is read
when the app is built, so hot reload does not see the new value.
