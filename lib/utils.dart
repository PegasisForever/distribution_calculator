import 'package:decimal/decimal.dart';
import 'package:expressions/expressions.dart';

BigInt factorio(BigInt bigInt) {
  var result = BigInt.one;

  for (var i = BigInt.one; i <= bigInt; i = i + BigInt.one) {
    result = result * i;
  }

  return result;
}

Decimal factorioDecimal(Decimal num) {
  var result = Decimal.one;

  for (var i = Decimal.one; i <= num; i += Decimal.one) {
    result = result * i;
  }

  return result;
}

Decimal combine(Decimal n, Decimal r) {
  return factorioDecimal(n) / factorioDecimal(r) / factorioDecimal(n - r);
}

final _evaluator = const ExpressionEvaluator();
// return null means invalid
Decimal evaluateExpression(String str) {
  var expression = Expression.tryParse(str);
  if (expression == null) {
    return null;
  } else {
    return Decimal.parse(_evaluator.eval(expression, {}).toString());
  }
}
