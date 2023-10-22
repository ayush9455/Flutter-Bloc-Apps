import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/cubits/cubits.dart';
import 'package:todo_bloc/models/todo_model.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> with TickerProviderStateMixin {
  late final TabController tabController;
  final TextEditingController todoController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const TodoHeader(),
              const SizedBox(
                height: 20,
              ),
              AddTodo(todoController: todoController),
              const SizedBox(
                height: 20,
              ),
              TodoSearch(searchController: searchController),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                child: TabBar(
                  controller: tabController,
                  tabs: const [
                    Tab(
                      child: Text('All'),
                    ),
                    Tab(
                      child: Text('Active'),
                    ),
                    Tab(
                      child: Text('Completed'),
                    )
                  ],
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: const [
                    ShowTodo(filter: Filter.all),
                    ShowTodo(filter: Filter.active),
                    ShowTodo(filter: Filter.completed),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ShowTodo extends StatefulWidget {
  final Filter filter;
  const ShowTodo({
    super.key,
    required this.filter,
  });

  @override
  State<ShowTodo> createState() => _ShowTodoState();
}

class _ShowTodoState extends State<ShowTodo> {
  @override
  void initState() {
    super.initState();
    context.read<TodoFilterCubit>().changeFilter(widget.filter);
  }

  @override
  Widget build(BuildContext context) {
    final loadedTodos = context.watch<FilteredTodoCubit>().state.filteredTodos;
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) => Dismissible(
        onDismissed: (_) =>
            context.read<TodoListCubit>().removeTodo(loadedTodos[index].id),
        confirmDismiss: (_) => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Are You Sure !'),
                  content: const Text('Do You Really Want To Delete ?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('No')),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Yes'))
                  ],
                )),
        background: const ShowBackground(
          ind: 1,
        ),
        secondaryBackground: const ShowBackground(
          ind: 0,
        ),
        key: Key(loadedTodos[index].id),
        child: TodoListItem(todo: loadedTodos[index]),
      ),
      // ignore: prefer_const_constructors
      separatorBuilder: (context, index) => Divider(),
      itemCount: loadedTodos.length,
    );
  }
}

class ShowBackground extends StatelessWidget {
  const ShowBackground({
    super.key,
    required this.ind,
  });
  final int ind;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: Colors.red,
      ),
      alignment: ind == 0 ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.all(8),
      child: const Icon(
        Icons.delete_rounded,
        color: Colors.white,
      ),
    );
  }
}

class TodoListItem extends StatefulWidget {
  const TodoListItem({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  final TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => showDialog(
          context: context,
          builder: (context) {
            bool error = false;
            textController.text = widget.todo.desc;
            return StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: const Text('Edit Todo'),
                content: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                      errorText: error ? 'Value Should Not Be Empty !' : null),
                  controller: textController,
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () {
                        setState(
                          () {
                            error = textController.text.trim().isEmpty;
                            if (!error) {
                              context.read<TodoListCubit>().editTodo(
                                  widget.todo.id, textController.text.trim());
                              Navigator.pop(context);
                            }
                          },
                        );
                      },
                      child: const Text('Edit'))
                ],
              ),
            );
          }),
      leading: Checkbox(
        value: widget.todo.completed,
        onChanged: (value) =>
            context.read<TodoListCubit>().toggleTodo(widget.todo.id),
      ),
      title: Text(widget.todo.desc),
    );
  }
}

class TodoSearch extends StatelessWidget {
  const TodoSearch({
    super.key,
    required this.searchController,
  });

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
          color: Colors.blueGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          )),
      child: TextField(
        controller: searchController,
        onChanged: (searchTerm) {
          context.read<TodoSearchCubit>().setSearchTerm(searchTerm);
        },
        decoration: const InputDecoration(
            hintText: 'Search',
            prefixIcon: Icon(Icons.search_rounded),
            border: InputBorder.none),
      ),
    );
  }
}

class AddTodo extends StatelessWidget {
  const AddTodo({
    super.key,
    required this.todoController,
  });

  final TextEditingController todoController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: todoController,
      onSubmitted: (todoDesc) {
        if (todoDesc.trim().isNotEmpty) {
          context.read<TodoListCubit>().addTodo(Todo(desc: todoDesc));
          todoController.clear();
        }
      },
      decoration: const InputDecoration(hintText: 'What To Do ?'),
    );
  }
}

class TodoHeader extends StatelessWidget {
  const TodoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'TODO APP',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Text(
          '${context.watch<ActiveTodoCubit>().state.activeTodoCount} Items Left !',
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: Colors.redAccent),
        ),
      ],
    );
  }
}
