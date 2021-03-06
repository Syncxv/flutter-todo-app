import 'package:appy/config/palette.dart';
import 'package:appy/models/models.dart';
import 'package:appy/util/shared_preferences.dart';
import 'package:appy/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BttomTabBar extends StatelessWidget {
  final leftRightMargin = 35.0;
  final bottomMargin = 15.0;
  final iconSize = 36.0;
  void Function() setTodos;
  BttomTabBar({Key? key, required this.setTodos}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        boxShadow: const [],
        border: Border.all(
          width: 1,
          color: Colors.transparent,
        ), //color is transparent so that it does not blend with the actual color specified
        gradient: const LinearGradient(
          end: Alignment.topCenter,
          begin: Alignment.bottomCenter,
          stops: [0.25, 0.90],
          colors: [
            Colors.white,
            Color.fromRGBO(255, 255, 255, 0.0),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(
              bottom: bottomMargin,
              left: leftRightMargin,
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Icon(
                Icons.folder,
                color: Colors.blue,
                size: iconSize,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(
                  stops: [
                    0.10,
                    0.93,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF16BCFE),
                    Color(0xFFEE4444),
                  ],
                )),
            child: Button(
              icon: Icons.add,
              text: "New Goal",
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => _PopupDialog(setTodos: setTodos),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: bottomMargin,
              right: leftRightMargin,
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Icon(
                Icons.check_circle_outline,
                color: Colors.grey.shade600,
                size: iconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PopupDialog extends StatefulWidget {
  final dynamic setTodos;
  const _PopupDialog({Key? key, required this.setTodos}) : super(key: key);
  @override
  State<_PopupDialog> createState() => _PopupDialogState();
}

class _PopupDialogState extends State<_PopupDialog> {
  @override
  void initState() {
    super.initState();
  }

  Color color = Colors.orange;
  TextEditingController nameController = TextEditingController();
  Widget itemBuilder(
      Color color, bool isCurrentColor, void Function() changeColor) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(4.0),
      margin: const EdgeInsets.all(7),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.8),
              offset: const Offset(1, 2),
              blurRadius: 5,
            )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: changeColor,
            borderRadius: BorderRadius.circular(50),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 210),
              opacity: isCurrentColor ? 1 : 0,
              child: Icon(
                Icons.done,
                color: useWhiteForeground(color) ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget layoutBuilder(
      BuildContext context, List<Color> colors, PickerItem child) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 4.0,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (BuildContext context, int index) {
          return child(colors[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.fromLTRB(0, 45, 0, 0),
      child: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: 200,
                color: color,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Stack(
                    children: [
                      const Positioned(
                        right: 0,
                        child: WhatCloseButton(),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: TextField(
                          controller: nameController,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: useWhiteForeground(color)
                                ? Colors.white
                                : Colors.black,
                            fontSize: 20.0,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: useWhiteForeground(color)
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 20.0,
                            ),
                            hintText: 'Name of todo :|',
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: BlockPicker(
                pickerColor: color,
                availableColors: availableColors,
                onColorChanged: (color) => setState(() => this.color = color),
                layoutBuilder: layoutBuilder,
                itemBuilder: itemBuilder,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                      stops: [
                        0.10,
                        0.93,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF16E3FE),
                        Color(0xFF44B0EE),
                      ],
                    )),
                child: Button(
                  text: "Create Goal",
                  onPressed: () async {
                    if (nameController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "Enter a name :|",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 24.0,
                      );
                      return;
                    }
                    final List<TodoSection> realTodoArry = await getTodos();
                    print(realTodoArry);
                    final todo = TodoSection(
                      id: realTodoArry.length + 1,
                      dateCreated: DateTime.now(),
                      color: color,
                      name: nameController.text,
                      todoItems: [],
                    );
                    realTodoArry.addAll([todo]);
                    final String encodedData = TodoSection.encode(realTodoArry);
                    await saveTodos(encodedData);
                    widget.setTodos();
                    Navigator.of(context).pop('dialog');
                    // await clearTodos();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
