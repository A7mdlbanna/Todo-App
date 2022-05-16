import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state){},
        builder: (context, state){
          var tasks = AppCubit.get(context).newTasks;
          return  tasks.length > 0 ? ListView.separated(
            itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
            separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[700],
            ),
            itemCount: tasks.length,
          ) : Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check, size: 70, color: Colors.greenAccent,),
                  Text(
                    'there is nothing to do, Go Outside :)',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 20, ),

                  )
                ],
              ),
            ),
          );
    },
    );
  }
}

buildTaskItem(Map task, context) {
  return Dismissible(
    key: UniqueKey(),
    onDismissed: (direction){
      AppCubit.get(context).deleteData(id: task['id']);
    },
    child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              IconButton(
                onPressed: () => cubit.updateData(status: 'done', id: task['id']),
                icon: Icon(
                        Icons.radio_button_off_outlined,
                        color: Colors.blue.shade500,
                        size: 30,
                      ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  '${task['title']}',
                  style: TextStyle(
                      fontSize: 30,
                      decoration:
                          cubit.isDone ? TextDecoration.lineThrough : null),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 16,
                    ),
                    Text('${task['date']}'),
                    const SizedBox(
                      width: 4,
                    ),
                    const ImageIcon(
                      AssetImage('assets/dot.png'),
                      size: 4.5,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Icon(
                      Icons.notifications,
                      size: 16,
                    ),
                    Text('${task['time']}'),
                  ],
                )
              ]),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () => cubit.updateData(status: 'Important', id: task['id']),
                    icon: const Icon(
                            Icons.star_border,
                            size: 35,
                            color: Colors.white54,
                          ),
                  ),
                ),
              ),
            ]),
          );
        }),
  );
}
