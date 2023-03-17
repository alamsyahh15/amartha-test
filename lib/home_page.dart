import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_amartha/model/todo_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color baseColor = const Color.fromARGB(255, 251, 53, 73);
  late SharedPreferences _prefs;
  List<Todo> todos = [];

  void init() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (mounted) {
        _prefs = await SharedPreferences.getInstance();
        final result = _prefs.getString("todos");
        if (result != null) {
          todos = todoModelFromJson(result);
        }
        setState(() {});
      }
    });
  }

  insertTodo() async {
    TextEditingController valueController = TextEditingController();
    valueController.clear();
    String? result = await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text("Add New Todo"),
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: valueController,
                  decoration: const InputDecoration(hintText: "Type your todo"),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context, valueController.text);
                  },
                  child: const Text("Add"),
                ),
              )
            ],
          ),
        );
      },
    );
    if (result != null && result.isNotEmpty) {
      todos.add(Todo(nameTask: result, isDone: false));
      updateDbLocal();
      setState(() {});
    }
  }

  deleteTodo(int index) {
    todos.removeAt(index);
    updateDbLocal();
    setState(() {});
  }

  updateTodo(int index) {
    todos[index].isDone = !todos[index].isDone;
    updateDbLocal();
    setState(() {});
  }

  void updateDbLocal() {
    _prefs.setString("todos", todoModelToJson(todos));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: baseColor,
        title: const Text("Todo List"),
      ),
      body: todos.isEmpty
          ? Center(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  "https://img.freepik.com/free-vector/no-data-concept-illustration_114360-626.jpg",
                  height: 200,
                ),
                const Text("Data Masih Kosong"),
              ],
            ))
          : Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final data = todos[index];
                      return Dismissible(
                        key: Key("${data.nameTask}-$index"),
                        onDismissed: (direction) {
                          deleteTodo(index);
                        },
                        child: ListTile(
                          leading: CircleAvatar(child: Text(data.nameTask[0])),
                          title: Text(
                            data.nameTask,
                            style: TextStyle(
                              decoration: data.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: data.isDone ? Colors.grey : Colors.black,
                            ),
                          ),
                          onTap: () => updateTodo(index),
                        ),
                      );
                    },
                  ),
                  if (todos.length == 1) const Text("Swipe to delete")
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: baseColor,
        onPressed: insertTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
