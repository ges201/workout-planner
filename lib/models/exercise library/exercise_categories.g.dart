// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_categories.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseCategoryAdapter extends TypeAdapter<ExerciseCategory> {
  @override
  final int typeId = 3;

  @override
  ExerciseCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExerciseCategory.freeWeights;
      case 1:
        return ExerciseCategory.machine;
      case 2:
        return ExerciseCategory.cables;
      case 3:
        return ExerciseCategory.freeBody;
      default:
        return ExerciseCategory.freeWeights;
    }
  }

  @override
  void write(BinaryWriter writer, ExerciseCategory obj) {
    switch (obj) {
      case ExerciseCategory.freeWeights:
        writer.writeByte(0);
        break;
      case ExerciseCategory.machine:
        writer.writeByte(1);
        break;
      case ExerciseCategory.cables:
        writer.writeByte(2);
        break;
      case ExerciseCategory.freeBody:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
