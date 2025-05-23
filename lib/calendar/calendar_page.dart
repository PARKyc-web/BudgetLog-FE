import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  final String budgetName;

  CalendarPage({required this.budgetName});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();

  // 예시 데이터
  Map<DateTime, Map<String, double>> transactions = {
    DateTime(2023, 10, 1): {'expense': 2000.0, 'income': 1000.0},
    DateTime(2023, 10, 2): {'expense': 1500.0, 'income': 3000.0},
    DateTime(2023, 10, 3): {'expense': 500.0, 'income': 1500.0},
    // 더 많은 날짜 추가 가능
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.budgetName} 달력'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 400, // 원하시는 높이를 설정
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _selectedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
              },
              calendarBuilders: CalendarBuilders(
                // 날짜를 커스터마이징하여 하단에 수입/지출 표시
                defaultBuilder: (context, date, day) {
                  final transaction = transactions[date];
                  return Column(
                    children: [
                      Text(
                        '${date.day}',
                        style: TextStyle(fontSize: 16),
                      ),
                      if (transaction != null) ...[
                        Text(
                          'INCOME: ${transaction['income']?.toStringAsFixed(0) ?? 0} 원',
                          style: TextStyle(fontSize: 10, color: Colors.blue),
                        ),
                        Text(
                          'OUTCOME: ${transaction['expense']?.toStringAsFixed(0) ?? 0} 원',
                          style: TextStyle(fontSize: 10, color: Colors.red),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            '선택된 날짜: ${_selectedDay.toLocal()}'.split(' ')[0],
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}