import '../core.dart';

class ListExpression extends Expression {
  ListExpression(this.values);

  final List<Expression> values;

  @override
  List<Object> resolve(Context context) {
    return values
        .map<Object>((Expression value) => value.resolve(context))
        .toList();
  }

  @override
  String toDebugString([int level = 0]) {
    final buffer = StringBuffer('${' ' * level}[');
    buffer.writeAll(
        values.map<String>((Expression value) => value.toDebugString()), ',');
    buffer.write(']');
    return buffer.toString();
  }

  @override
  String toString() {
    return 'ListExpression($values)';
  }
}

class MapExpression extends Expression {
  MapExpression(this.values);

  final Map<Expression, Expression> values;

  @override
  Map<Object, Object> resolve(Context context) {
    return values.map<Object, Object>((Expression key, Expression value) =>
        MapEntry<Object, Object>(key.resolve(context), value.resolve(context)));
  }

  @override
  String toDebugString([int level = 0]) {
    final buffer = StringBuffer(' ' * level);

    values.forEach((Expression key, Expression value) {
      buffer.write(key.toDebugString());
      buffer.write(': ');
      buffer.write(value.toDebugString());
    });

    return buffer.toString();
  }

  @override
  String toString() {
    return 'MapExpression($values)';
  }
}

class TupleExpression extends Expression implements CanAssign {
  TupleExpression(this.items);

  final List<Expression> items;

  @override
  List<Object> resolve(Context context) {
    return items
        .map<Object>((Expression value) => value.resolve(context))
        .toList();
  }

  @override
  bool get canAssign {
    return items.every((Expression item) => item is Name);
  }

  @override
  List<String> get keys {
    return items.map<String>((Expression item) => (item as Name).name).toList();
  }

  @override
  String toDebugString([int level = 0]) {
    final buffer = StringBuffer('${' ' * level}[');
    buffer.writeAll(
        items.map<String>((Expression item) => item.toDebugString()), ', ');
    buffer.write(']');
    return buffer.toString();
  }

  @override
  String toString() {
    return 'TupleExpression($items)';
  }
}
