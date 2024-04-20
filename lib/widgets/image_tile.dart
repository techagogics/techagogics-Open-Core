// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/image_model.dart';

class ImageTile extends StatelessWidget {
  final ImageModel image;
  final VoidCallback onTap;
  final bool? isSelected;
  final bool isCorrectChoice;

  const ImageTile({
    super.key,
    required this.image,
    required this.onTap,
    this.isSelected,
    this.isCorrectChoice = false,
  });

  void _zoomImage(BuildContext context) {
    final TransformationController controller = TransformationController();
    Offset? circlePosition;

    // By Colin: You can add initial transformation here, but it has to be
    // centered. Need to add LayoutBuilder to get screen or Image size, and wrap it
    // around the InteractiveViewer.

    Matrix4 initialTransformation;
    // final screenSize = MediaQuery.of(context).size;
    initialTransformation = Matrix4.identity()
      ..scale(1.5); // Starten mit einer Skalierung von z.B. 2.0
    // ..translate(-image.width / 4, -image.height / 4); // Anpassung der Translation
    controller.value = initialTransformation;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        controller.addListener(() {
          setState(() {});
        });
        return Dialog(
          child: GestureDetector(
            onTapDown: (details) {
              final renderBox = context.findRenderObject() as RenderBox;
              final localPosition =
                  renderBox.globalToLocal(details.globalPosition);
              final matrix = Matrix4.inverted(controller.value);

              final correctedPosition =
                  MatrixUtils.transformPoint(matrix, localPosition);
              setState(() {
                circlePosition = correctedPosition;
              });
            },
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: InteractiveViewer(
                          transformationController: controller,
                          // Alignment fixes button zoom (to central)
                          // but causes finger zoom to not be aligned

                          alignment: Alignment.center,
                          child: Stack(children: [
                            Image.network(image.url, fit: BoxFit.contain),

                            // ToDo: Fix circle position
                            // if (circlePosition != null)
                            //   Positioned(
                            //     left: circlePosition!.dx - 40,
                            //     top: circlePosition!.dy - 80,
                            //     child: Animate(
                            //       key: UniqueKey(),
                            //       effects: const [
                            //         FadeEffect(
                            //             duration: Duration(milliseconds: 200))
                            //       ],
                            //       child: Container(
                            //         width: 30,
                            //         height: 30,
                            //         decoration: BoxDecoration(
                            //           shape: BoxShape.circle,
                            //           border: Border.all(
                            //             color: Colors.blueAccent,
                            //             width: 2,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.black, // Dunkle Hintergrundfarbe
                          foregroundColor: Colors.white, // Helle Icon-Farbe
                          shape: const CircleBorder(), // Kreisförmiger Button
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Icon(
                          Icons.zoom_in,
                          size: 28,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          final currentScale =
                              controller.value.getMaxScaleOnAxis();
                          controller.value = Matrix4.identity()
                            ..scale(currentScale * 1.2);
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.black, // Dunkle Hintergrundfarbe
                          foregroundColor: Colors.white, // Helle Icon-Farbe
                          shape: const CircleBorder(), // Kreisförmiger Button
                          padding: const EdgeInsets.all(20),
                        ),
                        onPressed: (controller.value.getMaxScaleOnAxis() <= 1.0)
                            ? null
                            : () {
                                final currentScale =
                                    controller.value.getMaxScaleOnAxis();
                                controller.value = Matrix4.identity()
                                  ..scale(currentScale / 1.2);
                              },
                        child: const Icon(
                          Icons.zoom_out,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.black, // Dunkle Hintergrundfarbe
                          foregroundColor: Colors.white, // Helle Icon-Farbe
                          shape: const CircleBorder(), // Kreisförmiger Button
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 28,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      key: ValueKey(image.id),
      effects: const [FadeEffect()],
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected == true
              ? isCorrectChoice
                  ? Colors.green.withOpacity(0.5)
                  : Colors.red.withOpacity(0.5)
              : Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                image.url,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                        ? child
                        : const Center(child: CircularProgressIndicator()),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            if (isSelected != true)
              Positioned(
                left: 10,
                bottom: 10,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Dunkle Hintergrundfarbe
                    foregroundColor: Colors.white, // Helle Icon-Farbe
                    shape: const CircleBorder(), // Kreisförmiger Button
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Icon(
                    Icons.zoom_in,
                    size: 28,
                    color: Colors.white,
                  ),
                  onPressed: () => _zoomImage(context),
                ),
              ),
            if (isSelected ?? false)
              Animate(
                key: UniqueKey(),
                effects: const [FadeEffect()],
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: isCorrectChoice
                          ? Colors.green.withOpacity(0.5)
                          : Colors.red.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      isCorrectChoice ? Icons.check_circle : Icons.cancel,
                      color: Colors.white,
                      size: 50,
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
