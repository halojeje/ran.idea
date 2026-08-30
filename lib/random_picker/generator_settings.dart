library;

/// Configuration for a single generator field (Output, Concept Title, Theme,
/// Supergraphics, Color Palette, Font).
///
/// - [included]: whether this field is generated/shown at all (this is what
///   the checkboxes in "Edit Generator" control).
/// - [manual]: when true, the field uses a fixed value instead of a random
///   pick from [RanIdeaDataset].
/// - [manualValue]: the fixed value for single-value fields (Output, Concept
///   Title, Theme, Supergraphics, Font).
/// - [manualPalette]: the fixed value for the Color Palette field, since a
///   palette is a list of hex colors rather than a single string.
class FieldSetting {
  final bool included;
  final bool manual;
  final String? manualValue;
  final List<String>? manualPalette;

  const FieldSetting({
    this.included = true,
    this.manual = false,
    this.manualValue,
    this.manualPalette,
  });

  FieldSetting copyWith({
    bool? included,
    bool? manual,
    String? manualValue,
    List<String>? manualPalette,
  }) {
    return FieldSetting(
      included: included ?? this.included,
      manual: manual ?? this.manual,
      manualValue: manualValue ?? this.manualValue,
      manualPalette: manualPalette ?? this.manualPalette,
    );
  }

  Map<String, dynamic> toMap() => {
    'included': included,
    'manual': manual,
    'manualValue': manualValue,
    'manualPalette': manualPalette,
  };

  factory FieldSetting.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const FieldSetting();
    final rawPalette = map['manualPalette'];
    return FieldSetting(
      included: map['included'] as bool? ?? true,
      manual: map['manual'] as bool? ?? false,
      manualValue: map['manualValue'] as String?,
      manualPalette: rawPalette is List
          ? List<String>.from(rawPalette.map((e) => e.toString()))
          : null,
    );
  }
}

/// Full generator configuration: one [FieldSetting] per generatable field.
class GeneratorSettings {
  final FieldSetting output;
  final FieldSetting conceptTitle;
  final FieldSetting theme;
  final FieldSetting supergraphics;
  final FieldSetting colorPalette;
  final FieldSetting font;

  const GeneratorSettings({
    this.output = const FieldSetting(),
    this.conceptTitle = const FieldSetting(),
    this.theme = const FieldSetting(),
    this.supergraphics = const FieldSetting(),
    this.colorPalette = const FieldSetting(),
    this.font = const FieldSetting(),
  });

  /// All fields included, all random — matches the app's out-of-the-box
  /// behaviour before the user touches "Edit Generator".
  static const GeneratorSettings defaults = GeneratorSettings();

  GeneratorSettings copyWith({
    FieldSetting? output,
    FieldSetting? conceptTitle,
    FieldSetting? theme,
    FieldSetting? supergraphics,
    FieldSetting? colorPalette,
    FieldSetting? font,
  }) {
    return GeneratorSettings(
      output: output ?? this.output,
      conceptTitle: conceptTitle ?? this.conceptTitle,
      theme: theme ?? this.theme,
      supergraphics: supergraphics ?? this.supergraphics,
      colorPalette: colorPalette ?? this.colorPalette,
      font: font ?? this.font,
    );
  }

  Map<String, dynamic> toMap() => {
    'output': output.toMap(),
    'conceptTitle': conceptTitle.toMap(),
    'theme': theme.toMap(),
    'supergraphics': supergraphics.toMap(),
    'colorPalette': colorPalette.toMap(),
    'font': font.toMap(),
  };

  factory GeneratorSettings.fromMap(Map<String, dynamic>? map) {
    if (map == null) return defaults;
    return GeneratorSettings(
      output: FieldSetting.fromMap(map['output'] as Map<String, dynamic>?),
      conceptTitle: FieldSetting.fromMap(
        map['conceptTitle'] as Map<String, dynamic>?,
      ),
      theme: FieldSetting.fromMap(map['theme'] as Map<String, dynamic>?),
      supergraphics: FieldSetting.fromMap(
        map['supergraphics'] as Map<String, dynamic>?,
      ),
      colorPalette: FieldSetting.fromMap(
        map['colorPalette'] as Map<String, dynamic>?,
      ),
      font: FieldSetting.fromMap(map['font'] as Map<String, dynamic>?),
    );
  }
}
