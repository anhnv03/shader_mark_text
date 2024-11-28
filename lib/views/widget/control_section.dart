import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_shader_mark_text/extension/dot_style_extension.dart';
import 'package:test_shader_mark_text/extension/text_run_direction_extension.dart';
import 'package:test_shader_mark_text/provider/leb_banner_provider.dart';
import 'package:test_shader_mark_text/widget/banner_leb/dot_style.dart';
import 'package:test_shader_mark_text/widget/icon_button.dart';
import 'package:test_shader_mark_text/widget/shader_text/text_run_direction.dart';

class ControlSection extends StatefulWidget {
  const ControlSection({super.key});

  @override
  State<ControlSection> createState() => _ControlSectionState();
}

class _ControlSectionState extends State<ControlSection> {
  final _contentController = TextEditingController();

  @override
  void initState() {
    _contentController.text = context.read<LebBannerProvider>().textContent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<LebBannerProvider>().isHorizontalView) {
      return const SizedBox.shrink();
    }
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: "enter content banner ...",
                suffixIcon: InkWell(
                  onTap: () => context.read<LebBannerProvider>().toggleView(),
                  child: const Icon(
                    Icons.play_circle,
                  ),
                ),
              ),
              maxLength: 30,
              maxLines: 1,
              onChanged: (value) {
                context.read<LebBannerProvider>().updateTextContent(value);
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text("text size: "),
                Expanded(
                  child: Slider(
                    value: context.watch<LebBannerProvider>().selectedTextSize,
                    min: 24,
                    max: 100,
                    divisions: (100 - 24),
                    label: context
                        .watch<LebBannerProvider>()
                        .selectedTextSize
                        .round()
                        .toString(),
                    onChanged: (value) =>
                        context.read<LebBannerProvider>().updateTextSize(value),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Text run direction: "),
                Wrap(
                  direction: Axis.horizontal,
                  children: TextRunDirection.values.map(
                    (e) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: IconButtonApp(
                          isSelected: e ==
                              context
                                  .read<LebBannerProvider>()
                                  .selectedTextRunDirection,
                          iconData: e.iconDisplay,
                          onTap: () => context
                              .read<LebBannerProvider>()
                              .updateTextRunDirection(e),
                        ),
                      );
                    },
                  ).toList(),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("text shape: "),
                Wrap(
                  direction: Axis.horizontal,
                  children: DotStyle.values.map(
                    (e) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: IconButtonApp(
                          isSelected: e ==
                              context
                                  .read<LebBannerProvider>()
                                  .selectedTextShape,
                          iconData: e.getDisPlayIcon,
                          onTap: () => context
                              .read<LebBannerProvider>()
                              .updateTextShape(e),
                        ),
                      );
                    },
                  ).toList(),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("font family: "),
                ElevatedButton(
                  onPressed: showBottomSheetSelectFontFamily,
                  child: Text(
                      context.watch<LebBannerProvider>().selectFontFamily ??
                          "Roboto"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Bold text: "),
                CupertinoSwitch(
                  value: context.watch<LebBannerProvider>().activeBold,
                  onChanged: (value) =>
                      context.read<LebBannerProvider>().updateFontWeight(value),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("italic text: "),
                CupertinoSwitch(
                  value: context.watch<LebBannerProvider>().activeItalic,
                  onChanged: (value) =>
                      context.read<LebBannerProvider>().updateFontStyle(value),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showBottomSheetSelectFontFamily() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: GoogleFonts.asMap().entries.map((e) {
            return ListTile(
              title: Text(
                e.key,
                style: TextStyle(fontFamily: e.key),
              ),
              onTap: () {
                context.read<LebBannerProvider>().updateFontFamily(e.key);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
