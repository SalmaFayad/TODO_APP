import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeScreen extends StatelessWidget
{
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) =>AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is AppInsertDataBaseState )
            {
              Navigator.pop(context);
            }
        },
        builder: (context,state){
          AppCubit cubit= AppCubit.get(context); //new cubit object
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: cubit.titles[cubit.currentIndex],
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDataBaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.openBottomSheet) { //if it open i will validate it
                  if (formKey.currentState.validate()) {
                    cubit.insertDataBase(title: titleController.text, time: timeController.text, date: dateController.text);
                  }
                } else {// if not open i will open it
                  scaffoldKey.currentState.showBottomSheet(
                        (context) => Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'title must not be empty';
                                    } else
                                      return null;
                                  },
                                  label: 'Task Title',
                                  prefix: Icons.title,
                                ),
                                SizedBox(height: 15),
                                defaultFormField(
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text =
                                          value.format(context).toString();
                                      print(value.format(context));
                                    });
                                  },
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'time must not be empty';
                                    } else
                                      return null;
                                  },
                                  label: 'Task Time',
                                  prefix: Icons.watch_later_outlined,
                                ),
                                SizedBox(height: 15),
                                defaultFormField(
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(DateTime.now().year+1),
                                    ).then((value) {
                                      dateController.text =
                                          dateController.text= DateFormat.yMMMd().format(value);
                                    });
                                  },
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'date must not be empty';
                                    } else
                                      return null;
                                  },
                                  label: 'Task Date',
                                  prefix: Icons.calendar_today,
                                ),
                              ],
                            ),
                          ),
                        ),
                    elevation: 20.0,
                  ).closed.then((value)
                  {
                    cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
              cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: 'Done'),
                BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Archived'),
              ],
            ),
          );
        },
      ),
    );
  }
}

