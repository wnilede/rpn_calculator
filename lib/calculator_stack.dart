import 'package:flutter/material.dart';
import 'package:rpn_calculator/number_presentation.dart';

class CalculatorStack extends ChangeNotifier {
  List<double> _values = List<double>.unmodifiable([]);
  NumberPresentation _currentInput = NumberPresentation.empty();
  InputMode _inputMode = InputMode.writing;
  bool _topOfStackIsDuplicate = false; // When pressing enter, the top is duplicated temporarily and is removed unless enter is pressed again.

  int get length => _values.length;
  InputMode get inputMode => _inputMode;
  NumberPresentation get currentInput => _currentInput;
  double operator [](int index) => _values[index];

  void _push(double value) {
    _values = List<double>.unmodifiable([
      value,
      ..._values,
    ]);
    _topOfStackIsDuplicate = false;
    notifyListeners();
  }

  double? _pop() {
    if (_values.isEmpty) {
      return null;
    }
    double value = _values[0];
    _values = List<double>.unmodifiable(_values.skip(1));
    notifyListeners();
    return value;
  }

  void push(double value) {
    _pushInputLineToStack();
    _push(value);
  }

  void applyOnOne(double Function(double) functionToApply) {
    _pushInputLineToStack();
    if (length < 1) {
      return;
    }
    _push(functionToApply(_pop()!));
  }

  void applyOnTwo(double Function(double, double) functionToApply) {
    _pushInputLineToStack();
    if (length < 2) {
      return;
    }
    _push(functionToApply(_pop()!, _pop()!));
  }

  void _clearInputLine() {
    _currentInput = NumberPresentation.empty();
    _inputMode = InputMode.writing;
    notifyListeners();
  }

  void _pushInputLineToStack() {
    _copyInputLineToStack();
    _clearInputLine();
  }

  void _removeDuplicatedHead() {
    if (_topOfStackIsDuplicate) {
      _pop();
      _topOfStackIsDuplicate = false;
    }
  }

  void _copyInputLineToStack() {
    if (currentInput.isEmpty) {
      return;
    }
    _push(currentInput.toDouble());
  }

  void enterDigit(int digitToEnter) {
    assert(digitToEnter >= 0 && digitToEnter < 10);
    _removeDuplicatedHead();
    switch (_inputMode) {
      case InputMode.writing:
        if (currentInput.numberOfDigits < 10 && (currentInput.numberOfDigits != 0 || digitToEnter != 0 || currentInput.isEmpty)) {
          _currentInput = currentInput.copyWith(mainPart: '${currentInput.mainPart == '0' ? '' : currentInput.mainPart}$digitToEnter');
          notifyListeners();
        }
        break;
      case InputMode.writingExponent:
        _currentInput = currentInput.copyWith(exponent: '${currentInput.exponent!.substring(1)}$digitToEnter');
        notifyListeners();
        break;
    }
  }

  void enterDecimalPoint() {
    _removeDuplicatedHead();
    switch (_inputMode) {
      case InputMode.writing:
        if (!_currentInput.mainPart.contains('.') && _currentInput.mainPart.length < 11) {
          _currentInput = currentInput.copyWith(mainPart: '${currentInput.mainPart == '' ? '0' : currentInput.mainPart}.');
          notifyListeners();
        }
        break;
      case InputMode.writingExponent:
        break;
    }
  }

  void pressEnterButton() {
    if (_currentInput.isEmpty) {
      if (_values.isEmpty) {
        return;
      }
      _push(_values[0]);
    } else {
      double currentValue = _currentInput.toDouble();
      _push(currentValue);
      _push(currentValue);
      _currentInput = NumberPresentation.empty();
      _topOfStackIsDuplicate = true;
      notifyListeners();
    }
  }
}

enum InputMode {
  writing,
  writingExponent
}
