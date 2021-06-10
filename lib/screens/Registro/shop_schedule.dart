import 'package:flutter/material.dart';

final week = const [
  "Lunes",
  "Martes",
  "Miercoles",
  "Jueves",
  "Viernes",
  "Sabado",
  "Domingo",
];

class ShopSchedule extends StatefulWidget {
  final BoxConstraints constraints;
  final void Function(List<String>) onChange;

  const ShopSchedule({
    Key key,
    @required this.constraints,
    @required this.onChange,
  }) : super(key: key);

  @override
  _ShopScheduleState createState() => _ShopScheduleState();
}

class _ShopScheduleState extends State<ShopSchedule> {
  int count = 1;
  List<String> schedules = [""];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30.0),
        Text(
          "Horario de atención",
          style: TextStyle(fontSize: 17.0),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: count,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(bottom: 15.0),
              color: Colors.white70,
              elevation: 24.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: ScheduleItem(
                  constraints: widget.constraints,
                  onChange: (val) {
                    schedules[index] = val;
                    widget.onChange(schedules);
                  },
                ),
              ),
            );
          },
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                count++;
                schedules.add("");
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add),
                SizedBox(width: 10.0),
                Text("Agregar horario"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ScheduleItem extends StatefulWidget {
  final BoxConstraints constraints;
  final void Function(String) onChange;

  const ScheduleItem({
    Key key,
    @required this.constraints,
    @required this.onChange,
  }) : super(key: key);

  @override
  _ScheduleItemState createState() => _ScheduleItemState();
}

class _ScheduleItemState extends State<ScheduleItem> {
  String first = week[0];
  String second = week[0];
  String time1;
  String time2;
  String schedule;
  BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    constraints = widget.constraints;
    final children = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DaySelector(
            label: "De:",
            start: first,
            onChange: (val) {
              setState(() {
                first = val;
                updateSchedule();
              });
            },
          ),
          DaySelector(
            label: "A:",
            start: second,
            onChange: (val) {
              setState(() {
                second = val;
                updateSchedule();
              });
            },
          ),
        ],
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 2.0, color: Colors.black)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.access_time),
            SizedBox(width: 10.0),
            HourPicker(
              onChange: (val) {
                setState(() {
                  time1 = val;
                  updateSchedule();
                });
              },
            ),
            Icon(Icons.remove),
            HourPicker(
              onChange: (val) {
                setState(() {
                  time2 = val;
                  updateSchedule();
                });
              },
            ),
          ],
        ),
      )
    ];
    if (constraints.maxWidth > 1320)
      return Row(
        children: children,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      );
    else if (constraints.maxWidth > 800)
      return Column(
        children: children,
        mainAxisAlignment: MainAxisAlignment.start,
      );
    else if (constraints.maxWidth > 700)
      return Row(
        children: children,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      );
    else
      return Column(
        children: children,
        mainAxisAlignment: MainAxisAlignment.start,
      );
  }

  void updateSchedule() {
    schedule = "$first-$second $time1-$time2";
    widget.onChange(schedule);
  }
}

class DaySelector extends StatefulWidget {
  final String start;
  final String label;
  final void Function(String) onChange;

  DaySelector({
    Key key,
    @required this.label,
    this.start,
    @required this.onChange,
  }) : super(key: key);

  @override
  _DaySelectorState createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  String day;

  @override
  Widget build(BuildContext context) {
    day = widget.start;
    return SizedBox(
      width: 125.0,
      child: DropdownButtonFormField<String>(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (val) => (val != null) ? null : "Selecciona un dia de la semana",
        value: day,
        style: Theme.of(context).textTheme.bodyText1,
        elevation: 10,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.calendar_today),
          labelText: widget.label,
          errorStyle: TextStyle(color: Colors.red),
          enabledBorder: InputBorder.none,
        ),
        items: week
            .map((e) => DropdownMenuItem<String>(
                  child: Text(e),
                  value: e,
                ))
            .toList(),
        onChanged: (val) {
          setState(() {
            day = val;
            widget.onChange(val);
          });
        },
      ),
    );
  }
}

class HourPicker extends StatefulWidget {
  final void Function(String) onChange;

  HourPicker({
    Key key,
    @required this.onChange,
  }) : super(key: key);

  @override
  _HourPickerState createState() => _HourPickerState();
}

class _HourPickerState extends State<HourPicker> {
  TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _timeController.text = "08:00 AM";
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70.0,
      child: InkWell(
        onTap: pickTime,
        child: TextField(
          textAlign: TextAlign.center,
          enabled: false,
          controller: _timeController,
          decoration: InputDecoration(
            disabledBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }

  void pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 8, minute: 0),
    );
    if (time != null) {
      final hour = "${(time.hourOfPeriod > 9) ? "" : "0"}${time.hourOfPeriod}";
      final minutes = "${(time.minute > 9) ? "" : "0"}${time.minute}";
      final period = "${(time.period.index == 0) ? "AM" : "PM"}";
      setState(() {
        final timeFormat = "$hour:$minutes $period";
        _timeController.text = timeFormat;
        widget.onChange(timeFormat);
      });
    }
  }
}
