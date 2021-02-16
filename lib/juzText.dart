import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class JuzText extends StatefulWidget {
  @override
  _JuzTextState createState() => _JuzTextState();
  JuzText({this.juzNumber,this.snap,this.currentPage});
  int juzNumber;
  DocumentSnapshot snap;
  int currentPage;
}

class _JuzTextState extends State<JuzText> {
  bool _isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromAsset('assets/juz ' +widget.juzNumber.toString() +'.pdf');

    setState(() => _isLoading = false);
  }



  @override
  Widget build(BuildContext context) {
    PageController control = PageController(initialPage: widget.currentPage);
    return

       Scaffold(
// Displays the Juz Name
        appBar: AppBar(
          title:  Text('Juz ' + widget.juzNumber.toString()),
        ),
        body: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : PDFViewer(
            controller: control,
            document: document,
            zoomSteps: 1,
            //uncomment below line to preload all pages
            // lazyLoad: false,
            // uncomment below line to scroll vertically
            // scrollDirection: Axis.vertical,
            //uncomment below code to replace bottom navigation with your own
showPicker: false,
             navigationBuilder:
                      (context, page, totalPages, jumpToPage, animateToPage) {
                    return ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[


                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {

                            animateToPage(page: page - 2);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            animateToPage(page: page);
                          },
                        ),
                        RaisedButton(
                         child: Text("Bookmark",style: TextStyle(fontSize: 28),),
                          onPressed: () {
                           print("handley page"+ page.toString());

                            widget.snap.reference.update({'currentPage':page-1,'totalPages':totalPages});
                           return showDialog<void>(
                             context: context,
                             barrierDismissible: false, // user must tap button!
                             builder: (BuildContext context) {
                               return AlertDialog(
                                 title: Text('You have successfully bookmarked this page'),
                                 content: SingleChildScrollView(
                                   child: ListBody(
                                     children: <Widget>[
                                     ],
                                   ),
                                 ),
                                 actions: <Widget>[
                                   RaisedButton(
                                     child: Text('OK'),
                                     onPressed: () {
                                       Navigator.of(context).popUntil((route) => route.isFirst);
                                     },
                                   ),
                                 ],
                               );
                             },

                           );

                          },
                        ),
                      ],
                    );
                  },
          ),
        ),
      );

  }
}