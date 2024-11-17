import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:flutter_tetris/game/box.dart';
import 'package:flutter_tetris/game/settings.dart';
import 'package:flutter_tetris/game/shape.dart';
import 'package:flutter_tetris/styles.dart';

class TetrisBoard extends StatefulWidget {
  const TetrisBoard({super.key});

  @override
  State<TetrisBoard> createState() => _TetrisBoardState();
}

class _TetrisBoardState extends State<TetrisBoard> {
  int lines = 0;
  int score = 0;
  int level = 1;

  List<int> scoreFactores = [40, 100, 300, 1200];

  bool gameOver = false;

  late List<List<Color?>> board;
  late Shape currentShape;

  @override
  void initState() {
    super.initState();
    board = emptyBoard();
    currentShape = Shape.random();
    ServicesBinding.instance.keyboard.addHandler(keyHandler);
    startGame();
  }

  @override
  void dispose() {
    ServicesBinding.instance.keyboard.removeHandler(keyHandler);
    super.dispose();
  }

  List<List<Color?>> emptyBoard() {
    return List.generate(
      rowCount,
      (i) => List.generate(columnCount, (i) => null),
    );
  }

  void startGame() {
    Duration frameRate = const Duration(milliseconds: 500);
    gameLoop(frameRate);
  }

  bool isGameOver() {
    for (int i = 0; i < columnCount; i++) {
      if (board[0][i] != null) {
        return true;
      }
    }
    return false;
  }

  void showGameOver() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 51, 49, 44),
        content: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: const Text(
            "Game Over",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                resetGame();
              },
              child: const Text("Play Again"))
        ],
      ),
    );
  }

  void resetGame() {
    board = emptyBoard();
    gameOver = false;
    score = 0;
    currentShape = Shape.random();
    startGame();
  }

  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      checkLanding();
      if (gameOver) {
        timer.cancel();
        showGameOver();
      }
      setState(() {
        currentShape.move(Direction.down);
      });
    });
  }

  void checkLanding() {
    if (currentShape.collesion(Direction.down, board)) {
      for (var block in currentShape.blocks) {
        if (block.row >= 0 && block.col >= 0) {
          board[block.row][block.col] = currentShape.color;
        }
      }
      var lineCount = removeCompletedRows();
      if (lineCount > 0) {
        lines += lineCount;
        score += lineCount * scoreFactores[lineCount - 1];
        var newLevel = (lineCount / 10).floor() + 1;
        if (newLevel > level) {
          level = newLevel;
          // ToDo: Increase speed
        }
      }
      currentShape = Shape.random();
      gameOver = isGameOver();
    }
  }

  int removeCompletedRows() {
    List<int> removedLines = [];
    for (int i = 0; i < rowCount; i++) {
      if (board[i].any((item) => item == null)) {
        continue;
      }
      removedLines.add(i);
      for (int j = i; j > 0; j--) {
        board[j] = board[j - 1];
      }
      board[0] = List.generate(columnCount, (i) => null);
    }
    debugPrint(removedLines.toString());
    return removedLines.length;
  }

  double calcGridWidth(width, height) {
    var cellDimension = height / rowCount;
    var maxWidth = cellDimension * 10;
    if (maxWidth < width) {
      return maxWidth;
    } else {
      return width;
    }
  }

  void moveLeft() {
    if (!currentShape.collesion(Direction.left, board)) {
      setState(() {
        currentShape.move(Direction.left);
      });
    }
  }

  void moveRight() {
    if (!currentShape.collesion(Direction.right, board)) {
      setState(() {
        currentShape.move(Direction.right);
      });
    }
  }

  void moveDown() {
    if (!currentShape.collesion(Direction.down, board)) {
      setState(() {
        currentShape.move(Direction.down);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Lines: $lines', style: scoreTextStyle),
                    Text('Score: $score', style: scoreTextStyle),
                    Text('Level: $level', style: scoreTextStyle),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: calcGridWidth(
                        constraints.maxWidth - 40, constraints.maxHeight - 200),
                    child: GridView.builder(
                      itemCount: columnCount * rowCount,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columnCount,
                      ),
                      itemBuilder: (context, index) {
                        int row = (index / columnCount).floor();
                        int col = index % columnCount;
                        if (currentShape.include(row, col)) {
                          return Box(color: currentShape.color);
                        }
                        if (board[row][col] != null) {
                          return Box(color: board[row][col]!);
                        }
                        return (Box(color: Colors.black87));
                      },
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 80,
                      child: ElevatedButton(
                          style: buttonStyle,
                          onPressed: moveLeft,
                          child: const Icon(Icons.keyboard_arrow_left)),
                    ),
                    SizedBox(
                      height: 60,
                      width: 80,
                      child: ElevatedButton(
                          style: buttonStyle,
                          onPressed: moveDown,
                          child: const Icon(Icons.arrow_downward)),
                    ),
                    SizedBox(
                      height: 60,
                      width: 80,
                      child: ElevatedButton(
                          style: buttonStyle,
                          onPressed: rotate,
                          child: const Icon(Icons.rotate_right)),
                    ),
                    SizedBox(
                      height: 60,
                      width: 80,
                      child: ElevatedButton(
                          style: buttonStyle,
                          onPressed: moveRight,
                          child: const Icon(Icons.keyboard_arrow_right)),
                    ),
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  void rotate() {
    setState(() {
      currentShape.rotate(board);
    });
  }

  void down() {
    setState(() {
      currentShape = Shape.random(offset: Pos(5, 5));
    });
  }

  bool keyHandler(KeyEvent event) {
    final key = event.logicalKey.keyLabel;
    if (event is KeyUpEvent) {
      switch (key) {
        case 'Arrow Left':
          moveLeft();
          break;
        case 'Arrow Right':
          moveRight();
          break;
        case 'Arrow Up':
          rotate();
          break;
        case 'Arrow Down':
          moveDown();
          break;
        default:
          break;
      }
    }
    return false;
  }
}
