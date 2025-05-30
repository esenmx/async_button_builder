import 'package:async_button_builder/async_button_builder.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textButtonState = GlobalKey<AsyncButtonBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Async Buttons')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: textButtonState.currentState?.pressCallback,
        label: const Text('You can trigger first button from here'),
      ),
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Divider(),
            const Text('Text Button:'),
            AsyncButtonBuilder(
              key: textButtonState,
              child: const Text('Click Me'),
              onPressed: () async {
                await Future.delayed(const Duration(seconds: 1));
              },
              builder: (context, child, callback, _) {
                return TextButton(onPressed: callback, child: child);
              },
            ),
            const Divider(),
            const Text('Elevated Button:'),
            AsyncButtonBuilder(
              child: const Text('Click Me'),
              onPressed: () async {
                await Future.delayed(const Duration(seconds: 1));
              },
              builder: (context, child, callback, _) {
                return ElevatedButton(onPressed: callback, child: child);
              },
            ),
            const Divider(),
            const Text('Custom Outlined Button (Error):'),
            AsyncButtonBuilder(
              loadingWidget: const Text('Loading...'),
              onPressed: () async {
                await Future.delayed(const Duration(seconds: 1));
                throw 'yikes';
              },
              builder: (context, child, callback, buttonState) {
                final buttonColor = switch (buttonState) {
                  AsyncButtonStateIdle() => Colors.yellow[200],
                  AsyncButtonStateLoading() => Colors.grey,
                  AsyncButtonStateSuccess() => Colors.orangeAccent,
                  AsyncButtonStateError() => Colors.orange,
                };

                return OutlinedButton(
                  onPressed: callback,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: buttonColor,
                  ),
                  child: child,
                );
              },
              child: const Text('Click Me'),
            ),
            const Divider(),
            const Text('Custom Material Button:'),
            const SizedBox(height: 6.0),
            AsyncButtonBuilder(
              loadingWidget: const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 16.0,
                  width: 16.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
              successWidget: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.check, color: Colors.purpleAccent),
              ),
              onPressed: () async {
                await Future.delayed(const Duration(seconds: 2));
              },
              loadingSwitchInCurve: Curves.bounceInOut,
              loadingTransitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1.0),
                    end: const Offset(0, 0),
                  ).animate(animation),
                  child: child,
                );
              },
              builder: (context, child, callback, state) {
                return Material(
                  color: switch (state) {
                    AsyncButtonStateSuccess() => Colors.purple[100],
                    _ => Colors.blue,
                  },
                  // This prevents the loading indicator showing below the
                  // button
                  clipBehavior: Clip.hardEdge,
                  shape: const StadiumBorder(),
                  child: InkWell(onTap: callback, child: child),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text('Click Me', style: TextStyle(color: Colors.white)),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
