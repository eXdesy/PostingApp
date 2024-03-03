import 'package:flutter/foundation.dart';

/// Clase que representa un comentario en la base de datos.
class CommentDTO {
  int? userId;
  int? publicationId;
  DateTime? creationDate;
  String? text;
  List<int>? image;

  CommentDTO(
      {this.userId,
      this.publicationId,
      this.text,
      this.creationDate,
      this.image});

  /// Método que crea un objeto CommentDTO a partir de un mapa de datos.
  factory CommentDTO.fromJson(Map<String, dynamic> json) {
    return CommentDTO(
      userId: json['userId'],
      publicationId: json['publicationId'],
      creationDate: DateTime.parse(json['creationDate'] as String),
      text: json['text'],
      image: json['image'] != null ? List<int>.from(json['image']) : null,
    );
  }

  /// Método que parsea una fecha en formato JSON a un objeto DateTime.
  static DateTime? parseDate(dynamic date) {
    if (date is List<dynamic> && date.length == 7) {
      try {
        int year = date[0];
        int month = date[1];
        int day = date[2];
        int hour = date[3];
        int minute = date[4];
        int second = date[5];
        int millisecond = date[6] % 1000;

        // Crear un objeto DateTime
        DateTime dateTime = DateTime(
          year,
          month,
          day,
          hour + 1,
          minute,
          second,
          millisecond ~/ 1000,
        ).add(Duration(milliseconds: millisecond));

        // Formatear la fecha en el formato deseado
        String formattedDate =
            "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

        if (kDebugMode) {
          print("Fecha formateada: $formattedDate");
        }
        return dateTime;
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing date: $date, $e');
        }
      }
    }
    return null;
  }

  /// Método que convierte un objeto CommentDTO a un mapa de datos.
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'publicationId': publicationId,
      'creationDate': creationDate?.toIso8601String(),
      'text': text,
      'image': image,
    };
  }
}
