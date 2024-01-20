// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/app_settings.dart';
import '../models/habit.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  ///INITIALIZE-DATABASE
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

  /// Save first date of app startup (for heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  /// Get first date of app startup (for heatmap)
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  ///list of habits
  final List<Habit> currentHabits = [];

  ///CREATE  add a new habit
  Future<void> addHabit(String habitName) async {
// create a new habit
    final newHabit = Habit()..name = habitName;
// save to db
    await isar.writeTxn(() => isar.habits.put(newHabit));

// re-read from db
    readHabits();
  }

  ///READ- read saved habits from db
  Future<void> readHabits() async {
// fetch all habits from db
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

// give to current habits
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    /// update UI
    notifyListeners();
  }

  ///UPDATE check habit on and off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
// find the specific habit
    final habit = await isar.habits.get(id);

// update completion status
    if (habit != null) {
      await isar.writeTxn(() async {
        //if habit complete-add current date to completeddDays list
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          final today = DateTime.now(); //today
// add the current date if it's not already in the list
          habit.completedDays.add(
            DateTime(
              today.year,
              today.month,
              today.day,
            ),
          );
        }

// if habit is NOT completed -> remove the current date from the list
        else {
// remove the current date if the habit is marked as not completed
          habit.completedDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }
// save the updated habits back to the db
        await isar.habits.put(habit);
      });
//read from db
      readHabits();
    }
  }

  ///UPDATE ---edit habit name

  Future<void> updateHabitname(int id, String newName) async {
// find the specific habit
    final habit = await isar.habits.get(id);
// update habit name
    if (habit != null) {
// update name
      await isar.writeTxn(() async {
        habit.name = newName;
// save updated habit back to the db
        await isar.habits.put(habit);
      });
    }
// re-read from db
    readHabits();
  }

//DELETE delete habit
  Future<void> deleteHabit(int id) async {
// perform the delete
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    // re-read from db
    readHabits();
  }
}
