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

import 'package:flutter/material.dart';
import 'package:pangolin/components/settings/models/settings_taskbar_data_model.dart';
import 'package:pangolin/utils/data/constants.dart';
import 'package:pangolin/utils/extensions/extensions.dart';

class TaskbarAlignmentButton extends StatelessWidget {
  final TaskbarAlignmentModelData model;
  final bool selected;

  const TaskbarAlignmentButton({
    super.key,
    required this.model,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      customBorder: Constants.smallShape,
      mouseCursor: SystemMouseCursors.click,
      onTap: () {
        //_customizationProvider.centerTaskbar = model.centered;
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: selected ? context.theme.accent : Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            children: [
              Container(
                width: 8 * 64,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: borderStyle(isDarkMode: isDarkMode),
                  color: Theme.of(context).colorScheme.background,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        children: [
                          _taskbarElement(context),
                          const SizedBox(width: 8),
                          _taskbarElement(context),
                          const SizedBox(width: 8),
                          _taskbarElement(context),
                          if (!model.centered) ...[
                            const SizedBox(width: 16),
                            _taskbarElement(context, shaded: true),
                            const SizedBox(width: 8),
                            _taskbarElement(context, shaded: true),
                            const SizedBox(width: 8),
                            _taskbarElement(context, shaded: true),
                            const SizedBox(width: 8),
                            _taskbarElement(context, shaded: true),
                            const SizedBox(width: 8),
                            _taskbarElement(context, shaded: true),
                          ],
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: model.centered
                            ? [
                                _taskbarElement(context, shaded: true),
                                const SizedBox(width: 8),
                                _taskbarElement(context, shaded: true),
                                const SizedBox(width: 8),
                                _taskbarElement(context, shaded: true),
                                const SizedBox(width: 8),
                                _taskbarElement(context, shaded: true),
                                const SizedBox(width: 8),
                                _taskbarElement(context, shaded: true),
                              ]
                            : [],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _taskbarElement(context, multiplier: 1.75),
                          const SizedBox(width: 8),
                          _taskbarElement(context, multiplier: 1.75),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                model.label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: selected ? context.theme.foregroundColor : null,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Border borderStyle({bool isDarkMode = false}) {
    return Border.all(
      color: isDarkMode
          ? Colors.white.withOpacity(0.2)
          : Colors.black.withOpacity(0.2),
      width: 2,
    );
  }

  Container _taskbarElement(
    BuildContext context, {
    double multiplier = 1,
    bool shaded = false,
  }) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final hslBgc =
        HSLColor.fromColor(Theme.of(context).scaffoldBackgroundColor);
    return Container(
      width: 20 * multiplier,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(
          color: !isDarkMode
              ? Colors.black.withOpacity(0.2)
              : Colors.white.withOpacity(0.2),
          width: 2,
        ),
        color: shaded
            ? hslBgc
                .withLightness(
                  hslBgc.lightness > 0.5
                      ? hslBgc.lightness - 0.2
                      : hslBgc.lightness + 0.2,
                )
                .toColor()
            : hslBgc.toColor(),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
