import 'package:flutter/material.dart';

class TestDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('Test'),
          onPressed: () {
            return showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return Dialog(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 12),
                      height: MediaQuery.of(context).size.height * .32,
                      width: MediaQuery.of(context).size.width * .85,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Text(
                              'OTP Verification',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            'OTP',
                            style: TextStyle(fontSize: 20),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 90, vertical: 5),
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 25),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8.0),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 2),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 2),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: FractionallySizedBox(
                              heightFactor: 0.5,
                              widthFactor: 0.6,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                child: Text('Next',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17.5)),
                                color: Color(0xFF2B6CB0),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
