import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ran_idea_flutter/random_picker/generator_settings.dart';
import 'package:ran_idea_flutter/random_picker/generator_settings_store.dart';
import 'package:ran_idea_flutter/random_picker/picker_logic.dart';

class _Palette {
  static const Color yellow = Color(0xFFFFC107); // sama dengan header dashboard
  static const Color purple = Color(0xFF5B4FE9);
  static const Color ink = Colors.black;
  static const Color subtitle = Color(0xFF8A8A8E);
  static const Color divider = Color(0xFFE9E9EC);
  // Latar belakang baris random/manual di dalam kartu, sesuai desain UI.
  static const Color switchRowBackground = Color(0xFFEAE8FC);
  static const Color cardShadow = Color(0x14000000);
}

/// "EDIT GENERATOR" screen.
///
/// Each of the six fields (Output, Concept Title, Theme, Supergraphics,
/// Color Palette, Font) can be:
///  - included / excluded from generated ideas (the checkbox), and
///  - set to Random (default) or Manual with a fixed value.
///
/// Returns `true` via [Navigator.pop] when settings were saved, so the
/// caller can regenerate the current idea with the new configuration.
class Editgeneratorpage extends StatefulWidget {
  const Editgeneratorpage({super.key});

  @override
  State<Editgeneratorpage> createState() => _EditGeneratorpageState();
}

class _EditGeneratorpageState extends State<Editgeneratorpage> {
  GeneratorSettings _settings = GeneratorSettings.defaults;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loaded = await GeneratorSettingsStore.load();
    if (!mounted) return;
    setState(() {
      _settings = loaded;
      _loading = false;
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await GeneratorSettingsStore.save(_settings);
    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: _Palette.yellow,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _Palette.ink),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: Text(
          'EDIT GENERATOR',
          style: GoogleFonts.montserrat(
            color: _Palette.ink,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.4,
          ),
        ),
        centerTitle: false,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              children: [
                _fieldTile(
                  label: 'Output',
                  setting: _settings.output,
                  options: RanIdeaDataset.tipeOutput,
                  onChanged: (next) => setState(
                    () => _settings = _settings.copyWith(output: next),
                  ),
                ),
                _fieldTile(
                  label: 'Concept Title',
                  setting: _settings.conceptTitle,
                  options: RanIdeaDataset.temaIde,
                  onChanged: (next) => setState(
                    () => _settings = _settings.copyWith(conceptTitle: next),
                  ),
                ),
                _fieldTile(
                  label: 'Theme',
                  setting: _settings.theme,
                  options: RanIdeaDataset.mainDesignStyle,
                  onChanged: (next) => setState(
                    () => _settings = _settings.copyWith(theme: next),
                  ),
                ),
                _fieldTile(
                  label: 'Supergraphics',
                  setting: _settings.supergraphics,
                  options: RanIdeaDataset.supergraphics,
                  onChanged: (next) => setState(
                    () => _settings = _settings.copyWith(supergraphics: next),
                  ),
                ),
                _paletteFieldTile(
                  label: 'Color Palette',
                  setting: _settings.colorPalette,
                  onChanged: (next) => setState(
                    () => _settings = _settings.copyWith(colorPalette: next),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: _saving ? Colors.grey.shade400 : _Palette.yellow,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black, width: 2.5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _saving ? null : _save,
              child: Center(
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : Text(
                        'SET THE CONTENT',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Kartu putih dengan shadow yang membungkus label+checkbox di bagian atas
  /// dan baris random/manual (dengan latar lavender) di bagian bawah, sesuai
  /// desain UI. [child] adalah konten opsional yang tampil di bawah baris
  /// switch (dropdown teks atau swatch palet warna) saat mode manual aktif.
  Widget _cardShell({
    required String label,
    required FieldSetting setting,
    required ValueChanged<bool> onIncludedChanged,
    required ValueChanged<bool> onManualChanged,
    Widget? manualChild,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: _Palette.cardShadow,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: _Palette.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Checkbox(
                  value: setting.included,
                  activeColor: _Palette.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (v) => onIncludedChanged(v ?? true),
                ),
              ],
            ),
          ),
          if (setting.included) ...[
            Container(
              width: double.infinity,
              color: _Palette.switchRowBackground,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'random',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: _Palette.subtitle,
                    ),
                  ),
                  Switch(
                    value: setting.manual,
                    activeThumbColor: Colors.white,
                    activeTrackColor: _Palette.purple,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: _Palette.purple,
                    onChanged: onManualChanged,
                  ),
                  Text(
                    'manual',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: _Palette.subtitle,
                    ),
                  ),
                ],
              ),
            ),
            if (setting.manual && manualChild != null)
              Container(
                width: double.infinity,
                color: _Palette.switchRowBackground,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: manualChild,
              ),
          ],
        ],
      ),
    );
  }

  /// Kartu untuk field bernilai tunggal: checkbox, switch random/manual, dan
  /// (saat manual) dropdown pilihan dari dataset.
  Widget _fieldTile({
    required String label,
    required FieldSetting setting,
    required List<String> options,
    required ValueChanged<FieldSetting> onChanged,
  }) {
    return _cardShell(
      label: label,
      setting: setting,
      onIncludedChanged: (v) => onChanged(setting.copyWith(included: v)),
      onManualChanged: (v) => onChanged(setting.copyWith(manual: v)),
      manualChild: DropdownButtonFormField<String>(
        initialValue: options.contains(setting.manualValue)
            ? setting.manualValue
            : null,
        isExpanded: true,
        hint: const Text('Pilih nilai manual'),
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: OutlineInputBorder(),
        ),
        items: options
            .map((o) => DropdownMenuItem(value: o, child: Text(o)))
            .toList(),
        onChanged: (v) => onChanged(setting.copyWith(manualValue: v)),
      ),
    );
  }

  /// Kartu untuk field Color Palette: sama seperti [_fieldTile], tetapi
  /// pemilihan manual menampilkan swatch palet, bukan dropdown teks.
  Widget _paletteFieldTile({
    required String label,
    required FieldSetting setting,
    required ValueChanged<FieldSetting> onChanged,
  }) {
    return _cardShell(
      label: label,
      setting: setting,
      onIncludedChanged: (v) => onChanged(setting.copyWith(included: v)),
      onManualChanged: (v) => onChanged(setting.copyWith(manual: v)),
      manualChild: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: RanIdeaDataset.colorPalettes.map((palette) {
          final isSelected =
              setting.manualPalette != null &&
              _sameList(setting.manualPalette!, palette);
          return GestureDetector(
            onTap: () => onChanged(setting.copyWith(manualPalette: palette)),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: isSelected ? _Palette.purple : _Palette.divider,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: palette
                    .map(
                      (hex) => Container(
                        width: 16,
                        height: 16,
                        margin: const EdgeInsets.only(right: 2),
                        decoration: BoxDecoration(
                          color: _colorFromHex(hex),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  bool _sameList(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Color _colorFromHex(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }
}
