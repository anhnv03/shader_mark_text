import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:screen_recorder/screen_recorder.dart';
import 'package:test_shader_mark_text/provider/leb_banner_provider.dart';
import 'package:test_shader_mark_text/utils/size_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_shader_mark_text/widget/banner_leb/dot_style.dart';
import 'package:test_shader_mark_text/widget/shader_text/shader_text.dart';
import 'package:test_shader_mark_text/widget/shader_text/shader_text_props.dart';

class BannerSection extends StatefulWidget {
  const BannerSection({super.key});

  @override
  State<BannerSection> createState() => _BannerSectionState();
}

class _BannerSectionState extends State<BannerSection> {
  final ScreenRecorderController _recorderController = ScreenRecorderController();

  @override
  void initState() {
    super.initState();
    _requestManageStoragePermission();
    _startRecording();
  }

  Future<void> _requestManageStoragePermission() async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      debugPrint("Storage management permission granted");
    } else {
      debugPrint("Storage management permission denied");
    }
  }

  void _startRecording() async {
    _recorderController.start();
    await Future.delayed(Duration(seconds: 10)); // Ghi trong 5 giây
    _recorderController.stop();

    final frames = _recorderController.exporter.frames;
    final gifBytes = await _generateGif(frames);

    // Lưu file GIF vào thư mục bộ nhớ trong
    await _saveGifToGallery(gifBytes);
  }

  Future<List<int>> _generateGif(List<Frame> frames) async {
    // Giả sử bạn đã mã hóa các frame thành file GIF
    final gifBytes = <int>[]; // Thực hiện mã hóa ở đây.
    return gifBytes;
  }

  Future<void> _saveGifToGallery(List<int> gifBytes) async {
    final directory = await getExternalStorageDirectory();
    final path = '${directory!.path}/animated_text.gif';

    final file = File(path);
    await file.writeAsBytes(gifBytes);

    debugPrint("GIF saved to: $path");

    // Sau khi file được lưu, bạn có thể thêm nó vào thư viện ảnh
    final galleryDirectory = Directory('/storage/emulated/0/Pictures/');
    if (await galleryDirectory.exists()) {
      final galleryPath = '${galleryDirectory.path}/animated_text.gif';
      await file.copy(galleryPath);
      debugPrint('GIF saved to gallery at: $galleryPath');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<LebBannerProvider>(
      builder: (context, ledBannerProvider, child) {
        final bannerHeight = ledBannerProvider.isHorizontalView
            ? context.height - context.paddingTop
            : 200.0;

        return Stack(
          children: [
            ScreenRecorder(
              controller: _recorderController,
              width: 300,
              height: 300,
              child: Container(
                margin: EdgeInsets.only(top: context.paddingTop),
                width: context.width,
                height: bannerHeight,
                color: Colors.black,
                alignment: Alignment.center,
                // decoration: const BoxDecoration(
                //   image: DecorationImage(
                //     fit: BoxFit.cover,
                //     image: NetworkImage(
                //       "https://bs.uenicdn.com/blog/wp-content/uploads/2018/04/giphy.gif",
                //     ),
                //   ),
                // ),
                child: ShaderText(
                  data: ledBannerProvider.textContent,
                  textProps: const TextProps(
                    style: TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  animationProps: TextAnimationProps(
                    direction: ledBannerProvider.selectedTextRunDirection,
                    duration: const Duration(seconds: 5),
                    curve: Curves.linear,
                    repeat: true,
                  ),
                  bannerProps: BannerLebProps(
                    ledSize: 4,
                    ledSpacing: 0,
                    ledColor: Colors.red,
                    backgroundColor: Colors.black,
                    dotStyle: DotStyle.circle,
                    width: context.width,
                    height: bannerHeight,
                  ),
                  blendMode: BlendMode.srcIn,
                ),
              ),
            ),
            if (ledBannerProvider.isHorizontalView)
              Positioned(
                top: context.paddingLeft / 1.5,
                left: context.paddingLeft / 1.5,
                child: InkWell(
                  onTap: () => context.read<LebBannerProvider>().toggleView(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
