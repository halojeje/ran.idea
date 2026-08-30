library;

import 'dart:convert';
import 'dart:math';

import 'generator_settings.dart';

/// Placeholder default saat belum ada ide yang di-pick/dihasilkan.
const String kPickerPlaceholder = 'Tekan tombol untuk memilih ide';

/// Data Model untuk mewakili satu kombinasi Ide dari CSV RAN.Idea
class RanIdeaItem {
  final String id;
  final String tipeOutput;
  final String temaIde;
  final String supergraphics;
  final String mainDesignStyle;
  final List<String> colorPaletteHex;
  final String mainFont;

  RanIdeaItem({
    required this.id,
    required this.tipeOutput,
    required this.temaIde,
    required this.supergraphics,
    required this.mainDesignStyle,
    required this.colorPaletteHex,
    this.mainFont = '',
  });

  /// Konversi dari Map JSON / Storage
  factory RanIdeaItem.fromMap(Map<String, dynamic> map) {
    return RanIdeaItem(
      id: map['id'] ?? '',
      tipeOutput: map['tipeOutput'] ?? '',
      temaIde: map['temaIde'] ?? '',
      supergraphics: map['supergraphics'] ?? '',
      mainDesignStyle: map['mainDesignStyle'] ?? '',
      colorPaletteHex: List<String>.from(map['colorPaletteHex'] ?? []),
      mainFont: map['mainFont'] ?? '',
    );
  }

  /// Konversi ke Map JSON / Storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipeOutput': tipeOutput,
      'temaIde': temaIde,
      'supergraphics': supergraphics,
      'mainDesignStyle': mainDesignStyle,
      'colorPaletteHex': colorPaletteHex,
      'mainFont': mainFont,
    };
  }

  /// Output judul/ringkasan teks ide
  String get displayTitle => '$temaIde - $mainDesignStyle';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RanIdeaItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Class State untuk mengelola daftar ide (Available, Eliminated, Selected, dsb)
class PickerState {
  final List<String> availableNames;
  final List<String> eliminatedNames;
  final String selectedName;
  final bool isPicking;
  final RanIdeaItem? currentIdea;

  PickerState({
    List<String>? availableNames,
    List<String>? eliminatedNames,
    this.selectedName = kPickerPlaceholder,
    this.isPicking = false,
    this.currentIdea,
  }) : availableNames = List<String>.unmodifiable(availableNames ?? const []),
       eliminatedNames = List<String>.unmodifiable(eliminatedNames ?? const []);

  PickerState copyWith({
    List<String>? availableNames,
    List<String>? eliminatedNames,
    String? selectedName,
    bool? isPicking,
    RanIdeaItem? currentIdea,
  }) {
    return PickerState(
      availableNames: availableNames ?? this.availableNames,
      eliminatedNames: eliminatedNames ?? this.eliminatedNames,
      selectedName: selectedName ?? this.selectedName,
      isPicking: isPicking ?? this.isPicking,
      currentIdea: currentIdea ?? this.currentIdea,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PickerState &&
        _listEquals(other.availableNames, availableNames) &&
        _listEquals(other.eliminatedNames, eliminatedNames) &&
        other.selectedName == selectedName &&
        other.isPicking == isPicking &&
        other.currentIdea == currentIdea;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(availableNames),
    Object.hashAll(eliminatedNames),
    selectedName,
    isPicking,
    currentIdea,
  );

  @override
  String toString() {
    return 'PickerState('
        'availableNames: $availableNames, '
        'eliminatedNames: $eliminatedNames, '
        'selectedName: $selectedName, '
        'isPicking: $isPicking, '
        'currentIdea: ${currentIdea?.displayTitle})';
  }
}

bool _listEquals(List<String> a, List<String> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

// -----------------------------------------------------------------------------
// HELPER LOGIC GENERATOR IDE RAN.IDEA DARI CSV DATA
// -----------------------------------------------------------------------------

/// Kumpulan opsi data berdasarkan dataset CSV RAN.Idea
class RanIdeaDataset {
  static const List<String> tipeOutput = [
    'Branding / Identity',
    'Poster Design',
    'Website Design',
    'UI/UX Mobile App',
    'Packaging Design',
    'Interior Design',
    'Editorial / Magazine',
    'Merchandise Design',
  ];

  static const List<String> temaIde = [
    'EcoSmart Energy',
    'Urban Mobility',
    'Cybernetic Fashion',
    'Retro Gaming Hub',
    'Zen Wellness',
    'Space Tourism',
    'Artisanal Coffee',
    'Futuristic Logistics',
  ];

  static const List<String> supergraphics = [
    'Bold Geometric',
    'Gradient Wash',
    'Illustrative Mural',
    'Optical Illusion',
    'Typo Wayfinding',
  ];

  static const List<String> mainDesignStyle = [
    'Japandi',
    'Bauhaus',
    'Utilitarian',
    'Bento grid',
    'Pixel art',
    'Memphis',
    'Y2K',
    'Pop art',
    'Art Nouveau',
    'Surrealism',
    'Bohemian / Boho',
    'Farmhouse / Cottagecore',
    'Coquette',
    'Graffiti',
    'Cybercore',
    'Vaporwave',
    'Scrapbook / Collage',
    'Brutalism',
    'Kitsch',
    'Mixed Media',
  ];

  static const List<String> mainFont = [
    'Poppins',
    'Montserrat',
    'Playfair Display',
    'Space Grotesk',
    'Inter',
    'DM Serif Display',
    'Bebas Neue',
    'Fraunces',
  ];

  static const List<List<String>> colorPalettes = [
    ['#4648D4', '#006B5F', '#825100', '#C7C4D7', '#EAEAEA'],
    ['#3E4E42', '#9E7E6B', '#D97757', '#E8A88A', '#F4ECE1'],
    ['#7FFFD4', '#E6E6FA', '#FFB800', '#000000', '#FFFFFF'],
    ['#FF5722', '#2196F3', '#4CAF50', '#FFEB3B', '#9C27B0'],
    ['#1A1A1A', '#F5F5F5', '#E63946', '#A8DADC', '#457B9D'],
  ];

  /// Menghasilkan 1 kombinasi ide acak lengkap dari data CSV.
  ///
  /// Dipertahankan untuk kompatibilitas kode lama. Untuk generator yang
  /// menghormati pengaturan manual/random per-field, gunakan [generateIdea].
  static RanIdeaItem generateRandomIdea() {
    return generateIdea(GeneratorSettings.defaults);
  }

  /// Menghasilkan 1 ide sesuai [settings]: field yang di-nonaktifkan
  /// (`included == false`) dikosongkan, field manual memakai nilai yang
  /// tersimpan, dan sisanya tetap diacak seperti biasa.
  static RanIdeaItem generateIdea(GeneratorSettings settings) {
    final rand = Random();

    String pickSingle(FieldSetting field, List<String> options) {
      if (!field.included) return '';
      final manualValue = field.manualValue;
      if (field.manual && manualValue != null && manualValue.isNotEmpty) {
        return manualValue;
      }
      return options[rand.nextInt(options.length)];
    }

    List<String> pickPalette(FieldSetting field) {
      if (!field.included) return const [];
      final manualPalette = field.manualPalette;
      if (field.manual && manualPalette != null && manualPalette.isNotEmpty) {
        return List<String>.from(manualPalette);
      }
      return colorPalettes[rand.nextInt(colorPalettes.length)];
    }

    return RanIdeaItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tipeOutput: pickSingle(settings.output, tipeOutput),
      temaIde: pickSingle(settings.conceptTitle, temaIde),
      supergraphics: pickSingle(settings.supergraphics, supergraphics),
      mainDesignStyle: pickSingle(settings.theme, mainDesignStyle),
      colorPaletteHex: pickPalette(settings.colorPalette),
      mainFont: pickSingle(settings.font, mainFont),
    );
  }
}

// -----------------------------------------------------------------------------
// PURE LOGIC FUNCTIONS FOR PICKER
// -----------------------------------------------------------------------------

/// Memilih opsi secara manual dari availableNames
PickerState manualPick(PickerState state, String name) {
  if (state.isPicking ||
      state.availableNames.isEmpty ||
      !state.availableNames.contains(name)) {
    return state;
  }

  final newAvailable = List<String>.from(state.availableNames);
  final newEliminated = List<String>.from(state.eliminatedNames);

  newAvailable.remove(name);
  newEliminated.insert(0, name);

  return state.copyWith(
    availableNames: newAvailable,
    eliminatedNames: newEliminated,
    selectedName: name,
  );
}

/// Mereset State Picker ke kondisi awal
PickerState resetState(PickerState state, List<String> allNames) {
  return state.copyWith(
    availableNames: List<String>.from(allNames),
    eliminatedNames: const <String>[],
    selectedName: kPickerPlaceholder,
    currentIdea: null,
  );
}

// -----------------------------------------------------------------------------
// PERSISTENCE KEYS & PAYLOAD SERIALIZATION
// -----------------------------------------------------------------------------

const String kSelectedNameKey = 'selectedName';
const String kAvailableNamesKey = 'availableNames';
const String kEliminatedNamesKey = 'eliminatedNames';
const String kCurrentIdeaKey = 'currentIdea';

/// Membuat payload JSON-friendly dari [PickerState]
Map<String, dynamic> buildPersistencePayload(PickerState state) {
  return <String, dynamic>{
    kSelectedNameKey: state.selectedName,
    kAvailableNamesKey: List<String>.from(state.availableNames),
    kEliminatedNamesKey: List<String>.from(state.eliminatedNames),
    if (state.currentIdea != null)
      kCurrentIdeaKey: jsonEncode(state.currentIdea!.toMap()),
  };
}

/// Merekonstruksi [PickerState] dari payload penyimpanan
PickerState? pickerStateFromPayload(Map<String, dynamic>? payload) {
  if (payload == null) return null;
  if (!payload.containsKey(kSelectedNameKey) ||
      !payload.containsKey(kAvailableNamesKey) ||
      !payload.containsKey(kEliminatedNamesKey)) {
    return null;
  }

  final dynamic rawSelected = payload[kSelectedNameKey];
  if (rawSelected is! String) return null;

  final List<String>? available = _asStringList(payload[kAvailableNamesKey]);
  final List<String>? eliminated = _asStringList(payload[kEliminatedNamesKey]);
  if (available == null || eliminated == null) return null;

  RanIdeaItem? idea;
  if (payload.containsKey(kCurrentIdeaKey) &&
      payload[kCurrentIdeaKey] != null) {
    try {
      final map = jsonDecode(payload[kCurrentIdeaKey] as String);
      idea = RanIdeaItem.fromMap(map);
    } catch (_) {}
  }

  return PickerState(
    availableNames: available,
    eliminatedNames: eliminated,
    selectedName: rawSelected,
    currentIdea: idea,
  );
}

/// Memuat [PickerState] dengan penanganan fallback aman
PickerState loadPickerState(
  Map<String, dynamic>? payload,
  List<String> allNames,
) {
  if (payload != null && payload.isNotEmpty) {
    final PickerState? restored = pickerStateFromPayload(payload);
    if (restored != null) {
      return restored;
    }
  }
  return PickerState(
    availableNames: List<String>.from(allNames),
    eliminatedNames: const <String>[],
    selectedName: kPickerPlaceholder,
  );
}

/// Helper validasi tipe `List<String>`
List<String>? _asStringList(dynamic value) {
  if (value is! List) return null;
  final result = <String>[];
  for (final element in value) {
    if (element is! String) return null;
    result.add(element);
  }
  return result;
}
