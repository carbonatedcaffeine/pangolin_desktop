/*
Copyright 2021 The dahliaOS Authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pangolin/components/overlays/launcher/app_launcher.dart';
import 'package:pangolin/components/shell/shell.dart';
import 'package:pangolin/services/application.dart';
import 'package:pangolin/utils/action_manager/action_manager.dart';
import 'package:pangolin/utils/data/constants.dart';
import 'package:pangolin/utils/data/globals.dart';
import 'package:pangolin/utils/extensions/extensions.dart';
import 'package:pangolin/widgets/global/box/box_container.dart';
import 'package:pangolin/widgets/global/quick_button.dart';
import 'package:xdg_desktop/xdg_desktop.dart';
import 'package:yatl_flutter/yatl_flutter.dart';

class CompactLauncherOverlay extends ShellOverlay {
  static const String overlayId = 'compactlauncher';

  CompactLauncherOverlay({super.key}) : super(id: overlayId);

  @override
  _CompactLauncherOverlayState createState() => _CompactLauncherOverlayState();
}

class _CompactLauncherOverlayState extends State<CompactLauncherOverlay>
    with SingleTickerProviderStateMixin, ShellOverlayState {
  late final AnimationController ac = AnimationController(
    vsync: this,
    duration: Constants.animationDuration,
  );

  @override
  void dispose() {
    ac.dispose();
    super.dispose();
  }

  @override
  Future<void> requestShow(Map<String, dynamic> args) async {
    controller.showing = true;
    await ac.forward();
  }

  @override
  Future<void> requestDismiss(Map<String, dynamic> args) async {
    await ac.reverse();
    controller.showing = false;
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = CurvedAnimation(
      parent: ac,
      curve: Constants.animationCurve,
    );

    if (!controller.showing) return const SizedBox();

    return Positioned(
      bottom: 56,
      left: 8,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, chilld) => FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            alignment: const FractionalOffset(0.025, 1.0),
            child: BoxSurface(
              shape: Constants.bigShape,
              height: 540,
              width: 474,
              dropShadow: true,
              child: Padding(
                //yeah this used to be 16, just a lil reminder
                padding: EdgeInsets.zero,
                child: MaterialApp(
                  home: const CompactLauncher(),
                  theme: Theme.of(context)
                      .copyWith(scaffoldBackgroundColor: Colors.transparent),
                  debugShowCheckedModeBanner: false,
                  locale: context.locale,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CompactLauncher extends StatelessWidget {
  // ignore: use_super_parameters
  const CompactLauncher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.theme.colorScheme.background.op(0.25),
            ),
            child: Column(
              children: [
                const QuickActionButton(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  leading: FlutterLogo(),
                ),
                const Spacer(),
                const QuickActionButton(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  leading: Icon(Icons.edit_rounded),
                ),
                QuickActionButton(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  leading: const Icon(Icons.settings_outlined),
                  onPressed: () => ActionManager.openSettings(context),
                ),
                const QuickActionButton(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  leading: Icon(Icons.exit_to_app_rounded),
                ),
                QuickActionButton(
                  margin: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0,
                    top: 8.0,
                  ),
                  leading: const Icon(Icons.power_settings_new_rounded),
                  onPressed: () => ActionManager.showPowerMenu(context),
                ),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                width: 402,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(username),
                          const SizedBox(height: 2.0),
                          const Text(
                            "Local Account",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    QuickActionButton(
                      margin: const EdgeInsets.all(16.0),
                      leading: const Icon(Icons.open_in_full_rounded),
                      onPressed: () {
                        ActionManager.switchLauncher(context);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 460,
                width: 380,
                child: AnimatedBuilder(
                  animation: ApplicationService.current,
                  builder: (context, _) {
                    final List<DesktopEntry> applications =
                        ApplicationService.current.listApplications();

                    applications.sort(
                      (a, b) => a
                          .getLocalizedName(context.locale)
                          .toLowerCase()
                          .compareTo(
                            b.getLocalizedName(context.locale).toLowerCase(),
                          ),
                    );

                    return ListView.separated(
                      itemCount: applications.length,
                      itemBuilder: (context, index) => AppLauncherTile(
                        application: applications[index],
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 4),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
