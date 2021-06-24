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
  final List<String> data;
  final bool enable;

  const ShopSchedule({
    Key key,
    @required this.constraints,
    @required this.onChange,
    this.data,
    this.enable = true,
  }) : super(key: key);

  @override
  _ShopScheduleState createState() => _ShopScheduleState();
}

class _ShopScheduleState extends State<ShopSchedule> {
  int count;
  List<String> schedules;
  @override
  void initState() {
    schedules = widget.data ?? [""];
    count = schedules.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Horario de atención:",
          style: TextStyle(
            fontSize: 25.0,
            fontFamily: "Itim",
          ),
        ),
        SizedBox(height: 20.0),
        ListView.builder(
          shrinkWrap: true,
          itemCount: count,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0)),
              margin: EdgeInsets.only(bottom: 15.0),
              color: Colors.white,
              elevation: 24.0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: ScheduleItem(
                  enable: widget.enable,
                  data: (schedules[index] == "") ? null : schedules[index],
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
        if (widget.enable)
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
  final String data;
  final bool enable;

  const ScheduleItem({
    Key key,
    @required this.constraints,
    @required this.onChange,
    this.data,
    @required this.enable,
  }) : super(key: key);

  @override
  _ScheduleItemState createState() => _ScheduleItemState();
}

class _ScheduleItemState extends State<ScheduleItem> {
  String first;
  String second;
  String time1;
  String time2;
  String schedule;
  BoxConstraints constraints;

  @override
  void initState() {
    if (widget.data != null) {
      List<String> times = widget.data.split(" ");
      List<String> days = times[0].split("-");
      first = days[0];
      second = days[1];
      days = times[1].split("-");
      time1 = days[0];
      time2 = days[1];
      schedule = widget.data;
    } else {
      first = week[0];
      second = week[0];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    constraints = widget.constraints;
    final children = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DaySelector(
            enable: widget.enable,
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
            enable: widget.enable,
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
              enable: widget.enable,
              hour: time1,
              onChange: (val) {
                setState(() {
                  time1 = val;
                  updateSchedule();
                });
              },
            ),
            Icon(Icons.remove),
            HourPicker(
              enable: widget.enable,
              hour: time2,
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
  final bool enable;

  DaySelector({
    Key key,
    @required this.label,
    this.start,
    @required this.enable,
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
        validator: (val) =>
            (val != null) ? null : "Selecciona un dia de la semana",
        value: day,
        style: Theme.of(context).textTheme.bodyText1,
        elevation: 10,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.calendar_today),
          labelText: widget.label,
          errorStyle: TextStyle(color: Colors.red),
          enabledBorder: InputBorder.none,
        ),
        items: (widget.enable)
            ? week
                .map((e) => DropdownMenuItem<String>(
                      child: Text(e),
                      value: e,
                    ))
                .toList()
            : [
                DropdownMenuItem<String>(
                  child: Text(day),
                  value: day,
                )
              ],
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
  final String hour;
  final bool enable;

  HourPicker({
    Key key,
    @required this.onChange,
    this.hour,
    @required this.enable,
  }) : super(key: key);

  @override
  _HourPickerState createState() => _HourPickerState();
}

class _HourPickerState extends State<HourPicker> {
  TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    _timeController.text = widget.hour ?? "08:00AM";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70.0,
      child: InkWell(
        onTap: (widget.enable) ? pickTime : null,
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
    String hour = _timeController.text;
    if (hour.substring(5) == "PM") {
      hour = hour.replaceRange(
          0, 2, "${(int.tryParse(hour.substring(0, 2)) + 12) % 24}");
    }
    print(hour);
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.tryParse(hour.substring(0, 2)),
        minute: int.tryParse(hour.substring(3, 5)),
      ),
    );
    if (time != null) {
      final hour = "${(time.hourOfPeriod > 9) ? "" : "0"}${time.hourOfPeriod}";
      final minutes = "${(time.minute > 9) ? "" : "0"}${time.minute}";
      final period = "${(time.period.index == 0) ? "AM" : "PM"}";
      setState(() {
        final timeFormat = "$hour:$minutes$period";
        _timeController.text = timeFormat;
        widget.onChange(timeFormat);
      });
    }
  }
}
