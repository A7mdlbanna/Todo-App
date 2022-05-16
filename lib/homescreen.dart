import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/done_tasks.dart';
import 'package:todo_app/modules/important_tasks.dart';
import 'package:todo_app/modules/new_tasks.dart';
import 'package:todo_app/modules/planned_tasks.dart';
import 'package:todo_app/shared/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Database database;

  var formKey = GlobalKey<FormState>();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool FloatingIconPlus = false;

  var taskController = TextEditingController();

  var timeController = TextEditingController();

  var dateController = TextEditingController();

  TimeOfDay chosedTime = TimeOfDay.now();

  DateTime choosedDate = DateTime.now();

  var _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    // createDatabase();
    return BlocProvider(
      create: (BuildContext context) {
        return AppCubit()..createDatabase();
      },
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if(state is AppInsertToDatabaseState) {
          Navigator.pop(context);
        }
      },
        builder: (context, state){
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.black,
            key: scaffoldKey,
            appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text(
                  cubit.titles[cubit.item],
                )),
            body: state is!AppGetFromDatabaseLoadingState ?
            PageView(
              controller: _pageController,
              onPageChanged: (pageIndex){
                cubit.ChangeIndex(pageIndex);
              },
              children: [
                NewTasks(),
                PlannedTasks(),
                ImportantTasks(),
                DoneTasks(),
              ])
                // cubit.Screens[cubit.item])
                : Center(child: CircularProgressIndicator(),),
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.floatingIcon),
              backgroundColor: Colors.orange,
                onPressed: () {
                  cubit.clearTask(
                    taskController,
                    timeController,
                    dateController,);
                  if(cubit.FloatingIconPlus) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertToDatabase(
                        taskController.text,
                        timeController.text,
                        dateController.text,
                      );
                      cubit.changeFloatingIconPlusState();
                      cubit.changeFloatingIcon();
                      // setState(() {

                      // });
                    }
                  }
                  else{

                    cubit.changeFloatingIconPlusState();
                    cubit.changeFloatingIcon();
                    scaffoldKey.currentState?.showBottomSheet(

                            (context)=> StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
                              return Container(
                                padding: const EdgeInsets.only(
                                  top: 30,
                                  left: 20,
                                  right: 20,
                                ),
                                color: const Color(0xFF4C4F5E),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        keyboardType: TextInputType.multiline,
                                        onFieldSubmitted: (value) {
                                          taskController.text = value;
                                        },
                                        controller: taskController,
                                        validator: (value) {
                                          if (value != null && value.isEmpty) {
                                            return 'you must insert a task';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          prefix: Padding(
                                            padding: EdgeInsets.zero,
                                          ),
                                          prefixIcon:
                                          Icon(Icons.radio_button_off_outlined),
                                          label: Text('Add a Task'),
                                          border: OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.white54),
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(8.0)),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Text('Add a Reminder:'),
                                          IconButton(
                                              onPressed: () {
                                                showTimePicker(
                                                  context: context,
                                                  initialTime: chosedTime,
                                                ).then((value) {
                                                  setState(() => chosedTime = value!);
                                                  timeController.text =
                                                  value?.format(context) as String;
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.notifications,
                                                color: Colors.white70,
                                              )),
                                          Text(
                                            timeController.text,
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text('Add a Due date:'),
                                          IconButton(
                                              onPressed: () {
                                                // showDateRangePicker(context: context, lastDate: DateTime.parse('2030-01-01'), firstDate: DateTime.now(),);
                                                showDatePicker(
                                                  context: context,
                                                  initialDate: choosedDate,
                                                  firstDate: DateTime.now(),
                                                  lastDate:
                                                  DateTime.parse('2030-01-01'),
                                                ).then((value) {
                                                  setState(() {
                                                    choosedDate = value!;
                                                    dateController.text =
                                                        DateFormat.yMMMd().format(value);
                                                  });
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.calendar_month_outlined,
                                                color: Colors.white70,
                                              )),
                                          Text(
                                            '${dateController.text}',
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                        )
                    ).closed.then((value) {
                      cubit.clearTask(
                        taskController,
                        timeController,
                        dateController,);
                      if(cubit.FloatingIconPlus){
                        cubit.changeFloatingIconPlusState();
                        cubit.changeFloatingIcon();
                      }
                    });
                  }
                },
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.black,
              currentIndex: AppCubit.get(context).item,
              onTap: (index) {
                AppCubit.get(context).ChangeIndex(index);
                _pageController.animateToPage(index, duration: Duration(microseconds: 500), curve: Curves.ease);
              },
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/list.png")), label: 'Tasks'),
                BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Planned'),
                BottomNavigationBarItem(icon: Icon(Icons.star_border), label: 'Important'),
                BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline_rounded), label: 'Done'),
              ],
            ),
          );
        }
      ),
    );
  }
}