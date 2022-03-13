import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget button(
  BuildContext context, {
  onBtnPress,
  String text,
  double hMargin = 2.5,
  double vMargin = 5,
  double radius = 15,
  double height = 0.06,
  double textSize = 17.5,
  double width = double.infinity,
  color,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: hMargin, vertical: vMargin),
    height: MediaQuery.of(context).size.height * height,
    width: width == double.infinity
        ? double.infinity
        : MediaQuery.of(context).size.width * width,
    child: MaterialButton(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child:
          Text(text, style: TextStyle(color: Colors.white, fontSize: textSize)),
      color: color ?? Color(0xFF2B6CB0),
      onPressed: onBtnPress,
    ),
  );
}

Widget textFormField(
  BuildContext context, {
  initialValue,
  validator,
  onChanged,
  String hintText = "",
  double radius = 10,
  double borderWidth = 1.5,
  controller,
  double hMargin = 0,
  double vMargin = 10,
  obscureText = false,
  int maxLength,
  dynamic keyboardType,
}) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.98,
    margin: EdgeInsets.symmetric(horizontal: hMargin, vertical: vMargin),
    child: TextFormField(
      maxLength: maxLength,
      initialValue: initialValue,
      keyboardType:keyboardType ,
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.all(8.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: Colors.blue, width: borderWidth),
        ),
        border: InputBorder.none,
        //  OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(radius),
        //   borderSide: BorderSide(
        //     color: Colors.blue,
        //     width: borderWidth,
        //   ),
        // ),
        filled: true,
        enabledBorder: InputBorder.none,
        // OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(radius),
        //   borderSide: BorderSide(color: Colors.blue, width: borderWidth),
        // ),
      ),
      validator: validator,
      onChanged: onChanged,
    ),
  );
}

Widget textFormFieldBordered(
  BuildContext context, {
  validator,
  onChanged,
  String hintText = "",
  double radius = 10,
  double borderWidth = 1.5,
  controller,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hintText,
      contentPadding: EdgeInsets.all(8.0),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: Colors.blue, width: borderWidth),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: Colors.blue,
          width: borderWidth,
        ),
      ),
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: Colors.blue, width: borderWidth),
      ),
    ),
    validator: validator,
    onChanged: onChanged,
  );
}

Widget questionDisplayTile(
  BuildContext context, {
  question,
  radioOnChanged,
  gVal,
  optionOne,
  optionTwo,
  optionThree,
  optionFour,
}) {
  return Container(
    child: Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5, right: 15),
                  child: Icon(
                    Icons.circle,
                    color: Colors.orange,
                    size: 30,
                  ),
                ),
                Expanded(
                  child: Text(
                    question,
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
          ),
          Container(
            child: Column(
              children: [
                option(context,
                    radioValue: 1,
                    radioGroupValue: gVal,
                    radioOnChanged: radioOnChanged,
                    text: optionOne),
                Divider(),
                option(context,
                    radioValue: 2,
                    radioGroupValue: gVal,
                    radioOnChanged: radioOnChanged,
                    text: optionTwo),
                Divider(),
                option(context,
                    radioValue: 3,
                    radioGroupValue: gVal,
                    radioOnChanged: radioOnChanged,
                    text: optionThree),
                Divider(),
                option(context,
                    radioValue: 4,
                    radioGroupValue: gVal,
                    radioOnChanged: radioOnChanged,
                    text: optionFour),
                Divider(),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget questionDisplayStatsTile(
  BuildContext context, {
  question,
  optionOne,
  optionTwo,
  optionThree,
  optionFour,
  int statValueOne,
  int statValueTwo,
  int statValueThree,
  int statValueFour,
}) {
  return Container(
    child: Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5, right: 15),
                  child: Icon(
                    Icons.circle,
                    color: Colors.orange,
                    size: 30,
                  ),
                ),
                Expanded(
                  child: Text(
                    question,
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
          ),
          Container(
            child: Column(
              children: [
                optionStats(
                  context,
                  text: optionOne,
                  statValue: statValueOne,
                  total: (statValueOne +
                      statValueTwo +
                      statValueThree +
                      statValueFour),
                ),
                Divider(),
                optionStats(
                  context,
                  text: optionTwo,
                  statValue: statValueTwo,
                  total: (statValueOne +
                      statValueTwo +
                      statValueThree +
                      statValueFour),
                ),
                Divider(),
                optionStats(
                  context,
                  text: optionThree,
                  statValue: statValueThree,
                  total: (statValueOne +
                      statValueTwo +
                      statValueThree +
                      statValueFour),
                ),
                Divider(),
                optionStats(
                  context,
                  text: optionFour,
                  statValue: statValueFour,
                  total: (statValueOne +
                      statValueTwo +
                      statValueThree +
                      statValueFour),
                ),
                Divider(),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget optionStats(
  BuildContext context, {
  radioValue,
  radioGroupValue,
  radioOnChanged,
  text,
  int statValue,
  int total,
}) {
  return Container(
    padding: EdgeInsets.only(top: 5, right: 20, left: 20),
    child: Column(
      children: [
        Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: LinearProgressIndicator(
              minHeight: 40,
              value: statValue / total,
              semanticsLabel: "Hello",
              semanticsValue: "Hello",
              backgroundColor: Colors.grey[200],
            ),
          ),
          Positioned(
            top: 5,
            left: 120,
            child: Text(
              "${((statValue / total) * 100).toStringAsFixed(2)} %",
              style: TextStyle(
                  fontFamily: "Raleway",
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.black54),
            ),
          ),
        ]),
        Text(
          text,
          style: TextStyle(
              fontFamily: "Raleway",
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.black54),
        ),
      ],
    ),
  );
}

Widget option(BuildContext context,
    {radioValue, radioGroupValue, radioOnChanged, text}) {
  return Container(
    padding: EdgeInsets.only(top: 5, right: 20),
    child: Row(
      children: [
        Radio(
            value: radioValue,
            groupValue: radioGroupValue,
            onChanged: radioOnChanged),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
                fontFamily: "Raleway",
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.cyan),
          ),
        ),
      ],
    ),
  );
}

Widget editQuestionTile(
  BuildContext context, {
  question,
  optionOne,
  optionTwo,
  optionThree,
  optionFour,
  initialQuestion,
  initialOptionOne,
  initialOptionTwo,
  initialOptionThree,
  initialOptionFour,
  controller1,
  controller2,
  controller3,
  controller4,
  controller5,
}) {
  return Container(
    child: FittedBox(
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            children: [
              textFormField(context,
                  controller: controller1,
                  hintText: "Question",
                  initialValue: initialQuestion,
                  validator: (val) => val.isEmpty ? "Enter Question" : null),
              textFormField(context,
                  controller: controller2,
                  hintText: "option one",
                  initialValue: initialOptionOne,
                  validator: (val) => val.isEmpty ? "Enter Option One" : null),
              textFormField(context,
                  controller: controller3,
                  hintText: "option two",
                  initialValue: initialOptionTwo,
                  validator: (val) => val.isEmpty ? "Enter Option Two" : null),
              textFormField(context,
                  controller: controller4,
                  hintText: "option three",
                  initialValue: initialOptionThree,
                  validator: (val) =>
                      val.isEmpty ? "Enter Option Three" : null),
              textFormField(context,
                  controller: controller5,
                  hintText: "option four",
                  initialValue: initialOptionFour,
                  validator: (val) => val.isEmpty ? "Enter Option Four" : null),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget dialogBox(BuildContext context, {title, content, onPressed, btnText}) {
  return AlertDialog(
    title: new Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    content: Text(content),
    actions: <Widget>[
      // usually buttons at the bottom of the dialog
      new FlatButton(
        child: new Text(btnText),
        onPressed: onPressed,
      ),
    ],
  );
}
Widget loadingButton(
  BuildContext context, {
  onBtnPress,
  String text,
  double hMargin = 2.5,
  double vMargin = 5,
  double radius = 15,
  double height = 0.06,
  double textSize = 17.5,
  double width = double.infinity,
  color,
  bool isLoading,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: hMargin, vertical: vMargin),
    height: MediaQuery.of(context).size.height * height,
    width: width == double.infinity
        ? double.infinity
        : MediaQuery.of(context).size.width * width,
    child: MaterialButton(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child:
           isLoading
                                ? CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  )
                                : Text(text,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: textSize)),
      color: color ?? Color(0xFF2B6CB0),
      onPressed: onBtnPress,
    ),
  );
}