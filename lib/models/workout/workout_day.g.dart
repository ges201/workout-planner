// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_day.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutDayAdapter extends TypeAdapter<WorkoutDay> {
  @override
  final int typeId = 0;

  @override
  WorkoutDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutDay(
      name: fields[0] as String,
      exercises: (fields[2] as List).cast<WorkoutExercise>(),
      date: fields[1] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutDay obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.exercises);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
