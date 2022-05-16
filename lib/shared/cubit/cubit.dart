import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/states.dart';

import '../../modules/done_tasks.dart';
import '../../modules/important_tasks.dart';
import '../../modules/new_tasks.dart';
import '../../modules/planned_tasks.dart';
import '../constants.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  var item = 0;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> plannedTasks = [];
  List<Map> importantTasks = [];


  bool FloatingIconPlus = false;

  List<String> titles = [
    'New Tasks',
    'Planned Tasks',
    'Important Tasks',
    'Done Tasks',
  ];
  List<Widget> Screens = [
    NewTasks(),
    PlannedTasks(),
    ImportantTasks(),
    DoneTasks(),
  ];

  void ChangeIndex(index){
    item = index;
    emit(AppChangeNavBarState());
  }
  void changeFloatingIconPlusState() {
    FloatingIconPlus = !FloatingIconPlus;
    emit(AppChangeFloatingIconPlusState());
  }

  IconData floatingIcon = Icons.edit;
  void changeFloatingIcon(){
    floatingIcon == Icons.edit ? floatingIcon = Icons.add : floatingIcon = Icons.edit;
    emit(AppChangeFloatingIconState());
  }

  void clearTask(text, date, time){
    text.clear;
    date.clear;
    time.clear;
    emit(AppClearTask());
  }

  TimeOfDay choosedTime = TimeOfDay.now();
  DateTime choosedDate = DateTime.now();

  setDateController(value, controller){
      choosedDate = value;
      controller.text =  DateFormat.yMMMd().format(value);
      emit(AppSetDateController());
  }
  setTimeController(value, controller){
      choosedTime = value;
      controller.text = value;
      emit(AppSetTimeController());
  }


  /////////////////NewTasks////////////////////
  bool isDone = false;
  bool isImportant = false;

  void changeIsDoneState() {
    isDone = !isDone;
    emit(AppChangeIsDoneState());
  }
  void changeIsImportantState() {
    isImportant = !isImportant;
    emit(AppChangeIsImportantState());
  }


  //////////////////DataBase///////////////////

  late Database database;

  void createDatabase() {
    openDatabase(
        'todo.dp', version: 1,
        onCreate: (database, version) {
          print('database created');
          database
              .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT)')
              .then((value) {
            print('table created');
          }).catchError((error) {
            print('Error When Creating Table ${error.toString}');
          });
        }, onOpen: (database) {
      getFromDatabase(database);
      print('database opened');
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase(String task, String time, String date) async{
    await database.transaction((txn) {
      return txn.rawInsert(
        'INSERT INTO tasks(title, date , time, status) VALUES("$task", "$date" , "$time" ,"new")',
      ).then((value) {
        print('$value inserted successfully');
        emit(AppInsertToDatabaseState());

        getFromDatabase(database);
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });
    });
  }

  void getFromDatabase(database) {
    newTasks = [];
    plannedTasks = [];
    importantTasks = [];
    doneTasks = [];

    emit(AppGetFromDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {

      value.forEach((element){
        if(element['status'] == 'new') {newTasks.add(element);}
        else if(element['status'] == 'done'){doneTasks.add(element);}
        else if(element['status'] == 'planned'){plannedTasks.add(element);}
        else if(element['status'] == 'Important'){importantTasks.add(element);}
      });
      emit(AppGetFromDatabaseState());
    });
  }

  void updateData({required String status, required int id}) {
      database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id]).then((value) {
        getFromDatabase(database);
        emit(AppUpdateDatabaseState());
      });

  }
  void  deleteData({required int id}){
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id])
        .then((value) {
          getFromDatabase(database);
          emit(AppDeleteDatabaseState());
        });
  }
}
