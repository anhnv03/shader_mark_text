import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_shader_mark_text/extension/dot_style_extension.dart';
import 'package:test_shader_mark_text/extension/text_run_direction_extension.dart';
import 'package:test_shader_mark_text/provider/leb_banner_provider.dart';
import 'package:test_shader_mark_text/utils/size_helper.dart';
import 'package:test_shader_mark_text/widget/banner_leb/dot_style.dart';
import 'package:test_shader_mark_text/widget/color_picker_dialog.dart';
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
    return Flexible(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14)
            .copyWith(bottom: context.paddingBottom),
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
              children: [
                const Text("speed animation: "),
                Expanded(
                  child: Slider(
                    value: context
                        .watch<LebBannerProvider>()
                        .selectedSpeedAnimation
                        .toDouble(),
                    min: 1,
                    max: 15,
                    divisions: (15 - 1),
                    label: context
                        .watch<LebBannerProvider>()
                        .selectedSpeedAnimation
                        .toString(),
                    onChanged: (value) => context
                        .read<LebBannerProvider>()
                        .updateSpeedAnimation(value.round()),
                  ),
                )
              ],
            ),
            Row(
              children: [
                const Text("leb size: "),
                Expanded(
                  child: Slider(
                    value: context.watch<LebBannerProvider>().selectedLedSize,
                    min: 1,
                    max: 15,
                    label: context
                        .watch<LebBannerProvider>()
                        .selectedLedSize
                        .toString(),
                    onChanged: (value) =>
                        context.read<LebBannerProvider>().updateLebSize(value),
                  ),
                )
              ],
            ),
            Row(
              children: [
                const Text("leb spacing: "),
                Expanded(
                  child: Slider(
                    value:
                        context.watch<LebBannerProvider>().selectedLebSpacing,
                    min: 0,
                    max: 3,
                    label: context
                        .watch<LebBannerProvider>()
                        .selectedLebSpacing
                        .toString(),
                    onChanged: (value) => context
                        .read<LebBannerProvider>()
                        .updateLebSpacing(value),
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
                  onPressed: () => showBottomSheetSelectFontFamily(context),
                  child: Text(
                      context.watch<LebBannerProvider>().selectFontFamily ??
                          "Roboto"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("leb color: "),
                ElevatedButton(
                  onPressed: () => showColorPickerDialog(
                    context,
                    title: "leb color",
                    initialColor:
                        Provider.of<LebBannerProvider>(context, listen: false)
                            .selectedLebColor,
                    onColorSelected: (value) {
                      context.read<LebBannerProvider>().updateLebColor(value);
                    },
                  ),
                  child: const Text("selected leb color"),
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

  void showBottomSheetSelectFontFamily(BuildContext contextApp) {
    showModalBottomSheet(
      context: contextApp,
      builder: (BuildContext context) {
        final fontList = GoogleFonts.asMap().keys.toList();
        return ListView.builder(
          itemCount: fontList.length,
          itemBuilder: (context, index) {
            final fontName = fontList[index];
            return ListTile(
              title: Text(
                fontName,
                style: GoogleFonts.getFont(fontName),
              ),
              onTap: () {
                print(fontName);
                contextApp.read<LebBannerProvider>().updateFontFamily(fontName);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
