import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kalaapp/svg/svg_viewmodel.dart';

class BalRaktarSvg extends ConsumerWidget {
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
        _buildRectangleGestureDetector(ref, 28.36, 31.34, 109.70, 73.13, '1'),
        _buildRectangleGestureDetector(ref, 29.36, 207.90, 109.70, 49.99, '2'),
        _buildRectangleGestureDetector(ref, 144.63, 29.94, 45.15, 228.35, '3'),
        _buildRectangleGestureDetector(ref, 34.70, 38.80, 96.26, 57.83, '4'),
        _buildRectangleGestureDetector(ref, 36.41, 213.68, 92.53, 38.43, '5'), // Forgatva
        _buildRectangleGestureDetector(ref, 148.39, 34.38, 38.43, 105.22, '6'),
        _buildRectangleGestureDetector(ref, 148.73, 144.27, 38.43, 109.32, '7'),
      ],
    );
  }

  String _buildSvg(String? selectedId) {
    String color(String id, String defaultColor) =>
        selectedId == id ? '#0000FF' : defaultColor;

    return '''
<svg width="100%" height="100%" viewBox="0 0 210 297" version="1.1" xmlns="http://www.w3.org/2000/svg">
  <rect fill="#808080" width="171.26" height="242.52" x="22.39" y="21.64" />
  <rect id="1" fill="${color('1', '#e6e6e6')}" width="109.70" height="73.13" x="28.36" y="31.34"/>
  <rect id="2" fill="${color('2', '#e6e6e6')}" width="109.70" height="49.99" x="29.36" y="207.90"/>
  <rect id="3" fill="${color('3', '#e6e6e6')}" width="45.15" height="228.35" x="144.63" y="29.94"/>
  <rect id="4" fill="${color('4', '#808080')}" width="96.26" height="57.83" x="34.70" y="38.80"/>
  
   <path
       id="path6"
       style="fill:#e6e6e6;stroke-width:0.551342"
       d="m 81.877627,189.80013 a 62.537313,55.811618 0 0 0 -60.17358,-50.37368 c -0.11037,3.63616 -0.21187,7.27332 -0.339,10.90683 -0.1688,3.29972 -0.39274,7.50979 -0.58963,11.41429 0.11489,1.68215 0.30208,3.36117 0.49299,5.03329 0.65415,4.1599 1.02305,8.34549 1.19476,12.55065 0.0289,1.03596 0.0329,2.07193 0.0191,3.10731 -0.0415,3.10616 -0.24562,6.2095 -0.43666,9.30951 -0.005,0.10237 -0.0118,0.2046 -0.0171,0.30696 4.07681,0.10026 8.15255,0.23285 12.2282,0.36897 1.10194,-0.0804 2.20207,-0.1768 3.30471,-0.25012 9.87231,-0.70439 19.74436,-1.45567 29.64108,-1.80402 4.45615,-0.13093 8.91819,-0.18577 13.36869,-0.42892 0.5305,-0.0613 0.91149,-0.10113 1.30638,-0.14107 z m -1.52548,0.2961 c -0.35371,0.12529 -1.02088,0.0817 -1.28881,0.25218 0.33085,-0.0483 0.65097,-0.0965 1.08107,-0.18293 0.0718,-0.0145 0.27638,-0.0936 0.20774,-0.0693 z m -48.37638,59.74519 c -1.05177,-0.0916 -1.9348,-0.18038 -2.89646,-0.27802 -0.14047,0.24299 -0.29624,0.48294 -0.46199,0.71882 0.001,0.002 0.003,0.004 0.004,0.007 a 62.537313,55.811618 0 0 0 3.35432,-0.44752 z M 4.393477,141.12816 a 62.537313,55.811618 0 0 0 -0.55656,0.16588 c 0.0262,0.2011 0.0575,0.40145 0.0837,0.60255 0.15702,0.38043 0.26641,0.73037 0.41341,1.10226 0.0195,-0.62358 0.0415,-1.24702 0.0594,-1.87069 z m -24.32255,13.05553 c -0.29083,-2.48937 -0.23468,-1.60067 -0.12971,-0.34571 0.0454,0.10261 0.086,0.23316 0.12971,0.34571 z" />
  
  <rect id="5"
    width="38.43"
    height="92.53"
    transform="rotate(-90)"
    x="-252.91"
    y="36.41"
    fill="${color('5', '#808080')}" />
  <rect id="6" fill="${color('6', '#808080')}" width="38.43" height="105.22" x="148.39" y="34.38"/>
  <rect id="7" fill="${color('7', '#808080')}" width="38.43" height="109.32" x="148.73" y="144.27"/>
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
          ref.read(svgViewModelProvider.notifier).updateState(nev: 'balraktar', id: id);
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
