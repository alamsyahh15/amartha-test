import 'dart:convert';

List<Todo> todoModelFromJson(String str) =>
    List<Todo>.from(json.decode(str).map((x) => Todo.fromJson(x)));

String todoModelToJson(List<Todo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Todo {
  Todo({
    required this.nameTask,
    required this.isDone,
  });

  String nameTask;
  bool isDone;

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        nameTask: json["name_task"],
        isDone: json["is_done"],
      );

  Map<String, dynamic> toJson() => {
        "name_task": nameTask,
        "is_done": isDone,
      };
}
