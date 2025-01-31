import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_shader_mark_text/provider/leb_banner_provider.dart';
import 'package:test_shader_mark_text/utils/size_helper.dart';
import 'package:test_shader_mark_text/widget/banner_leb/dot_style.dart';
import 'package:test_shader_mark_text/widget/shader_text/shader_text.dart';
import 'package:test_shader_mark_text/widget/shader_text/shader_text_props.dart';

class BannerSection extends StatelessWidget {
  const BannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LebBannerProvider>(
      builder: (context, ledBannerProvider, child) {
        final bannerHeight = ledBannerProvider.isHorizontalView
            ? context.height - context.paddingTop
            : 200.0;

        return Stack(
          children: [
            Container(
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
