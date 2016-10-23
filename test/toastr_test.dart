@TestOn('browser')

import 'dart:html';
import 'dart:async';

import 'package:test/test.dart';
import 'package:toastr/toastr.dart';

void main() {
  const shortDuration = const Duration(milliseconds: 1);

  final expectingSingleToastElement = () {
    expect(document.body.querySelector('#toast-container').children.length, equals(1));
  };

  final expectingToastElements = (int amount) {
    expect(document.body.querySelector('#toast-container').children.length, equals(amount));
  };

  group('Single toast tests', () {
    Toastr toastr = null;

    tearDown(() {
      return toastr.onRemoved.first;
    });

    test('Toastr should contain all the elements', () {
      toastr = new Toastr.success(title: 'hi', duration: shortDuration);

      final toastContainer = document.body.querySelector('#toast-container');

      expect(toastContainer, isNotNull);
      expect(toastContainer.querySelector('.toast-title'), isNotNull);
      expect(toastContainer.querySelector('.toast-message'), isNull);
    });

    test('Toast should be removed after delay', () async {
      toastr = new Toastr.success(title: 'hi', duration: const Duration(seconds: 2));
      
      await new Future.delayed(const Duration(seconds: 1));

      expectingSingleToastElement();
    });

    test('Should remove element immediately', () async {
      toastr = new Toastr.success(title: 'Hello world', duration: const Duration(seconds: 10));

      toastr.remove();
    });
  });

  group('Multiple toast tests', () {
    test('Should be assigned correct classes', () async {
      Map<ToastrType, String> typeToClass = {
        ToastrType.Success: 'toastr-success',
        ToastrType.Error: 'toastr-error',
        ToastrType.Info: 'toastr-info',
        ToastrType.Warning: 'toastr-warning',
      };

      typeToClass.forEach((type, expectedClass) async {
        final toastr = new Toastr(type, expectedClass, expectedClass, duration: shortDuration);

        expect(toastr.element.classes, contains(expectedClass));

        await toastr.onRemoved.first;
      });


    });

    test('Should show multiple toasts', () async {
      List<Toastr> toasts = [
        new Toastr.success(title: 'toast 1', duration: shortDuration),
        new Toastr.success(title: 'toast 2', duration: shortDuration)
      ];

      expectingToastElements(toasts.length);

      await Future.wait(toasts.map((t) => t.onRemoved.first));
    });
  });
}