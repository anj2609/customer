import 'package:flutter/material.dart';
import 'package:vivashri/config/utils/constants.dart';

class PhotoSliderDialog extends StatefulWidget {
  final List<String> photos;

  const PhotoSliderDialog({super.key, required this.photos});

  @override
  State<PhotoSliderDialog> createState() => _PhotoSliderDialogState();
}

class _PhotoSliderDialogState extends State<PhotoSliderDialog> {
  PageController controller = PageController();
  int currentIndex = 0;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('image:::::${widget.photos}');
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(10),
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.70,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            PageView.builder(
              controller: controller,
              itemCount: widget.photos.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                String url = "${ApiConstants.imageurl}${widget.photos[index]}";

                return InteractiveViewer(
                  child: Center(child: Image.network(url, fit: BoxFit.contain)),
                );
              },
            ),

            /// Close button
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ),

            /// Page Indicator (bottom)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.photos.length,
                  (index) => AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    width: currentIndex == index ? 12 : 8,
                    height: currentIndex == index ? 12 : 8,
                    decoration: BoxDecoration(
                      color: currentIndex == index
                          ? Colors.white
                          : Colors.white54,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
