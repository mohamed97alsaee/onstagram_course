import 'package:material_ui/material_ui.dart';
import 'package:onstagram/helpers/consts.dart';

class EmptyPosts extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 2,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            child: Icon(Icons.camera_alt_outlined, size: 36),
          ),
          SizedBox(height: 12),
          Text("No posts yet", style: titleLarge),
          SizedBox(height: 12),
          Text(
            "Your photos will appear here. Posting comes in the Core course.",
            textAlign: TextAlign.center,
            style: bodyMedium.copyWith(color: greyTextColor),
          ),
        ],
      ),
    );
  }
}
