import 'dart:ui';

/// Clase PublicationDTO que representa un objeto de transferencia de datos (DTO) para las publicaciones.
class PublicationDTO {
  int? publicationId;
  int? authorId;
  String? text;
  ImageByteFormat? image;
  DateTime? creationDate;
  DateTime? editionDate;

  /// Constructor de la clase PublicationDTO.
  PublicationDTO({
    this.publicationId,
    this.authorId,
    this.text,
    this.creationDate,
    this.editionDate,
  });

  /// Método que crea un objeto PublicationDTO a partir de un mapa de datos.
  factory PublicationDTO.fromJson(Map<String, dynamic> json) {
    return PublicationDTO(
      publicationId: json['publicationId'],
      authorId: json['authorId'],
      text: json['text'],
      creationDate: DateTime.parse(json['creationDate'] as String),
      editionDate: DateTime.parse(json['editionDate'] as String),
    );
  }

  /// Método que convierte un objeto PublicationDTO a un mapa de datos.
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

        // Puedes imprimir o retornar la fecha formateada según tus necesidades
        print("Fecha formateada: $formattedDate");
        return dateTime;
      } catch (e) {
        print('Error parsing date: $date, $e');
      }
    }
    return null;
  }

  /// Método que convierte un objeto PublicationDTO a un mapa de datos.
  Map<String, dynamic> toJson() {
    return {
      'publicationId': publicationId,
      'authorId': authorId,
      'text': text,
      'creationDate': creationDate?.toIso8601String(),
      'editionDate': editionDate?.toIso8601String(),
    };
  }
}
