import 'package:chain_app/screens/home/widgets/time_panel/draggable_routine_circle.dart';
import 'package:chain_app/utils/program.dart';
import 'package:chain_app/widgets/drag/drag_state_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimeRoutineList extends StatelessWidget {
  const TimeRoutineList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<DragStateModel>(builder: (context, dragState, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
                Program().routines.length,
                (index) => Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 4),
                      child: DraggableRoutineCircle(
                        hourHeight: dragState.hourHeight,
                        routine: Program().routines[index],
                        dragged: dragState.updateDraggableInfo,
                      ),
                    )),
          ),
        );
      }),
    );
  }
}
