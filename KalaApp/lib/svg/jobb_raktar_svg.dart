import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kalaapp/svg/svg_viewmodel.dart';

class JobbRaktarSvg extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final svgState = ref.watch(svgViewModelProvider);
    final selectedId = svgState.selectedId;

    return Stack(
      children: [
        SvgPicture.string(
          _buildSvg(selectedId),
          fit: BoxFit.contain,
        ),
        // Kattintható területek
        _buildRectangleGestureDetector(ref, 25, 30, 45, 230, '2'),
        _buildRectangleGestureDetector(ref, 140, 30, 45, 230, '3'),
        _buildRectangleGestureDetector(ref, 28, 35, 38, 48, '4'),
        _buildRectangleGestureDetector(ref, 28, 90, 38, 48, '5'),
        _buildRectangleGestureDetector(ref, 28, 145, 38, 48, '6'),
        _buildRectangleGestureDetector(ref, 28, 200, 38, 48, '7'),
        _buildRectangleGestureDetector(ref, 144, 35, 38, 48, '8'),
        _buildRectangleGestureDetector(ref, 144, 90, 38, 48, '9'),
        _buildRectangleGestureDetector(ref, 144, 145, 38, 48, '10'),
        _buildRectangleGestureDetector(ref, 144, 200, 38, 48, '11'),
      ],
    );
  }

  String _buildSvg(String? selectedId) {
    return '''
    <svg width="100%" height="100%" viewBox="0 0 210 297"
      version="1.1" xmlns="http://www.w3.org/2000/svg">
      <g transform="translate(-1.1193467,4.2908295)">
        <rect style="fill:#808080" width="165" height="240" x="22.5" y="25"/>
        <rect id="rect2" style="fill:${selectedId == '2' ? '#0000FF' : '#e6e6e6'}" width="45" height="230" x="25" y="30"/>
        <rect id="rect3" style="fill:${selectedId == '3' ? '#0000FF' : '#e6e6e6'}" width="45" height="230" x="140" y="30"/>
        <rect id="rect4" style="fill:${selectedId == '4' ? '#0000FF' : '#808080'}" width="38" height="48" x="28" y="35"/>
        <rect id="rect5" style="fill:${selectedId == '5' ? '#0000FF' : '#808080'}" width="38" height="48" x="28" y="90"/>
        <rect id="rect6" style="fill:${selectedId == '6' ? '#0000FF' : '#808080'}" width="38" height="48" x="28" y="145"/>
        <rect id="rect7" style="fill:${selectedId == '7' ? '#0000FF' : '#808080'}" width="38" height="48" x="28" y="200"/>
        <rect id="rect8" style="fill:${selectedId == '8' ? '#0000FF' : '#808080'}" width="38" height="48" x="144" y="35"/>
        <rect id="rect9" style="fill:${selectedId == '9' ? '#0000FF' : '#808080'}" width="38" height="48" x="144" y="90"/>
        <rect id="rect10" style="fill:${selectedId == '10' ? '#0000FF' : '#808080'}" width="38" height="48" x="144" y="145"/>
        <rect id="rect11" style="fill:${selectedId == '11' ? '#0000FF' : '#808080'}" width="38" height="48" x="144" y="200"/>
      </g>
      
      
      
         <path
     id="path12"
     style="fill:#ececec;stroke-width:0.364012"
     d="m 121.24554,230.95871 a 46.073051,41.94581 0 0 0 -45.8276,38.53755 c 3.309816,-0.0357 6.620128,-0.0555 9.930063,-0.0565 6.926236,-0.003 13.852347,0.0651 20.777277,0.17887 5.12223,0.0842 10.2456,0.14829 15.36558,0.34322 0.27496,0.0104 0.54964,0.0293 0.82458,0.0405 0.2484,-11.36661 0.50418,-22.7329 0.65995,-34.10168 0.004,-0.33027 0.032,-2.68647 0.0555,-4.83487 a 46.073051,41.94581 0 0 0 -1.78538,-0.10709 z m -46.025977,42.59424 a 46.073051,41.94581 0 0 0 0.002,0.0191 c 0.03539,-0.004 0.07038,-0.0133 0.105798,-0.0183 -0.03593,-2.8e-4 -0.07186,-4.8e-4 -0.107781,-7.7e-4 z" />

    </svg>
    ''';
  }

  Widget _buildRectangleGestureDetector(
      WidgetRef ref, double x, double y, double width, double height, String id) {
    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTap: () {
          ref.read(svgViewModelProvider.notifier).updateSelectedId(id);
        },
        child: Container(
          width: width,
          height: height,
          color: Colors.transparent,
        ),
      ),
    );
  }
}
