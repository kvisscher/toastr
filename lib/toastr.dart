import 'dart:async';
import 'dart:html';

class Toastr {
  Element _toastElement;

  StreamController _removedController = new StreamController();

  bool _removed = false;

  Toastr(ToastrType type, String title, String message,
      {Duration duration: const Duration(seconds: 2)}) {
    Element toastContainerElement =
        document.body.querySelector('#toast-container');

    if (toastContainerElement == null) {
      toastContainerElement = new DivElement()..id = 'toast-container';

      document.body.children.add(toastContainerElement);
    }

    _toastElement = new DivElement()..className = _computeClass(type);

    if (title?.isNotEmpty ?? false) {
      final titleElement = new DivElement()
        ..className = 'toast-title'
        ..text = title;

      _toastElement.children.add(titleElement);
    }

    if (message?.isNotEmpty ?? false) {
      final messageElement = new DivElement()
        ..className = 'toast-message'
        ..text = title;

      _toastElement.children.add(messageElement);
    }

    toastContainerElement.children.add(_toastElement);

    new Future.delayed(duration, remove);
  }

  factory Toastr.success({String title, String message, Duration duration}) {
    return new Toastr(ToastrType.Success, title, message, duration: duration);
  }

  factory Toastr.info({String title, String message, Duration duration}) {
    return new Toastr(ToastrType.Info, title, message, duration: duration);
  }

  factory Toastr.warning({String title, String message, Duration duration}) {
    return new Toastr(ToastrType.Warning, title, message, duration: duration);
  }

  factory Toastr.error({String title, String message, Duration duration}) {
    return new Toastr(ToastrType.Error, title, message, duration: duration);
  }

  void remove() {
    if (!_removed) {
      _toastElement.remove();

      _removedController.add(null);

      _removed = true;
    }
  }

  String _computeClass(ToastrType type) {
    switch (type) {
      case ToastrType.Success:
        return 'toastr-success';

      case ToastrType.Error:
        return 'toastr-error';

      case ToastrType.Warning:
        return 'toastr-warning';

      case ToastrType.Info:
        return 'toastr-info';
    }

    throw new UnsupportedError('Unknown toast type $type');
  }

  Element get element => _toastElement;

  Stream get onRemoved => _removedController.stream;
}

enum ToastrType {
  Success,
  Error,
  Warning,
  Info,
}
