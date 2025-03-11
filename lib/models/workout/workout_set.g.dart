// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_set.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutSetAdapter extends TypeAdapter<WorkoutSet> {
  @override
  final int typeId = 2;

  @override
  WorkoutSet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutSet(
      weight: fields[0] as double,
      minReps: fields[1] as int,
      maxReps: fields[2] as int,
      isRepRange: fields[3] as bool,
      minRestSeconds: fields[4] as int,
      maxRestSeconds: fields[5] as int,
      isRestRange: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutSet obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.weight)
      ..writeByte(1)
      ..write(obj.minReps)
      ..writeByte(2)
      ..write(obj.maxReps)
      ..writeByte(3)
      ..write(obj.isRepRange)
      ..writeByte(4)
      ..write(obj.minRestSeconds)
      ..writeByte(5)
      ..write(obj.maxRestSeconds)
      ..writeByte(6)
      ..write(obj.isRestRange);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutSetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
