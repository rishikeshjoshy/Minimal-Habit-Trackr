import 'package:isar/isar.dart';


part 'habit.g.dart';

// run cmd to generate file: dart run build_runner build
@Collection()
class Habit{

  // Habit ID
  Id id = Isar.autoIncrement;


  // Habit name
  late String name;


  // Completed days
  List<DateTime> completedDays = [
    //DateTime(Y,M,D),
    //DateTime(2024,1,1),
    //DateTime(2024,1,2),
  ];


}