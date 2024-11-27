import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_shader_mark_text/provider/leb_banner_provider.dart';
import 'package:test_shader_mark_text/views/widget/banner_section.dart';
import 'package:test_shader_mark_text/views/widget/control_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => LebBannerProvider(),
          child: const Column(
            children: [
              BannerSection(),
              ControlSection(),
            ],
          ),
        ),
      ),
    );
  }
}
