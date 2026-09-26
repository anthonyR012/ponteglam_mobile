import 'package:flutter/material.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/enum_constant.dart';
import 'package:ponte_glam/config/constant/values_constant.dart';
import 'package:ponte_glam/shared/widgets/image_load_widget.dart';

class PlaceImagesPageView extends StatefulWidget {
  const PlaceImagesPageView({
    super.key,
    required this.images,
    required this.idService,
    required this.headquarterName,
  });

  final List<String> images;
  final int idService;
  final String headquarterName;

  @override
  State<PlaceImagesPageView> createState() => _PlaceImagesPageViewState();
}

class _PlaceImagesPageViewState extends State<PlaceImagesPageView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "${widget.idService}${widget.headquarterName}",
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: widget.images.length,
              controller: PageController(viewportFraction: .9),
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                    margin: const EdgeInsets.only(right: 10),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 10)
                      ],
                    ),
                    child: ImageLoadWidget(
                      image: widget.images[index],
                      typeSourceImage: TypeSourceImage.network,
                      fit: BoxFit.cover,
                    ));
              },
            ),
          ),
          const SizedBox(height: spaceBetween10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.images.length, (index) {
              return Padding(
                padding: const EdgeInsets.all(4),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 480),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: index == currentIndex
                        ? secondaryColorTheme
                        : grayTextColorTheme,
                  ),
                  width: 10,
                  height: 10,
                ),
              );
            }),
          ),
          const SizedBox(height: spaceBetween10),
        ],
      ),
    );
  }
}
