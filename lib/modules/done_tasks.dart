import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';
class DoneTasks extends StatelessWidget {
  const DoneTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state){
        var tasks = AppCubit.get(context).doneTasks;
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
  buildTaskItem(Map task, context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction){
              cubit.deleteData(id: task['id']);},
           child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              IconButton(
                onPressed: () {
                  cubit.updateData(status: 'new', id: task['id']);
                  // cubit.changeIsDoneState();
                },
                icon: Icon(
                  Icons.check_circle,
                  color: Color(0xFFB2CBFA),
                  size: 30,
                )
              ),
              SizedBox(
                width: 5.0,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  '${task['title']}',
                  style: TextStyle(
                      fontSize: 30,
                      decoration: TextDecoration.lineThrough),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 16,
                    ),
                    Text('${task['date']}'),
                    SizedBox(
                      width: 4,
                    ),
                    ImageIcon(
                      AssetImage('assets/dot.png'),
                      size: 4.5,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(
                      Icons.notifications,
                      size: 16,
                    ),
                    Text('${task['time']}'),
                  ],
                )
              ]),
            ]),
          )
          );
        });
  }

}
