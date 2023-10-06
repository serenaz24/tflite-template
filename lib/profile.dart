import 'package:flutter/material.dart';
import "package:shared_preferences/shared_preferences.dart";

class Profile1Page extends StatefulWidget {
  const Profile1Page({Key? key}) : super(key: key);

  @override
  State<Profile1Page> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profile1Page> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();

  var _genders = ['Female', 'Male'];
  String? _gender;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load and set the saved values if they are not null
    setState(() {
      _ageController.text = prefs.getString('age') ?? '';
      _heightController.text = prefs.getString('height') ?? '';
      _weightController.text = prefs.getString('weight') ?? '';
      print(prefs.getString('gender'));
      if (prefs.containsKey('gender')) {
        _gender = prefs.getString('gender')!;
      }
    });
  }

  Future<void> _saveData(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value ?? '');
  }

  updateInfo() {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    _saveData("gender", _gender);
    _saveData("age", _ageController.text.trim());
    _saveData("height", _heightController.text.trim());
    _saveData("weight", _weightController.text.trim());

    // buildLoading();
    snapBarBuilder('User info edited');
  }

  snapBarBuilder(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
          title: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
              child: Text(
                "My Account",
                style: TextStyle(
                    color: Color(0xFF76A737),
                    fontWeight: FontWeight.w300,
                    fontSize: 27.0),
              )),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(
              context); //This method returns future boolean, based on your condition you can either
          return true; //allow you to go back or you can show a toast and restrict in this page
        },
        child: Container(
          // color: Color.fromRGBO(171, 196, 170, 0.5),
          child: ListView(
            children: <Widget>[
              Container(
                  child: Column(
                children: [
                  Container(
                    height: 3,
                    color: const Color.fromRGBO(80, 80, 74, 1.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      decoration: InputDecoration(
                          counterText: '',
                          labelText: 'Height',
                          hintText: "5.05",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                      controller: _heightController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      decoration: InputDecoration(
                          label: const Text('Weight (lb)'),
                          hintText: "140",
                          counterText: '',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                      controller: _weightController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      decoration: InputDecoration(
                          label: const Text('Age'),
                          hintText: "Age",
                          counterText: '',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                      controller: _ageController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: createRoundedDropDown(width),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ElevatedButton(
                        onPressed: updateInfo,
                        child: Text('Update User Info'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Color.fromRGBO(220, 166, 129, 1.0))),
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget createRoundedDropDown(width) {
    return Container(
      width: width * .95,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color.fromRGBO(65, 58, 58, 1.0)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            borderRadius: BorderRadius.circular(10),
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            hint: Text("Select Gender"),
            value: _gender,
            isDense: true,
            onChanged: (newValue) {
              setState(() {
                _gender = newValue;
              });
            },
            items: _genders.map((document) {
              return DropdownMenuItem<String>(
                value: document,
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(document,
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(65, 58, 58, 1.0)))),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
