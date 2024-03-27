// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// // import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:flutter_application_1/pages/details.dart';
// import 'package:flutter_application_1/pages/senderreciverimage.dart';
// import 'package:flutter_application_1/utils.dart';
// import 'package:photo_view/photo_view.dart';

// // ignore: must_be_immutable
// class ReciverDeshboardPhoto extends StatefulWidget {
//   SenderReciverImage image;
//   ReciverDeshboardPhoto(this.image);

//   @override
//   State<ReciverDeshboardPhoto> createState() =>
//       _ReciverDeshboardPhotoState(image);
// }

// class _ReciverDeshboardPhotoState extends State<ReciverDeshboardPhoto> {
//   SenderReciverImage image;
//   _ReciverDeshboardPhotoState(this.image);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         padding: EdgeInsets.all(5),
//         child: PhotoView(
//             maxScale: 2.0,
//             minScale: 0.5,
//             imageProvider: NetworkImage(
//                 MyUrl.fullurl + MyUrl.imageurl + image.attachment)));
//   }
// }
