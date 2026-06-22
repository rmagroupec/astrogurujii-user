
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewerScreen extends StatefulWidget{
  final url;
  ImageViewerScreen({this.url});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ImageViewerScreenState();
  }
  
}
class ImageViewerScreenState extends State<ImageViewerScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:  AppBar(
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back_ios_new,color: Colors.black,)),
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text("Report",style: TextStyle(fontSize: 18,color: Colors.black),),
          /*actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.menu,color: Colors.black,))
        ],*/
        ),
        body: Container(
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(widget.url),
                  initialScale: PhotoViewComputedScale.contained * 0.8,
                  heroAttributes: PhotoViewHeroAttributes(tag: 1),
                );
              },
              itemCount: 1,
              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                child: CircularProgressIndicator(
  value: (event == null || event.expectedTotalBytes == null)
      ? null // indeterminate progress
      : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
),

                ),
              ),

            ),
    ),
    );

  }
  
}