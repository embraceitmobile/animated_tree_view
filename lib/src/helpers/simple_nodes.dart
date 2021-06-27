import 'package:animated_tree_view/animated_tree_view.dart';

class SimpleNode extends ListenableNode<SimpleNode> {
  SimpleNode([String? key]) : super(key: key);
}

class SimpleIndexedNode extends ListenableIndexedNode<SimpleIndexedNode> {
  SimpleIndexedNode([String? key]) : super(key: key);
}
