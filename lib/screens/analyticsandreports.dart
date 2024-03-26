import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fyp/screens/usermanagement.dart';
import '../authentication/authentication_repo.dart';
import 'CommunityForumPostsAdmin.dart';
import 'CrimeDataPage.dart';
import 'admindashboard.dart';
import 'login_screen.dart';
import 'package:pie_chart/pie_chart.dart';

class AnalyticsAndReports extends StatefulWidget {
  @override
  _AnalyticsAndReportsState createState() => _AnalyticsAndReportsState();
}

class _AnalyticsAndReportsState extends State<AnalyticsAndReports> {
  List<Map<String, dynamic>> _crimeData = [];
  Map<String, dynamic> dataMap = {};
  Map<String, dynamic> dataMap2 = {};

  @override
  void initState() {
    super.initState();
    _fetchCrimeData().then((_) {
      _preparePieChartData();
      _preparePieChartData2();
    });
  }

  Future<void> _fetchCrimeData() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('crimeData').get();
    setState(() {
      _crimeData = querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  List<charts.Series<Map<String, dynamic>, String>> _prepareData() {
    Map<String, int> crimeCountByType = {};
    _crimeData.forEach((crime) {
      final crimeType = crime['crimeType'];
      crimeCountByType[crimeType] = (crimeCountByType[crimeType] ?? 0) + 1;
    });

    List<Map<String, dynamic>> chartData = [];
    crimeCountByType.forEach((crimeType, count) {
      chartData.add({'type': crimeType, 'count': count});
    });

    return [
      charts.Series<Map<String, dynamic>, String>(
        id: 'Crime Count',
        data: chartData,
        domainFn: (datum, _) => datum['type'],
        measureFn: (datum, _) => datum['count'].toDouble(),
        insideLabelStyleAccessorFn: (_, __) => charts.TextStyleSpec(
            fontSize: 0), // Empty TextStyleSpec to remove labels
      ),
    ];
  }

  List<charts.Series<Map<String, dynamic>, DateTime>> _prepareData2() {
    Map<DateTime, int> crimeCountByDate = {};

    // Get the current year
    int currentYear = DateTime.now().year;

    // Create a map with all months of the current year initialized to 0
    for (int i = 1; i <= 12; i++) {
      final monthStart = DateTime(currentYear, i, 1);
      crimeCountByDate[monthStart] = 0;
    }

    // Update the map with actual crime counts for the current year only
    _crimeData.forEach((crime) {
      final dateString = crime['date'];
      final parsedDate = _parseDate(dateString);
      if (parsedDate != null && parsedDate.year == currentYear) {
        final monthStart = DateTime(parsedDate.year, parsedDate.month, 1);
        crimeCountByDate[monthStart] = (crimeCountByDate[monthStart] ?? 0) + 1;
      }
    });

    List<Map<String, dynamic>> chartData = [];
    crimeCountByDate.forEach((date, count) {
      chartData.add({'date': date, 'count': count});
    });

    return [
      charts.Series<Map<String, dynamic>, DateTime>(
        id: 'Crime Count',
        data: chartData,
        domainFn: (datum, _) => datum['date'],
        measureFn: (datum, _) => datum['count'].toDouble(),
      ),
    ];
  }

  DateTime? _parseDate(String dateString) {
    try {
      final parts = dateString.split('/');
      final day = int.parse(parts[1]);
      final month = int.parse(parts[0]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (e) {
      print('Error parsing date: $dateString');
      return null;
    }
  }

  void _preparePieChartData() {
    Map<String, int> crimeCountByCategory = {};

    _crimeData.forEach((crime) {
      final category = crime['crimeType'];
      crimeCountByCategory[category] =
          (crimeCountByCategory[category] ?? 0) + 1;
    });

    List<Map<String, dynamic>> chartData = [];
    crimeCountByCategory.forEach((category, count) {
      chartData.add({'crimeType': category, 'count': count});
    });

    dataMap = {};
    chartData.forEach((data) {
      dataMap[data['crimeType']] = data['count'].toDouble();
    });
  }

  void _preparePieChartData2() {
    Map<int, int> crimeCountByMonth = {};

    _crimeData.forEach((crime) {
      final dateString = crime['date'];
      final parsedDate = _parseDate(dateString);
      if (parsedDate != null) {
        final month = parsedDate.month;
        crimeCountByMonth[month] = (crimeCountByMonth[month] ?? 0) + 1;
      }
    });

    List<Map<String, dynamic>> chartData = [];
    crimeCountByMonth.forEach((month, count) {
      final monthName = _getMonthName(month);
      chartData.add({'month': monthName, 'count': count});
    });

    dataMap2 = {};
    chartData.forEach((data) {
      dataMap2[data['month']] = data['count'].toDouble();
    });
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return 'Unknown';
    }
  }

  List<Color> _getColorList(int length) {
    List<Color> colors = [];
    int normalColorsCount = length - 1;
    for (int i = 0; i < normalColorsCount; i++) {
      final palette =
          charts.MaterialPalette.getOrderedPalettes(normalColorsCount)[i];
      colors.add(Color.fromRGBO(palette.shadeDefault.r, palette.shadeDefault.g,
          palette.shadeDefault.b, 1));
    }
    colors.add(Colors.green);
    return colors;
  }

  List<Color> _getColorList2(int length) {
    List<Color> colors = [];
    for (int i = 0; i < length; i++) {
      double hue = (i / length) * 360;
      colors.add(HSLColor.fromAHSL(1.0, hue, 0.75, 0.5).toColor());
    }
    return colors;
  }

  @override
  Widget build(BuildContext context) {
    List<Color> _monthColors = _getColorList2(dataMap2.length);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF769DC9),
        title: Text(
          'Analytics and Reports',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF769DC9),
                Color(0xFF769DC9),
                Color(0xFF7EA3CA),
                Color(0xFF769DC9),
                Color(0xFFCBE1EE),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF769DC9),
                      Color(0xFF769DC9),
                      Color(0xFF7EA3CA),
                      Color(0xFF769DC9),
                      Color(0xFFCBE1EE),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: GestureDetector(
                        child: Image.asset(
                          "assets/admin.png",
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Watchful Eyes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          'Admin Dashboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.dashboard, color: Colors.white),
                title: Text(
                  'Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminDashboard()),
                  );
                },
              ),
              Divider(
                color: Colors.white,
              ),
              if (kIsWeb)
                ListTile(
                  leading:
                  Icon(Icons.supervised_user_circle, color: Colors.white),
                  title: Text(
                    'User Management',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserManagement()),
                    );
                  },
                ),
              if (kIsWeb)
                ListTile(
                  leading: Icon(Icons.analytics, color: Colors.white),
                  title: Text(
                    'Analytics and Reports',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AnalyticsAndReports()),
                    );
                  },
                ),

              if(kIsWeb)
                Divider(
                  color: Colors.white,
                ),
              if (!kIsWeb)
                ListTile(
                  leading: Icon(Icons.check, color: Colors.white),
                  title: Text(
                    'Community Forum Posts',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              if (!kIsWeb)
                ListTile(
                  leading: Icon(Icons.warning, color: Colors.white),
                  title: Text(
                    'Registered Complaints',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CrimeDataPage()),
                    );
                  },
                ),
              if (!kIsWeb)
                Divider(
                  color: Colors.white,
                ),
              GestureDetector(
                onTap: () async {
                  bool confirmLogout =
                  await _showLogoutConfirmationDialog(context);

                  if (confirmLogout) {
                    await AuthenticationRepository.instance.logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }
                },
                child: ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.white),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF769DC9),
              Color(0xFF769DC9),
              Color(0xFF7EA3CA),
              Color(0xFF769DC9),
              Color(0xFFCBE1EE),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth > 600) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            height: 400,
                            child: charts.BarChart(
                              _prepareData(),
                              animate: true,
                              vertical: true,
                              barRendererDecorator:
                                  charts.BarLabelDecorator<String>(),
                            ),
                          ),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            height: 400,
                            child: charts.TimeSeriesChart(
                              _prepareData2(),
                              animate: true,
                              defaultRenderer:
                                  charts.BarRendererConfig<DateTime>(),
                              domainAxis: charts.DateTimeAxisSpec(
                                renderSpec: charts.SmallTickRendererSpec(
                                    labelRotation: 0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0), // Add padding here
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              height: 400,
                              child: PieChart(
                                dataMap: dataMap.map((key, value) =>
                                    MapEntry(key, value.toDouble())),
                                animationDuration: Duration(milliseconds: 800),
                                chartLegendSpacing: 32,
                                chartRadius:
                                    MediaQuery.of(context).size.width / 3.2,
                                colorList: _getColorList(dataMap.length),
                                chartType: ChartType.ring,
                                centerText: "HYBRID",
                                legendOptions: LegendOptions(
                                  showLegendsInRow: false,
                                  legendPosition: LegendPosition.right,
                                  showLegends: true,
                                  legendShape: BoxShape.circle,
                                  legendTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                chartValuesOptions: ChartValuesOptions(
                                  showChartValueBackground: true,
                                  showChartValues: true,
                                  showChartValuesInPercentage: false,
                                  showChartValuesOutside: false,
                                  decimalPlaces: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0), // Add padding here
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              height: 400,
                              child: PieChart(
                                dataMap: dataMap2.map((key, value) =>
                                    MapEntry(key, value.toDouble())),
                                animationDuration: Duration(milliseconds: 800),
                                chartLegendSpacing: 32,
                                chartRadius:
                                    MediaQuery.of(context).size.width / 3.2,
                                colorList: _monthColors,
                                chartType: ChartType.ring,
                                centerText: "HYBRID",
                                legendOptions: LegendOptions(
                                  showLegendsInRow: false,
                                  legendPosition: LegendPosition.right,
                                  showLegends: true,
                                  legendShape: BoxShape.circle,
                                  legendTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                chartValuesOptions: ChartValuesOptions(
                                  showChartValueBackground: true,
                                  showChartValues: true,
                                  showChartValuesInPercentage: false,
                                  showChartValuesOutside: false,
                                  decimalPlaces: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              height: 400,
                              width: 800,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: DataTable(
                                  columns: [
                                    DataColumn(
                                      label: Text(
                                        'Crime Type',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Count',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                  rows: dataMap.entries.map((entry) {
                                    return DataRow(cells: [
                                      DataCell(
                                        Text(
                                          entry.key,
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          entry.value.toString(),
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              height: 400,
                              width: 800,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: DataTable(
                                  columns: [
                                    DataColumn(
                                      label: Text(
                                        'Months',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Count',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                  rows: dataMap2.entries.map((entry) {
                                    return DataRow(cells: [
                                      DataCell(
                                        Text(
                                          entry.key,
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          entry.value.toString(),
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              );
            } else {
              // For mobile devices
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        height: 400,
                        child: charts.BarChart(
                          _prepareData(),
                          animate: true,
                          vertical: true,
                          barRendererDecorator:
                              charts.BarLabelDecorator<String>(),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        height: 400,
                        child: charts.TimeSeriesChart(
                          _prepareData2(),
                          animate: true,
                          defaultRenderer: charts.BarRendererConfig<DateTime>(),
                          domainAxis: charts.DateTimeAxisSpec(
                            renderSpec:
                                charts.SmallTickRendererSpec(labelRotation: 0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        height: 400,
                        child: PieChart(
                          dataMap: dataMap.map(
                              (key, value) => MapEntry(key, value.toDouble())),
                          animationDuration: Duration(milliseconds: 800),
                          chartLegendSpacing: 32,
                          chartRadius: MediaQuery.of(context).size.width / 3.2,
                          colorList: _getColorList(dataMap.length),
                          chartType: ChartType.ring,
                          centerText: "HYBRID",
                          legendOptions: LegendOptions(
                            showLegendsInRow: false,
                            legendPosition: LegendPosition.right,
                            showLegends: true,
                            legendShape: BoxShape.circle,
                            legendTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          chartValuesOptions: ChartValuesOptions(
                            showChartValueBackground: true,
                            showChartValues: true,
                            showChartValuesInPercentage: false,
                            showChartValuesOutside: false,
                            decimalPlaces: 1,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        height: 400,
                        child: PieChart(
                          dataMap: dataMap2.map(
                              (key, value) => MapEntry(key, value.toDouble())),
                          animationDuration: Duration(milliseconds: 800),
                          chartLegendSpacing: 32,
                          chartRadius: MediaQuery.of(context).size.width / 3.2,
                          colorList: _monthColors,
                          chartType: ChartType.ring,
                          centerText: "HYBRID",
                          legendOptions: LegendOptions(
                            showLegendsInRow: false,
                            legendPosition: LegendPosition.right,
                            showLegends: true,
                            legendShape: BoxShape.circle,
                            legendTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          chartValuesOptions: ChartValuesOptions(
                            showChartValueBackground: true,
                            showChartValues: true,
                            showChartValuesInPercentage: false,
                            showChartValuesOutside: false,
                            decimalPlaces: 1,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        height: 400,
                        width: 800,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            columns: [
                              DataColumn(
                                label: Text(
                                  'Crime Type',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Count',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            rows: dataMap.entries.map((entry) {
                              return DataRow(cells: [
                                DataCell(
                                  Text(
                                    entry.key,
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    entry.value.toString(),
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        height: 400,
                        width: 800,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            columns: [
                              DataColumn(
                                label: Text(
                                  'Months',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Count',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            rows: dataMap2.entries.map((entry) {
                              return DataRow(cells: [
                                DataCell(
                                  Text(
                                    entry.key,
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    entry.value.toString(),
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

Future<bool> _showLogoutConfirmationDialog(BuildContext context) async {
  return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout Confirmation'),
            content: Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(true); // Yes, logout

                  // Perform logout
                  await AuthenticationRepository.instance.logout();

                  // Redirect to the login screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child:
                const Text('Yes', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child:
                const Text('No', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          );
        },
      ) ??
      false;
}
