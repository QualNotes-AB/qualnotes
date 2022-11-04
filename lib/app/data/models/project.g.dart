// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectAdapter extends TypeAdapter<Project> {
  @override
  final int typeId = 1;

  @override
  Project read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Project(
      id: fields[0] as String?,
      title: fields[1] as String?,
      description: fields[2] as String?,
      totalTime: fields[3] as int?,
      type: fields[4] as String?,
      author: fields[5] as String?,
      date: fields[6] as DateTime?,
      distance: fields[7] as double?,
      notes: (fields[8] as List?)?.cast<Note>(),
      routePoints: (fields[9] as List?)?.cast<Coordinate>(),
      routeVideos: (fields[10] as List?)?.cast<String>(),
      routeAudios: (fields[11] as List?)?.cast<String>(),
      consents: (fields[12] as List?)?.cast<String>(),
      routeVideosLength: fields[13] as int?,
      routeAudiosLength: fields[14] as int?,
      consentsLength: fields[15] as int?,
      collaborators: (fields[16] as List?)?.cast<String>(),
      reflectionNotes: (fields[17] as List?)?.cast<Note>(),
      authorId: fields[18] as String?,
      isUploaded: fields[19] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Project obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.totalTime)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.author)
      ..writeByte(6)
      ..write(obj.date)
      ..writeByte(7)
      ..write(obj.distance)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.routePoints)
      ..writeByte(10)
      ..write(obj.routeVideos)
      ..writeByte(11)
      ..write(obj.routeAudios)
      ..writeByte(12)
      ..write(obj.consents)
      ..writeByte(13)
      ..write(obj.routeVideosLength)
      ..writeByte(14)
      ..write(obj.routeAudiosLength)
      ..writeByte(15)
      ..write(obj.consentsLength)
      ..writeByte(16)
      ..write(obj.collaborators)
      ..writeByte(17)
      ..write(obj.reflectionNotes)
      ..writeByte(18)
      ..write(obj.authorId)
      ..writeByte(19)
      ..write(obj.isUploaded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
