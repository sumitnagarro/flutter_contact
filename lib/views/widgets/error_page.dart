import 'package:flutter/material.dart';

///ErrorPage component
///
///Input parameters [message]: Error message to be shown
///Input parameters [function]: Custom functionality to perform when button in press, this can be passed from he using component page.
///
///For example
///
///```dart
///ErrorPage('Something went wrong, please try again later',
///                (){
///                     //Do Anything
///                     loadData();
///                  },
///                'Retry Again',
///               )
/// ```
///
///Input parameters [buttonText]: Text to be shown on button
class ErrorPage extends StatelessWidget {
  const ErrorPage({
    @required this.message,
    @required this.function,
    @required this.buttonText,
  });

  final message;
  final function;
  final buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Column(
          children: [
            Text(message),
            FlatButton(
              child: Text(
                buttonText,
                style: TextStyle(
                  color: Colors.blueGrey,
                ),
              ),
              onPressed: function,
            )
          ],
        ),
      ),
    );
  }
}
