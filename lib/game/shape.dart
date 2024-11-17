import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_tetris/game/settings.dart';

enum Direction { left, right, down, none }

class Pos {
  int row;
  int col;
  Pos(
    this.row,
    this.col,
  );
}

class Shape {
  Color color;
  List<Pos> blocks;
  String type = '';

  Shape({
    required this.color,
    required this.blocks,
    type,
  });

  Shape copy() {
    List<Pos> copiedBlocks = [];
    for (var block in blocks) {
      copiedBlocks.add(Pos(block.row, block.col));
    }
    return Shape(color: color, blocks: copiedBlocks, type: type);
  }

  @override
  String toString() {
    var result = '$type $color';
    for (var block in blocks) {
      result += ' (${block.row} ${block.col})';
    }
    return result;
  }

  static Shape random({Pos? offset}) {
    var type = tetrominoDefs.keys
        .toList()[Random().nextInt(tetrominoDefs.keys.length)];
    var def = (tetrominoDefs[type])!;
    var shape = Shape(
        color: def.color,
        blocks: List.generate(def.blocks.length,
            (i) => Pos(def.blocks[i].row, def.blocks[i].col)));
    shape.type = type;
    var pos = offset ?? Pos(0, startOffset);
    for (var block in shape.blocks) {
      block.row += pos.row;
      block.col += pos.col;
    }
    return shape;
  }

  static Shape special(String type, {Pos? offset}) {
    var def = (tetrominoDefs[type])!;
    var shape = Shape(
        color: def.color,
        blocks: List.generate(def.blocks.length,
            (i) => Pos(def.blocks[i].row, def.blocks[i].col)));
    shape.type = type;
    var pos = offset ?? Pos(startOffset, 0);
    for (var block in shape.blocks) {
      block.row += pos.row;
      block.col += pos.col;
    }
    return shape;
  }

  void rotate(List<List<Color?>> board) {
    if (type != 'O') {
      List<Pos> copiedBlocks = [];
      for (var block in blocks) {
        copiedBlocks.add(Pos(block.row, block.col));
      }
      for (int i = 1; i < copiedBlocks.length; i++) {
        int dy = copiedBlocks[i].row - copiedBlocks[0].row;
        int dx = copiedBlocks[i].col - copiedBlocks[0].col;
        copiedBlocks[i].row = copiedBlocks[0].row + dx;
        copiedBlocks[i].col = copiedBlocks[0].col - dy;
        if (copiedBlocks[i].col < 0 ||
            copiedBlocks[i].col >= columnCount ||
            copiedBlocks[i].row >= rowCount) {
          return;
        }
        if (copiedBlocks[i].row >= 0 &&
            board[copiedBlocks[i].row][copiedBlocks[i].col] != null) {
          return;
        }
      }
      blocks = copiedBlocks;
    }
  }

  bool include(int x, int y) {
    for (var block in blocks) {
      if (block.row == x && block.col == y) {
        return true;
      }
    }
    return false;
  }

  void move(Direction direction) {
    for (var block in blocks) {
      switch (direction) {
        case Direction.left:
          block.col -= 1;
          break;
        case Direction.right:
          block.col += 1;
          break;
        case Direction.down:
          block.row += 1;
          break;
        default:
      }
    }
  }

  bool collesion(Direction direction, List<List<Color?>> board) {
    for (var block in blocks) {
      int row = block.row;
      int col = block.col;
      switch (direction) {
        case Direction.left:
          col--;
          break;
        case Direction.right:
          col++;
          break;
        case Direction.down:
          row++;
          break;
        default:
          break;
      }
      if (col < 0 || col >= columnCount || row >= rowCount) {
        return true;
      }
      if (row >= 0 && board[row][col] != null) {
        return true;
      }
    }
    return false;
  }
}
