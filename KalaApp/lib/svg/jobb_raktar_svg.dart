import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class JobbRaktarSvg extends StatefulWidget {
  @override
  _JobbRaktarSvgState createState() => _JobbRaktarSvgState();
}

class _JobbRaktarSvgState extends State<JobbRaktarSvg> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.string(
          _buildSvg(),
          fit: BoxFit.contain,
        ),
        // Kattintható területek a szürke téglalapokhoz
        _buildRectangleGestureDetector(25, 30, 45, 230, 'rect2'),
        _buildRectangleGestureDetector(140, 30, 45, 230, 'rect3'),
        _buildRectangleGestureDetector(28, 35, 38, 48, 'rect4'),
        _buildRectangleGestureDetector(28, 90, 38, 48, 'rect5'),
        _buildRectangleGestureDetector(28, 145, 38, 48, 'rect6'),
        _buildRectangleGestureDetector(28, 200, 38, 48, 'rect7'),
        _buildRectangleGestureDetector(144, 35, 38, 48, 'rect8'),
        _buildRectangleGestureDetector(144, 90, 38, 48, 'rect9'),
        _buildRectangleGestureDetector(144, 145, 38, 48, 'rect10'),
        _buildRectangleGestureDetector(144, 200, 38, 48, 'rect11'),
      ],
    );
  }

  String _buildSvg() {
    return '''
    <svg
      width="100%" height="100%" viewBox="0 0 210 297"
      version="1.1" xmlns="http://www.w3.org/2000/svg">
      <g transform="translate(-1.1193467,4.2908295)">
        <rect style="fill:#808080" width="165" height="240" x="22.5" y="25"/>
        <rect id="rect2" style="fill:${_selectedId == 'rect2' ? '#0000FF' : '#e6e6e6'}" width="45" height="230" x="25" y="30"/>
        <rect id="rect3" style="fill:${_selectedId == 'rect3' ? '#0000FF' : '#e6e6e6'}" width="45" height="230" x="140" y="30"/>
        <rect id="rect4" style="fill:${_selectedId == 'rect4' ? '#0000FF' : '#808080'}" width="38" height="48" x="28" y="35"/>
        <rect id="rect5" style="fill:${_selectedId == 'rect5' ? '#0000FF' : '#808080'}" width="38" height="48" x="28" y="90"/>
        <rect id="rect6" style="fill:${_selectedId == 'rect6' ? '#0000FF' : '#808080'}" width="38" height="48" x="28" y="145"/>
        <rect id="rect7" style="fill:${_selectedId == 'rect7' ? '#0000FF' : '#808080'}" width="38" height="48" x="28" y="200"/>
        <rect id="rect8" style="fill:${_selectedId == 'rect8' ? '#0000FF' : '#808080'}" width="38" height="48" x="144" y="35"/>
        <rect id="rect9" style="fill:${_selectedId == 'rect9' ? '#0000FF' : '#808080'}" width="38" height="48" x="144" y="90"/>
        <rect id="rect10" style="fill:${_selectedId == 'rect10' ? '#0000FF' : '#808080'}" width="38" height="48" x="144" y="145"/>
        <rect id="rect11" style="fill:${_selectedId == 'rect11' ? '#0000FF' : '#808080'}" width="38" height="48" x="144" y="200"/>
      </g>
    </svg>
    ''';
  }

  // A szürke téglalapokhoz kattintható réteg hozzáadása
  Widget _buildRectangleGestureDetector(double x, double y, double width, double height, String id) {
    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTap: () => _onRectTapped(id),
        child: Container(
          width: width,
          height: height,
          color: Colors.transparent, // Az átlátszó réteg kattinthatóvá teszi
        ),
      ),
    );
  }

  void _onRectTapped(String id) {
    setState(() {
      _selectedId = id;
    });
  }
}
