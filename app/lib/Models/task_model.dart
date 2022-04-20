class Task {
  final int id;
  final String task;
  final DateTime dateTime;

  // ! I mean, the guy in the tutorial didn't had tou use the `required` keyword thing here, so you know... Big Chungus moments
  Task({required this.id, required this.task, required this.dateTime});

  /// Turn data into a `Map`
  ///
  /// NOTE: Make sure that the key have the same name as the table column name
  Map<String, dynamic> toMap() {
    return ({'id': id, 'task': task, 'creationDate': dateTime.toString()});
  }
}
