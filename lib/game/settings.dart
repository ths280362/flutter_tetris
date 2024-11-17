import 'package:flutter/material.dart';

import 'package:flutter_tetris/game/shape.dart';

final tetrominoDefs = <String, Shape>{
  'T': Shape(
      blocks: [Pos(0, 0), Pos(0, -1), Pos(0, 1), Pos(-1, 0)],
      color: Colors.purple),
  'O': Shape(
      blocks: [Pos(0, 0), Pos(-1, 0), Pos(0, 1), Pos(-1, 1)],
      color: Colors.yellow),
  'J': Shape(
      blocks: [Pos(0, 0), Pos(-1, 0), Pos(1, 0), Pos(1, -1)],
      color: Colors.blue),
  'L': Shape(
      blocks: [Pos(0, 0), Pos(-1, 0), Pos(1, 0), Pos(1, 1)],
      color: Colors.orange),
  'I': Shape(
      blocks: [Pos(0, 0), Pos(-1, 0), Pos(-2, 0), Pos(1, 0)],
      color: Colors.cyan),
  'S': Shape(
      blocks: [Pos(0, 0), Pos(0, -1), Pos(-1, 0), Pos(-1, 1)],
      color: Colors.green),
  'Z': Shape(
      blocks: [Pos(0, 0), Pos(0, 1), Pos(-1, 0), Pos(-1, -1)],
      color: Colors.red),
};

// final tetrominoDefs = <String, Shape>{
//   'T': Shape(
//       blocks: [Pos(0, 0), Pos(-1, 0), Pos(1, 0), Pos(0, -1)],
//       color: Colors.purple),
//   'O': Shape(
//       blocks: [Pos(0, 0), Pos(0, -1), Pos(1, 0), Pos(1, -1)],
//       color: Colors.yellow),
//   'J': Shape(
//       blocks: [Pos(0, 0), Pos(0, -1), Pos(0, 1), Pos(-1, 1)],
//       color: Colors.blue),
//   'L': Shape(
//       blocks: [Pos(0, 0), Pos(0, -1), Pos(0, 1), Pos(1, 1)],
//       color: Colors.orange),
//   'I': Shape(
//       blocks: [Pos(0, 0), Pos(0, -1), Pos(0, -2), Pos(0, 1)],
//       color: Colors.cyan),
//   'S': Shape(
//       blocks: [Pos(0, 0), Pos(-1, 0), Pos(0, -1), Pos(1, -1)],
//       color: Colors.green),
//   'Z': Shape(
//       blocks: [Pos(0, 0), Pos(1, 0), Pos(0, -1), Pos(-1, -1)],
//       color: Colors.red),
// };

const columnCount = 10;
const rowCount = 20;
const initialDuration = 500;
final startOffset = (columnCount / 2).floor();
