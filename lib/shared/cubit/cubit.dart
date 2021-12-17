import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<Widget> titles = [
    Text('New Tasks'),
    Text('Done Tasks'),
    Text('Archived Tasks'),
  ];

  void changeIndex(index) {
    currentIndex = index;
    emit(AppBottomNavBar());
  }

  Database database;
  List<Map> tasks = [];
  void createDataBase() {
    openDatabase(
      'todo.db', //check name if exist open it if not create it
      version: 1,
      onCreate: (database, version) {
        // 2-create table
        print('Database created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY ,title TEXT ,date TEXT ,time TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error when created database is ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDataBase(database).then((value) {
          tasks = value;
          print(tasks);
          emit(AppGetDataBaseState());
        });
        print("Database opened");
      },
    ).then((value) {
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

  Future insertDataBase(
      {@required String title,
      @required String time,
      @required String date}) async {
    return await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks (title , date ,time ) VALUES ("$title","$date","$time")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDataBaseState());
      }).catchError((error) {
        print('Error when insert database is ${error.toString()}');
      });
      return null;
    });
  }

  Future<List<Map>> getDataFromDataBase(database) async {
    return await database.rawQuery('SELECT * FROM TASKS');
  }

  bool openBottomSheet = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState(
      {@required bool isShow, @required IconData icon}) {
   openBottomSheet= isShow;
   fabIcon=icon;
   emit(AppBottomSheetShowState());
  }
}
