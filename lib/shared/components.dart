import 'package:flutter/material.dart';

Widget defaultFormField({
  //function
  @required TextEditingController controller,
  TextInputType type,
  Function onSubmit,
  Function onChange,
  Function onTap,
  bool isPassword = false,
  bool isReadOnly = false,
  @required Function validate,
  @required String label,
  @required IconData prefix,
  IconData suffix,
  Function suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      //Widget
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      readOnly: isReadOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        border: OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40.0,
          child: Center(
            child: Text(
                '${model['time']}',
            ),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${model['title']}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${model['date']}',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
