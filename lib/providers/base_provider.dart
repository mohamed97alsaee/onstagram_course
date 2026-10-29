import 'package:flutter/foundation.dart';
import 'package:onstagram/services/api.dart';

/// What every provider action returns to the screen.
typedef ActionResult = ({bool success, String message});

class BaseProvider with ChangeNotifier {
  Api api = Api();

  bool busy = false;
  bool busyMore = false;
  bool failed = false;
  bool paginating = false;

  void setBusy(bool value) {
    busy = value;
    notifyListeners();
  }

  void setBusyMore(bool value) {
    busyMore = value;
    notifyListeners();
  }

  void setFailed(bool value) {
    failed = value;
    notifyListeners();
  }

  void setPaginating(bool value) {
    paginating = value;
    notifyListeners();
  }
}
