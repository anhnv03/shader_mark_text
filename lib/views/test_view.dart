import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_shader_mark_text/utils/size_helper.dart';
import 'package:test_shader_mark_text/widget/banner_leb/banner_leb_render.dart';

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<ui.Image>(
          future: BannerLebRenderer.renderToImage(
            width: context.width,
            height: 200,
            ledColor: Colors.red,
            backgroundColor: Colors.white,
            ledSize: 4,
            ledSpacing: 2,
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RawImage(
                  image: snapshot.data,
                ),
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) {
                    return ImageShader(
                      snapshot.data!,
                      TileMode.clamp,
                      TileMode.clamp,
                      Matrix4.identity().storage,
                    );
                  },
                  child: Transform.translate(
                    offset: Offset(-10, 0),
                    child: Text(
                      "test",
                      style: TextStyle(
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 100,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                ShaderMask(
                  blendMode: BlendMode.srcOut,
                  shaderCallback: (bounds) {
                    return ImageShader(
                      snapshot.data!,
                      TileMode.clamp,
                      TileMode.clamp,
                      Matrix4.identity().storage,
                    );
                  },
                  child: Text(
                    "test",
                    style: TextStyle(
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 100,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
