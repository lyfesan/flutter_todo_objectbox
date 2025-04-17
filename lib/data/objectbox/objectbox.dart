import 'package:path/path.dart' as p;
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_todo_objectbox/data/models/task.dart';
import 'package:flutter_todo_objectbox/objectbox.g.dart';

late ObjectBox objectBox;

class ObjectBox {
  /// The Store of this app.
  late final Store store;

  ObjectBox._create(this.store) {
    // Add any additional setup code, e.g. build queries.
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore(directory: p.join(docsDir.path, "todo_objectbox"));
    return ObjectBox._create(store);
  }
}