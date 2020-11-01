import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rydgo/Screens/BottomSheet.dart';
import 'package:rydgo/Screens/MapScreen.dart';
import 'package:rydgo/Screens/ProfileScreen.dart';
import 'package:rydgo/Screens/result.dart';
import 'package:rydgo/Services/app_state.dart';
//import 'package:validators/validators.dart' as validator;

import 'model.dart';

class BottomNavBar extends StatefulWidget {
  //BottomNavBar({Key key, this.title}) : super(key: key);

  //final String title;

  @override
  _BottomNavBar createState() => _BottomNavBar();
}

class _BottomNavBar extends State<BottomNavBar> {
  DateTime pickedDate;
  TimeOfDay time;
  int _selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();
  Model model = Model();

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  final tabs = [
    Center(
        child: MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AppState(),
        )
      ],
      child: MyHomePage(),
    )),
    Center(child: ProfileScreen()),
    Center(child: ProfileScreen()),
    Center(child: ProfileScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     //title: Text(widget.title),
      //     ),
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.blueGrey,
        notchMargin: 3.0,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.green,
          selectedItemColor: Colors.amberAccent,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), title: Text("Home")),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), title: Text("MyRides")),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet_outlined),
                title: Text("Payments")),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_box_outlined), title: Text("Profile")),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                color: Color(0xff737373),
                child: Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        MyTextFormField(
                          hintText: 'Source',
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Enter Your Current Location';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            model.source = value;
                          },
                        ),
                        MyTextFormField(
                          hintText: 'Destination',
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Enter Your Destination';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            model.destination = value;
                          },
                        ),
                        ListTile(
                          title: Text(
                              "Date: ${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}"),
                          trailing: Icon(
                            Icons.arrow_drop_down_circle_outlined,
                            color: Colors.green,
                          ),
                          onTap: _pickDate,
                        ),
                        ListTile(
                          title: Text("Time: ${time.hour}:${time.minute}"),
                          trailing: Icon(
                            Icons.arrow_drop_down_circle_outlined,
                            color: Colors.green,
                          ),
                          onTap: _pickTime,
                        ),
                        SizedBox(
                          width: 350, // match_parent
                          height: 50,
                          child: RaisedButton(
                            color: Colors.green,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Result(model: this.model)));
                              }
                            },
                            child: Text(
                              'Create Ride',
                              style: TextStyle(fontSize: 20),
                            ),
                            textColor: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.directions_bike_sharp),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: pickedDate,
    );
    if (date != null)
      setState(() {
        pickedDate = date;
      });
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: time);
    if (t != null)
      setState(() {
        time = t;
      });
  }
}
