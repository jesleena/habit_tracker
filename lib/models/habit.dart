import 'package:isar/isar.dart';
part 'habit.g.dart';

@Collection()
class Habit {

// habit id
  Id id = Isar.autoIncrement;

// habit name late String name;
  late String name;

// completed days
  List<DateTime> completedDays = [

// DateTime(year, month, day),
// DateTime(2024, 1, 1),
// DateTime(2024, 1, 1),
  ];

}