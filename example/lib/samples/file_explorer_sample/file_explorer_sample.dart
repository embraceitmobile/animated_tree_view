import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:example/utils/utils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Explorer Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'File Explorer Sample'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: TreeView.simpleTyped<Explorable, TreeNode<Explorable>>(
          tree: tree,
          showRootNode: true,
          expansionBehavior: ExpansionBehavior.none,
          expansionIndicatorBuilder: (context, node) {
            if (node.isRoot)
              return PlusMinusIndicator(
                tree: node,
                alignment: Alignment.centerLeft,
                color: Colors.grey[700],
              );

            return ChevronIndicator.rightDown(
              tree: node,
              alignment: Alignment.centerLeft,
              color: Colors.grey[700],
            );
          },
          indentation: Indentation(
            decoration: IndentationDecoration(style: IndentStyle.squareJoint),
          ),
          builder: (context, node) => Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: ListTile(
              title: Text(node.data?.name ?? "N/A"),
              subtitle: Text(node.data?.createdAt.toString() ?? "N/A"),
              leading: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: node.icon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on ExplorableNode {
  Icon get icon {
    if (isRoot) return Icon(Icons.data_object);

    if (this is FolderNode) {
      if (isExpanded) return Icon(Icons.folder_open);
      return Icon(Icons.folder);
    }

    if (this is FileNode) {
      final file = this.data as File;
      if (file.mimeType.startsWith("image")) return Icon(Icons.image);
      if (file.mimeType.startsWith("video")) return Icon(Icons.video_file);
    }

    return Icon(Icons.insert_drive_file);
  }
}

abstract class Explorable {
  final String name;
  final DateTime createdAt;

  Explorable(this.name) : this.createdAt = DateTime.now();

  @override
  String toString() => name;
}

class File extends Explorable {
  final String mimeType;

  File(super.name, {required this.mimeType});
}

class Folder extends Explorable {
  Folder(super.name);
}

typedef ExplorableNode = TreeNode<Explorable>;

typedef FileNode = TreeNode<File>;

typedef FolderNode = TreeNode<Folder>;

final tree = TreeNode<Explorable>.root(data: Folder("/root"))
  ..addAll([
    FolderNode(data: Folder("Documents"))
      ..addAll([
        FileNode(
          data: File("report.doc", mimeType: "application/msword"),
        ),
        FileNode(
          data: File("budget.xls", mimeType: "application/vnd.ms-excel"),
        ),
        FileNode(
          data: File("training.ppt", mimeType: "application/vnd.ms-powerpoint"),
        )
      ]),
    FolderNode(data: Folder("Media"))
      ..addAll([
        FolderNode(data: Folder("Pictures"))
          ..addAll([
            FileNode(data: File("birthday_1.jpg", mimeType: "image/jpeg")),
            FileNode(data: File("birthday_2.jpg", mimeType: "image/jpeg")),
            FileNode(data: File("birthday_3.jpg", mimeType: "image/jpeg")),
            FileNode(data: File("birthday_4.jpg", mimeType: "image/jpeg")),
            FileNode(data: File("birthday_5.jpg", mimeType: "image/jpeg")),
            FileNode(data: File("birthday_6.jpg", mimeType: "image/jpeg")),
            FileNode(data: File("birthday_7.jpg", mimeType: "image/jpeg")),
            FileNode(data: File("birthday_8.jpg", mimeType: "image/jpeg")),
            FileNode(data: File("birthday_9.jpg", mimeType: "image/jpeg")),
            FileNode(data: File("lunch_1.jpg", mimeType: "image/jpeg")),
            FileNode(data: File("lunch_2.jpg", mimeType: "image/jpeg")),
            FileNode(data: File("lunch_3.jpg", mimeType: "image/jpeg")),
            FileNode(data: File("lunch_4.jpg", mimeType: "image/jpeg")),
            FileNode(data: File("lunch_5.jpg", mimeType: "image/jpeg")),
            FileNode(data: File("lunch_6.jpg", mimeType: "image/jpeg")),
            FileNode(data: File("lunch_7.jpg", mimeType: "image/jpeg")),
            FileNode(data: File("banner.png", mimeType: "image/png")),
          ]),
        FolderNode(data: Folder("Videos"))
          ..addAll([
            FolderNode(data: Folder("Birthday_23"))
              ..addAll([
                FileNode(
                    data: File("birthday_23_1.mp4", mimeType: "video/mp4")),
                FileNode(
                    data: File("birthday_23_2.mp4", mimeType: "video/mp4")),
              ]),
            FolderNode(data: Folder("vacation_ibiza"))
              ..addAll([
                FileNode(data: File("snorkeling.mp4", mimeType: "video/mp4")),
                FileNode(data: File("scuba.mp4", mimeType: "video/mp4")),
              ])
          ])
      ]),
    FolderNode(data: Folder("System"))
      ..addAll([
        FolderNode(data: Folder("temp")),
        FolderNode(data: Folder("apps"))
          ..addAll([
            FileNode(
              data: File("word.exe", mimeType: "application/win32_exe"),
            ),
            FileNode(
              data: File("powerpoint.exe", mimeType: "application/win32_exe"),
            ),
            FileNode(
              data: File("excel.exe", mimeType: "application/win32_exe"),
            ),
          ]),
        FileNode(
          data: File("sys.exe", mimeType: "application/win32_exe"),
        ),
        FileNode(
          data: File("config.exe", mimeType: "application/win32_exe"),
        )
      ]),
  ]);
