import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../drawer/main_drawer.dart';

class ConditionsScreen extends StatefulWidget {
  static final routeName = 'conditions route';

  @override
  _ConditionsScreenState createState() => _ConditionsScreenState();
}

class _ConditionsScreenState extends State<ConditionsScreen> {
  List<String> conditions;

  @override
  didChangeDependencies() {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    setState(() {
      if (routeArgs != null) {
        conditions = routeArgs['conditions'];
        conditions = conditions.reversed.toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Conditions'),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 20),
        child: conditions == null
            ? Center(
                child: Text("No Conditions Add"),
              )
            : GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1,
                  crossAxisSpacing: MediaQuery.of(context).size.width * 0.001,
                mainAxisSpacing: MediaQuery.of(context).size.height * 0.01,
                children: List.generate(conditions.length, (index) {
                  return buildItem(conditions[index]);
                })),
      ),
    );
  }

  
  Widget buildItem(String condition) {
    return Card(
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          return Container(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
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
                          'Conditions: ',
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
                              '$condition',
                              maxLines: 5,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
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
