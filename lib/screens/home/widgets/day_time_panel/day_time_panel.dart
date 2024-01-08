import 'package:chain_app/constants/app_theme.dart';
import 'package:chain_app/services/local_service.dart';
import 'package:chain_app/utils/date_util.dart';
import 'package:chain_app/widgets/app_button.dart';
import 'package:chain_app/widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';

class DayTimePanel extends StatefulWidget {
  const DayTimePanel({
    Key? key,
    required this.sleepTime,
    required this.wakeTime,
    required this.onUpdate,
  }) : super(key: key);

  final Duration sleepTime;
  final Duration wakeTime;
  final Function(Duration sleepTime, Duration wakeTime) onUpdate;

  @override
  State<DayTimePanel> createState() => _DayTimePanelState();
}

class _DayTimePanelState extends State<DayTimePanel> {
  late RangeValues _currentRangeValues;
  final double max = 40;
  final double min = 16;
  final Duration minDuration = const Duration(hours: 5);
  final Duration maxDuration = const Duration(hours: 27);
  late List<Duration> defaultDayTimeDurations;
  bool isDefault = false;

  @override
  void initState() {
    super.initState();

    _currentRangeValues = RangeValues(
        (widget.wakeTime.inMinutes - minDuration.inMinutes) / 30,
        max - (maxDuration.inMinutes - widget.sleepTime.inMinutes) / 30);

    defaultDayTimeDurations = LocalService().loadDayTime();
    calculateDefaultOption();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.dark700,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _getPanelHeader(context),
                  const SizedBox(height: 8),
                  _getTimeSlider(),
                  const SizedBox(height: 16),
                  _getTimeLabels(),
                  const SizedBox(height: 16),
                  CustomCheckbox(
                    text: "Save as a default.",
                    change: (isDefault) {
                      if (isDefault == null) {
                        return;
                      }

                      setState(() {
                        this.isDefault = isDefault;
                      });
                    },
                    isChecked: isDefault,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                      label: "Save",
                      onPressed: () {
                        Duration wakeTime = Duration(
                            minutes: minDuration.inMinutes +
                                _currentRangeValues.start.toInt() * 30);
                        Duration sleepTime = Duration(
                            minutes: maxDuration.inMinutes -
                                ((max.toInt() -
                                        _currentRangeValues.end.toInt())) *
                                    30);
                        if (isDefault) {
                          LocalService().saveDayTime(wakeTime, sleepTime);
                        }
                        widget.onUpdate(sleepTime, wakeTime);
                        Navigator.of(context).pop();
                      }),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getPanelHeader(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        color: AppColors.dark600,
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Text(
            "Set Your Day ",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Expanded(child: SizedBox()),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(
                Icons.close_outlined,
                color: AppColors.dark300,
                size: 36,
              ),
            ),
          ),
          SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _getTimeSlider() {
    return RangeSlider(
      values: _currentRangeValues,
      max: max,
      min: 0,
      divisions: max.round(),
      onChangeEnd: (RangeValues rangeValues) {
        double start = rangeValues.start;
        double end = rangeValues.end;
        if (start > min) {
          start = min;
        }
        if (end < max - min) {
          end = max - min;
        }

        if (start != rangeValues.start || end != rangeValues.end) {
          setState(() {
            _currentRangeValues = RangeValues(start, end);
          });
        }
      },
      labels: RangeLabels(
        DateUtil.getDurationText(Duration(
            minutes: minDuration.inMinutes +
                _currentRangeValues.start.round() * 30)),
        DateUtil.getDurationText(Duration(
            minutes: (maxDuration.inMinutes -
                (max.round() - _currentRangeValues.end.round()) * 30))),
      ),
      onChanged: (RangeValues values) {
        calculateDefaultOption();
        setState(() {
          _currentRangeValues = values;
        });
      },
    );
  }

  Widget _getTimeLabels() {
    Duration minDuration = const Duration(hours: 5);
    Duration maxDuration = const Duration(hours: 27);
    double max = 40;
    TextStyle labelStyle = Theme.of(context).textTheme.titleMedium!;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Wake Up:",
                  style: labelStyle,
                ),
                Text(
                  "Sleep:",
                  style: labelStyle,
                )
              ],
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                DateUtil.getDurationText(Duration(
                    minutes: minDuration.inMinutes +
                        _currentRangeValues.start.round() * 30)),
                style: labelStyle.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 4),
              Text(
                DateUtil.getDurationText(Duration(
                    minutes: maxDuration.inMinutes -
                        (max.round() - _currentRangeValues.end.round()) * 30)),
                style: labelStyle.copyWith(color: AppColors.primary),
              )
            ]),
          ],
        ));
  }

  void calculateDefaultOption() {
    isDefault =
        widget.wakeTime.inMinutes == defaultDayTimeDurations[0].inMinutes &&
            widget.sleepTime.inMinutes == defaultDayTimeDurations[1].inMinutes;
  }
}
