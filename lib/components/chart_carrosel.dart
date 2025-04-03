// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';

// class ChartCarrosel extends StatefulWidget {
//   const ChartCarrosel({
//     super.key,
//     required this.height,
//     required this.charts,
//   });

//   final double height;
//   final List<Widget> charts;

//   @override
//   State<ChartCarrosel> createState() => _ChartCarroselState();
// }

// class _ChartCarroselState extends State<ChartCarrosel> {
//   final CarouselSliderController _controller = CarouselSliderController();
//   int _current = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: CarouselSlider(
//             options: CarouselOptions(
//               height: widget.height,

//               enableInfiniteScroll: false,
//               viewportFraction: 1,
//               // enlargeCenterPage: true,
//               onPageChanged: (index, reason) {
//                 setState(() {
//                   _current = index;
//                 });
//               },
//             ),
//             items: widget.charts.map((chart) {
//               return Container(
//                 width: widget.height,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//                 child: chart,
//               );
//             }).toList(),
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: widget.charts.asMap().entries.map((entry) {
//             return GestureDetector(
//               onTap: () => _controller.animateToPage(entry.key),
//               child: Container(
//                 width: 12.0,
//                 height: 12.0,
//                 margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
//                 decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: (Theme.of(context).brightness == Brightness.dark
//                             ? Colors.white
//                             : Colors.black)
//                         .withOpacity(_current == entry.key ? 0.9 : 0.4)),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }
