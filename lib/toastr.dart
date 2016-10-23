import 'dart:async';
import 'dart:html';

class Toastr {
  Element toastElement;

  StreamController _removedController = new StreamController();

  bool _removed = false;

  Toastr.success(
      {String title,
      String message,
      Duration duration: const Duration(seconds: 2)}) {
    Element toastContainerElement =
        document.body.querySelector('#toast-container');

    if (toastContainerElement == null) {
      toastContainerElement = new DivElement()..id = 'toast-container';

      document.body.children.add(toastContainerElement);
    }

    toastElement = new DivElement();

    if (title?.isNotEmpty ?? false) {
      final titleElement = new DivElement()
        ..className = 'toast-title'
        ..text = title;

      toastElement.children.add(titleElement);
    }

    if (message?.isNotEmpty ?? false) {
      final messageElement = new DivElement()
        ..className = 'toast-message'
        ..text = title;

      toastElement.children.add(messageElement);
    }

    toastContainerElement.children.add(toastElement);

    new Future.delayed(duration, remove);
  }

  void remove() {
    if (!_removed) {
      toastElement.remove();

      _removedController.add(null);

      _removed = true;
    }
  }

  Stream get onRemoved => _removedController.stream;
}

enum ToastrType {
  Success,
  Error,
  Warning,
  Info,
}
