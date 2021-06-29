import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torfeh_negar/httpRequest.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => HttpRequest(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Torfeh Quiz'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    print("Fetching Data");
    // final reqListener = Provider.of<HttpRequest>(context);
    Future<void> _fetchCountries(BuildContext context) async {
      await Provider.of<HttpRequest>(context, listen: false).getCountries();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder(
          future: _fetchCountries(context),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (dataSnapshot.error != null) {
              return Center(child: Text("An Error Occurred !"));
            } else {
              return Padding(
                padding: EdgeInsets.all(10),
                child: RefreshIndicator(
                  onRefresh: () {
                    return _fetchCountries(context);
                  },
                  child: Consumer<HttpRequest>(
                    builder: (ctx, fetchCountries, child) => ListView.builder(
                      itemBuilder: (ctx, i) => Container(
                        margin: EdgeInsets.all(10),
                        color: Colors.green,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Text(
                                      fetchCountries.fetchedCountry[i]
                                          .toString(),
                                      style: TextStyle(fontSize: 9),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      itemCount: fetchCountries.fetchedCountry.length,
                    ),
                  ),
                ),
              );
            }
          },
        ));
  }
}
