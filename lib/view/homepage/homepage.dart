import 'package:flutter/material.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:habit_tracker/view/homepage/components/my_habit_tile.dart';
import 'package:habit_tracker/view/homepage/components/my_heat_map.dart';
import 'package:habit_tracker/view/homepage/components/mydrawer.dart';
import 'package:provider/provider.dart';

import '../../models/habit.dart';
import '../../utils/habit_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

//create new habit
  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              content: TextField(
                controller: textController,
                decoration: const InputDecoration(hintText: "Create a new habit"),
              ),
              actions: [
                //save button
                MaterialButton(
                  onPressed: () {
                    String newHabitName = textController.text;
                    //save to db
                    context.read<HabitDatabase>().addHabit(newHabitName);
                    //pop box
                    Navigator.pop(context);
                    //clear controller
                    textController.clear();
                  },
                  child: const Text("Save"),
                ),
                //cancel button

                MaterialButton(
                  onPressed: () {
                    //pop box
                    Navigator.pop(context);
                    //clear controller
                    textController.clear();
                  },
                  child: const Text("Cancel"),
                ),
              ],
            ));
  }

  // to check habit on or off
  void checkHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  //edit habit box
  void editHabitBox(Habit habit) {
    //set the controller's text to the habit's current name
    textController.text = habit.name;
    showDialog(context: context,
        builder: (context) =>
            AlertDialog(
              content: TextField(controller: textController,), actions: [
              //save button
              MaterialButton(
                onPressed: () {
                  String newHabitName = textController.text;
                  //save to db
                  context.read<HabitDatabase>().updateHabitname(
                      habit.id, newHabitName);
                  //pop box
                  Navigator.pop(context);
                  //clear controller
                  textController.clear();
                },
                child: const Text("Save"),
              ),
              //cancel button

              MaterialButton(
                onPressed: () {
                  //pop box
                  Navigator.pop(context);
                  //clear controller
                  textController.clear();
                },
                child: const Text("Cancel"),
              ),
            ],));
  }

  //delete habit box
  void deleteHabitBox(Habit habit) {
    showDialog(context: context,
        builder: (context) =>
            AlertDialog(title: const Text("Are you sure you want to delete"),
              actions: [
                //delete button
                MaterialButton(
                  onPressed: () {
                    //save to db
                    context.read<HabitDatabase>().deleteHabit(habit.id);
                    //pop box
                    Navigator.pop(context);
                  },
                  child: const Text("Delete"),
                ),
                //cancel button

                MaterialButton(
                  onPressed: () {
                    //pop box
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ],));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
        ),
        drawer: const MyDrawers(),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewHabit,
          elevation: 0,
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .tertiary,
          child: const Icon(Icons.add,color: Colors.black,),
        ),
        body: ListView(
          children: [
            //HEAT MAP
            _buildHeatMap(),
            
            //HABITLIST
            _buildHabitList(),
          ],
        )

    );
  }

  // build habit list

  Widget _buildHabitList() {
// habit db
    final habitDatabase = context.watch<HabitDatabase>();

// current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

// return list of habits UI
    return ListView.builder(
        itemCount: currentHabits.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
// get each individual habit
          final habit = currentHabits[index];

// check if the habit is completed today
          bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

// return habit tileUI
          return MyHabitTile(
            text: habit.name,
            isCompleted: isCompletedToday,
            onChanged: (value) => checkHabitOnOff(value, habit),
            editHabit: (context) => editHabitBox(habit),
            deleteHabit: (context) => deleteHabitBox(habit),);
        });
  }

  Widget _buildHeatMap() {
    // habit db
    final habitDatabase = context.watch<HabitDatabase>();

// current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

// return heatMap UI
    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyHeatMap(datasets: prepHeatMapDataset(currentHabits),
              startDate: snapshot.data!);
        }
        else{ return Container();}
      },
    );
  }
}
