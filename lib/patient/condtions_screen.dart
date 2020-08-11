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
                crossAxisSpacing: MediaQuery.of(context).size.width * 0.05,
                mainAxisSpacing: MediaQuery.of(context).size.height * 0.05,
                children: List.generate(conditions.length, (index) {
                  return buildItem(conditions[index]);
                })),
      ),
    );
  }

  Widget buildItem(String condition) {
    return Container(
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          return Container(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(.7),
                    Theme.of(context).primaryColor
                  ], //here you can change the color
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  width: constraints.maxWidth * 0.8,
                  padding: EdgeInsets.only(top: 5, left: 5),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Condition: ',
                        style: Theme.of(context).textTheme.title,
                      ),
                      Divider(
                        color: Theme.of(context).accentColor,
                        thickness: 0.6,
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            '$condition',
                            maxLines: 5,
                            style: TextStyle(fontSize: 18, color: Colors.white),
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
