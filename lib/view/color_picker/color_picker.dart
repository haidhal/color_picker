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
  List<String> sourceList = [];
  List<String> targetList = [];
  Map<String, bool> matched = {};
  bool showLottie = false;
  int currentLevel = 0;
  List<Map<String, dynamic>> levels = [
    {
      "sourceColors": ["Red", "Green", "Blue", "Yellow"],
      "targetColors": ["Blue", "Yellow", "Red", "Green"],
    },
    {
      "sourceColors": ["Purple", "Orange", "Pink", "Brown"],
      "targetColors": ["Pink", "Orange", "Purple", "Brown"],
    },
    {
      "sourceColors": ["BlueGrey", "Black", "DeepPurple", "DeepOrange"],
      "targetColors": ["DeepPurple", "DeepOrange", "Black", "BlueGrey"]
    }
  ];
  @override
  void initState() {
    loadLevel(currentLevel);
    super.initState();
  }

  void loadLevel(int loadIndex) {
    sourceList = List<String>.from(levels[loadIndex]["sourceColors"]);
    targetList = List<String>.from(levels[loadIndex]["targetColors"]);
    matched.clear();
    setState(() {});
  }

  void levelChecking() {
    if (matched.length == targetList.length &&
        matched.values.every(
          (element) => element,
        )) {
      showLottie = true;
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          showLottie = false;
        });
      });
      //to load next level
      Future.delayed(
        Duration(seconds: 3),
        () {
          if (currentLevel + 1 < levels.length) {
            currentLevel++;

            loadLevel(currentLevel);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.blue,
                content: Text("Congratulations! You have completed")));
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.appbargreen,
        title: Text(
          "Colour Picker",
          style: TextStyle(color: ColorConstants.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 20, right: 15, left: 15),
        child: Column(
          children: [
            Text(
              "Level ${currentLevel + 1}",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            if (showLottie)
              Center(
                child: Lottie.asset(
                  'assets/lottie/Animation - 1724650877591 (1).json',
                  height: screenHeight * 0.2,
                ),
              ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: screenWidth < 300 ? 2 : 1,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 100,
                        crossAxisSpacing: 10),
                    itemCount: sourceList.length,
                    itemBuilder: (context, index) => Draggable(
                      data: sourceList[index],
                      // it displays a feedback widget that tracks the user’s finger across the screen.
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
                        decoration: BoxDecoration(
                          color: getColorByName(sourceList[index]),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            sourceList[index],
                            style: TextStyle(
                              color: ColorConstants.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 200),
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenWidth < 300 ? 2 : 1,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 100,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: targetList.length,
                    itemBuilder: (context, index) {
                      return DragTarget(
                        onAcceptWithDetails: (details) {
                          setState(() {
                            if (details.data == targetList[index]) {
                              matched[details.data.toString()] = true;                             
                             levelChecking();
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                content: Text("Oops! Try again"),
                              ));
                            }
                          });
                        },
                        //A draggable item is added to candidateData if it satisfies the onWillAccept callback condition of the DragTarget.
                        //This data can be used to give feedback indicating the DragTarget will reject the item.
                        builder: (context, candidateData, rejectedData) {
                          return Container(
                            decoration: BoxDecoration(
                              color: matched[targetList[index]] == true
                                  ? getColorByName(targetList[index])
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                targetList[index],
                                style: TextStyle(
                                  color: ColorConstants.white,
                                  fontStyle: FontStyle.italic,
                                ),
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
          ],
        ),
      ),
    );
  }
}

// Function to get colors based on the color names
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
    case "Purple":
      return Colors.purple;
    case "Orange":
      return Colors.orange;
    case "Pink":
      return Colors.pink;
    case "Brown":
      return Colors.brown;
    case "Black":
      return Colors.black;
    case "DeepPurple":
      return Colors.deepPurple;
    case "BlueGrey":
      return Colors.blueGrey;
    case "DeepOrange":
      return Colors.deepOrangeAccent;
    default:
      return Colors.grey;
  }
}
