// ignore_for_file: prefer_const_constructors

import 'package:color_picker/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({super.key});

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  List<String> sourceList = ["Red", "Green", "Blue", "Yellow"];
  List<String> targetList = ["Blue", "Yellow", "Red", "Green"];
  Map<String, bool> matched = {};
  bool showLottie = false;

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.appbargreen,
        title: Text(
          "Colour Picker",
          style: TextStyle(color: ColorConstants.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 10,
                ),
                itemCount: sourceList.length,
                itemBuilder: (context, index) => Draggable(
                  data: sourceList[index],               
                  // feedback widget that tracks the users finger across the screen
                  feedback: Opacity(
                    opacity: 0.7,
                    child: Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                          color: getColorByName(sourceList[index]),
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          sourceList[index],
                          style: TextStyle(
                            fontSize: 15,
                            color: ColorConstants.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  child: Container(
                    color: getColorByName(sourceList[index].toString()),
                    child: Center(
                      child: Text(
                        sourceList[index],
                        style: TextStyle(
                            color: ColorConstants.white,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
                width: 250,
                child: showLottie
                    ? Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: Lottie.asset(
                            'assets/lottie/Animation - 1724650877591 (1).json',
                          ),
                        ),
                      )
                    : SizedBox.shrink()),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, mainAxisSpacing: 10),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return DragTarget(
                    onAcceptWithDetails: (
                      details,
                    ) {
                      setState(() {
                        if (details.data == targetList[index]) {
                          matched[details.data.toString()] = true;
                          showLottie = true;

                          Future.delayed(Duration(seconds: 2), () {
                            setState(() {
                              showLottie = false;
                            });
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                "Oops! try again",
                              )));
                        }
                      });
                    },
                    //candidateData: The list of items currently being dragged over the target and considered for acceptance.
                    //rejectedData: The list of items that were rejected by the target.
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        color: matched[targetList[index]] == true
                            ? getColorByName(targetList[index])
                            : Colors.grey,
                        child: Center(
                          child: Text(
                            targetList[index],
                            style: TextStyle(
                                color: ColorConstants.white,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// function to get colors based on the colorNames
Color getColorByName(String colorName) {
  switch (colorName) {
    case "Red":
      return Colors.red;
    case "Blue":
      return Colors.blue;
    case "Green":
      return Colors.green;
    case "Yellow":
      return Colors.yellow;
    default:
      return Colors.grey;
  }
}

