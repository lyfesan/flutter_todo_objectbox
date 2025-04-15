import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Task extends Equatable {
  @Id()
  int id = 0;

  String title;
  String description;
  bool isCompleted;

  Task({
    this.id = 0,
    required this.title,
    required this.description,
    this.isCompleted = false, // Default value is false
  });

  @override
  List<Object?> get props => [id, title, description, isCompleted];
}