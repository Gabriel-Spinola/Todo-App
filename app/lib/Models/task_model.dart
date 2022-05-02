import './object_model.dart';

class Task implements IObjectModel {
  final int id;
  final String task;
  final DateTime dateTime;

  // ! I mean, the guy in the tutorial didn't had tou use the `required` keyword thing here, so you know... Big Chungus moments
  Task({required this.id, required this.task, required this.dateTime});

  @override
  set id(int _id) {
    id = _id;
  }

  /// Turn data into a `Map`
  ///
  /// NOTE: Make sure that the key have the same name as the table column name
  @override
  Map<String, dynamic> toMap() {
    return ({'id': id, 'task': task, 'creationDate': dateTime.toString()});
  }

  @override
  List<IObjectModel> queryToList(List<Map<String, dynamic>> queryMaps) {
    return List.generate(queryMaps.length, (index) {
      return Task(
        id: queryMaps[index]['id'],
        task: queryMaps[index]['task'],
        dateTime: queryMaps[index]['creationDate'],
      );
    });
  }
}
