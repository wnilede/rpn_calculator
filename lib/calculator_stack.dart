import 'package:rpn_calculator/number_presentation.dart';

class CalculatorStack {
  List<double> _values = List<double>.unmodifiable([]);
  NumberPresentation _currentInput;
  InputMode _inputMode = InputMode.writing;
  final void Function(void Function()) _setState;
  bool _topOfStackIsDuplicate = false; // When pressing enter, the top is duplicated temporarily and is removed unless enter is pressed again.

  CalculatorStack(this._setState) : _currentInput = NumberPresentation.empty();

  int get length => _values.length;
  InputMode get inputMode => _inputMode;
  NumberPresentation get currentInput => _currentInput;
  double operator [](int index) => _values[index];

  void _push(double value) {
    _setState(() {
      _values = List<double>.unmodifiable([
        value,
        ..._values,
      ]);
      _topOfStackIsDuplicate = false;
    });
  }

  double? _pop() {
    if (_values.isEmpty) {
      return null;
    }
    double value = _values[0];
    _setState(() {
      _values = List<double>.unmodifiable(_values.skip(1));
    });
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
    _setState(() {
      _currentInput = NumberPresentation.empty();
      _inputMode = InputMode.writing;
    });
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
          _setState(() {
            _currentInput = currentInput.copyWith(mainPart: '${currentInput.mainPart == '0' ? '' : currentInput.mainPart}$digitToEnter');
          });
        }
        break;
      case InputMode.writingExponent:
        _setState(() {
          _currentInput = currentInput.copyWith(exponent: '${currentInput.exponent!.substring(1)}$digitToEnter');
        });
        break;
    }
  }

  void enterDecimalPoint() {
    _removeDuplicatedHead();
    switch (_inputMode) {
      case InputMode.writing:
        if (!_currentInput.mainPart.contains('.') && _currentInput.mainPart.length < 11) {
          _setState(() {
            _currentInput = currentInput.copyWith(mainPart: '${currentInput.mainPart == '' ? '0' : currentInput.mainPart}.');
          });
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
      _setState(() {
        _currentInput = NumberPresentation.empty();
        _topOfStackIsDuplicate = true;
      });
    }
  }
}

enum InputMode {
  writing,
  writingExponent
}
