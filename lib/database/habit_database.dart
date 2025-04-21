import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/app_settings.dart';
import '../models/habit.dart';
class HabitDatabase extends ChangeNotifier{

  static late Isar isar;

  /*

          S E T U P

  */

     //   I N I T I A L I Z E _ D A T A B A S E
      static Future <void> initialize() async {
        final dir = await getApplicationDocumentsDirectory();
        isar = await  Isar.open(
            [HabitSchema, AppSettingsSchema],
            directory: dir.path);
      }
     //   Save first date of app start-up ( heat map )
      Future <void> saveFirstLaunchDate() async {
        final existingSettings = await isar.appSettings.where().findFirst();
        if(existingSettings ==  null){
          final settings = AppSettings()..firstLaunchDate = DateTime.now();
          await isar.writeTxn(() => isar.appSettings.put(settings));
        }
      }

     //   Get first date of app start-up ( for heatmap )
      Future<DateTime?> getFirstLauncgDate () async {
        final settings = await isar.appSettings.where().findFirst();
        return settings?.firstLaunchDate;
      }

     /*

          C R U D  x  O P E R A T I O N S

     */

      //  List of Habits
      final List<Habit> currentHabits = [];

      // C R E A T E - add a new Habit
      Future <void> addHabit(String habitName) async {
  // create a new habit
  final newHabit = Habit()..name = habitName;

  // save to db
  await isar.writeTxn(() => isar.habits.put(newHabit));

  //re-read from db
  readHabits();
}

      // R E A D - read saved habits from DB
      Future<void> readHabits () async {

    // fetch all habits from db
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    // give to currrent habits
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    // update UI
    notifyListeners();

  }

      // U P D A T E - Check habit on & off
      Future<void> updateHabitCompletion(int id, bool isCompleted) async {
        // find the specific habit
        final habit = await isar.habits.get(id);

        // update completion status
        if(habit != null) {
          await isar.writeTxn(() async{
              // if the habit is completed -> add current date to completedDays list
              if(isCompleted&& !habit.completedDays.contains(DateTime.now())){
                // today
                final today = DateTime.now();

                // add the current date if it's not there already in the list
                habit.completedDays.add(
                  DateTime(
                    today.year,
                    today.month,
                    today.day,
                  ),
                );

              }
            // if the habit is completed -> add current date to completedDays list
            else{
              // remove the current date if it is not marked as completed
              habit.completedDays.removeWhere((date) =>
                  date.year == DateTime.now().year &&
                  date.month == DateTime.now().month &&
                  date.day == DateTime.now().day
              );
            }
            // save the updated data to the database
            await isar.habits.put(habit);
            }
          );
        }

        // re-read from db
        readHabits();
      }

      // U P D A T E - edit habit name
      Future<void> updateHabitName(int id, String newName) async{
  // find the specific habit
  final habit = await isar.habits.get(id);

  // update habit name
  if(habit != null){
    // Update name
    await isar.writeTxn(() async{
      habit.name = newName;

      // save updated data to database
      await isar.habits.put(habit);
    });
  }

  // re-read from db
  readHabits();

}

      // D E L E T E - delete habit
      Future <void> deleteHabit(int id) async{
  // Perform the delete
  await isar.writeTxn(() async {
    await isar.habits.delete(id);
  });

  // re-read from db
  readHabits();
}

}