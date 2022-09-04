import 'package:meta/meta.dart';

class Key {}

abstract class MetaObject {
  const MetaObject({this.key});

  Element createElement();

  final Key? key;
}

typedef ElementVisitor = void Function(Element element);

abstract class Element<T extends MetaObject> {
  Element(this.metaObject);

  Element? _parent;

  final T metaObject;

  /// Implementations of this method should starts with a call to the
  /// inherited method as in super.mount(parent)
  @mustCallSuper
  void mount(Element? parent) {
    _parent = parent;
  }

  void visitChildren(ElementVisitor visitor) {}
}

abstract class ComponentElement<T extends MetaObject> extends Element<T> {
  ComponentElement(super.metaObject);

  late Element _child;

  MetaObject build();

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _parent = parent;
    _child = build().createElement();
    _child.mount(this);
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    visitor.call(_child);
  }
}

class Seed extends MetaObject {
  Seed({super.key});

  @override
  Element<MetaObject> createElement() {
    return SeedElement(this);
  }

  MetaObject build();
}

class SeedElement extends ComponentElement<Seed> {
  SeedElement(super.metaObject);

  @override
  MetaObject build() {
    return metaObject.build();
  }
}

/// An element witch handle concrete operation
abstract class Fragment extends Element {
  Fragment(super.metaObject);
}

abstract class MultiChildMetaObject extends MetaObject {
  const MultiChildMetaObject(this.children);

  final List<MetaObject> children;
}

abstract class MultiChildElement<T extends MultiChildMetaObject>
    extends Element<T> {
  MultiChildElement(super.metaObject) : _children = const [];

  List<Element> _children;

  @override
  void mount(Element? parent) {
    super.mount(parent);
    _children = [
      for (final child in metaObject.children) child.createElement()
    ];
    for (final child in _children) {
      child.mount(this);
    }
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    for (final child in _children) {
      visitor(child);
    }
  }
}