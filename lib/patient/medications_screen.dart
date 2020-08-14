import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../drawer/main_drawer.dart';

class MedicationsScreen extends StatefulWidget {
  static final routeName = 'Medication route';

  @override
  _MedicationsScreenState createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  List<String> medications;
  @override
  didChangeDependencies() {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    setState(() {
      if (routeArgs != null) {
        medications = routeArgs['medications'];
        medications = medications.reversed.toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Medications'),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 20),
        child: medications == null
            ? Center(
                child: Text("No Medications Add"),
              )
            : GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1,
                crossAxisSpacing: MediaQuery.of(context).size.width * 0.001,
                mainAxisSpacing: MediaQuery.of(context).size.height * 0.01,
                children: List.generate(
                  medications.length,
                  (index) {
                    return buildItem(medications[index]);
                  },
                ),
              ),
      ),
    );
  }

  Widget buildItem(String medication) {
    return Card(
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          return Container(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(1),
                //  borderRadius: BorderRadius.circular(40),
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 0),
                child: Container(
                  width: constraints.maxWidth * 0.8,
                  //    padding: EdgeInsets.only(top: 5, left: 5),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                        width: double.infinity,
                        color: Colors.amber,
                        alignment: Alignment.center,
                        child: Text(
                          'Medication: ',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: 100,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              '${medication.substring(0, medication.length - 4)}',
                              maxLines: 5,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          //  padding: EdgeInsets.all(5),
                          child: Text(
                            'Dosage: ${medication.substring(medication.length - 4, medication.length)} mg',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
