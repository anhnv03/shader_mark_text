import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_shader_mark_text/extension/text_run_direction_extension.dart';
import 'package:test_shader_mark_text/provider/leb_banner_provider.dart';
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
    return SingleChildScrollView(
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
          )
        ],
      ),
    );
  }
}
