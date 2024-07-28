import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/model/task_model.dart';

class FirebaseUtils {
  static CollectionReference<Task> getTaskCollection() {
    return FirebaseFirestore.instance
        .collection(Task.nameCollection)
        .withConverter<Task>(
          fromFirestore: (snapshot, _) => Task.fromFireStore(snapshot.data()!),
          toFirestore: (task, _) => task.toFireStore(),
        );
  }

  static Future<void> addTaskToFireStore(Task task) {
    var taskCollection = getTaskCollection(); // collection
    DocumentReference<Task> taskDoc = taskCollection.doc(); // document
    task.id = taskDoc.id; //set model "id"

    return taskDoc.set(task);
  }

  static Future<void> editTask(
    String id,
    String title,
    String desc,
    DateTime datetime,
  ) {
    var collection = FirebaseUtils.getTaskCollection();
    Task task = Task(title: title, description: desc, dateTime: datetime);
    return collection.doc(id).update({
      'title': task.title,
      'description': task.description,
    });
  }

  static Future<void> editIsDone(String id, bool isDone) {
    var collection = FirebaseUtils.getTaskCollection();
    return collection.doc(id).update({
      'isDone': isDone,
    });
  }
}