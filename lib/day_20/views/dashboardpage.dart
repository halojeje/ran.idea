import 'dart:async';
import 'dart:io';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ran_idea_flutter/day_20/database/preferences.dart';
import 'package:ran_idea_flutter/day_20/models/favorite_item_model.dart';
import 'package:ran_idea_flutter/day_20/providers/favorite_provider.dart';
import 'package:ran_idea_flutter/random_picker/picker_logic.dart';

class Dashboardpage extends StatefulWidget {
  const Dashboardpage({super.key});

  @override
  State<Dashboardpage> createState() => _DashboardpageState();
}

class _DashboardpageState extends State<Dashboardpage> {
  File? _selectedImage;
  bool _isPicking = false;
  final ImagePicker _picker = ImagePicker();

  // Data User Sesi
  String? _userProfilePath;

  // Controller & Logic Generator Ide
  late final ConfettiController _confettiController = ConfettiController(
    duration: const Duration(seconds: 4),
  );
  Timer? _timer;
  RanIdeaItem _currentIdea = RanIdeaDataset.generateRandomIdea();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserProfile();
  }

  // MEMUAT DATA SESI PROFIL
  Future<void> _loadUserProfile() async {
    final imagePath = await PreferenceHelper.getProfileImage();
    if (mounted) {
      setState(() {
        _userProfilePath = imagePath;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _confettiController.dispose();
    super.dispose();
  }

  void _generateRandomIdea() {
    if (_isPicking) return;

    setState(() {
      _isPicking = true;
      _selectedImage = null;
    });

    int count = 0;
    const int totalCycles = 20;

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _currentIdea = RanIdeaDataset.generateRandomIdea();
      });

      count++;
      if (count >= totalCycles) {
        timer.cancel();
        _confettiController.play();
        setState(() {
          _isPicking = false;
        });
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Upload / Ganti Gambar",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC107),
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                      icon: const Icon(Icons.photo_library),
                      label: Text(
                        "Galeri",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: Text(
                        "Kamera",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🟡 MODAL DIALOG "WHAT IS RAN IDEA ANYWAY" (Sesuai main page-modal2.png)
  void _showWhatIsRanIdeaModal() {
    int currentStep = 0;
    final List<Map<String, String>> modalContents = [
      {
        "title": "What is Ran.Idea",
        "description":
            "This is App for doing idea for your fast project and if you want random creativity for your brain.",
      },
      {
        "title": "Unleash Creativity",
        "description":
            "Generate unique design styles, color palettes, and supergraphics in seconds.",
      },
    ];

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 40,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.black, width: 2.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(6, 6),
                      blurRadius: 0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tombol Silang (Close)
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Logo / Character Maskot
                    SizedBox(
                      height: 120,
                      child: Image.asset(
                        'assets/images/tes_logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.face,
                              size: 80,
                              color: Colors.black,
                            ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Judul Modal
                    Text(
                      modalContents[currentStep]["title"]!,
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Navigasi Panah + Deskripsi
                    Row(
                      children: [
                        IconButton(
                          onPressed: currentStep > 0
                              ? () {
                                  setModalState(() {
                                    currentStep--;
                                  });
                                }
                              : null,
                          icon: Icon(
                            Icons.arrow_back,
                            color: currentStep > 0
                                ? Colors.black
                                : Colors.grey[400],
                            size: 24,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            modalContents[currentStep]["description"]!,
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                          onPressed: currentStep < modalContents.length - 1
                              ? () {
                                  setModalState(() {
                                    currentStep++;
                                  });
                                }
                              : null,
                          icon: Icon(
                            Icons.arrow_forward,
                            color: currentStep < modalContents.length - 1
                                ? Colors.black
                                : Colors.grey[400],
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Tombol CLOSE
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC107),
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(color: Colors.black, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(3, 3),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "CLOSE",
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _hexToColor(String hexCode) {
    final buffer = StringBuffer();
    if (hexCode.length == 6 || hexCode.length == 7) buffer.write('ff');
    buffer.write(hexCode.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final isFav = favoriteProvider.isFavorite(_currentIdea.id);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header Yellow Banner (Sesuai Layout main page-modal.png)
                  Container(
                    color: const Color(0xFFFFC107),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        // Row 1: Logo & Profil Avatar Dynamic
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "RAN.IDEA",
                              style: TextStyle(
                                fontFamily: 'Montserrat-Black',
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                                color: Colors.black,
                              ),
                            ),
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.grey[400],
                              child: ClipOval(
                                child:
                                    _userProfilePath != null &&
                                        _userProfilePath!.isNotEmpty &&
                                        File(_userProfilePath!).existsSync()
                                    ? Image.file(
                                        File(_userProfilePath!),
                                        width: 36,
                                        height: 36,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/images/apple.png',
                                        width: 36,
                                        height: 36,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                CircleAvatar(
                                                  radius: 18,
                                                  backgroundColor:
                                                      Colors.grey[400],
                                                  child: const Icon(
                                                    Icons.person,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Row 2: Status Indicator Buttons (Main Page UI)
                        Row(
                          children: [
                            // Maskot Icon
                            Container(
                              width: 28,
                              height: 28,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: const BoxDecoration(
                                color: Color(0xFF00B0FF),
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/tes_logo.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.face,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                ),
                              ),
                            ),

                            // Badge 1: DOING HIS BEST NOW
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "DOING HIS BEST NOW",
                                style: GoogleFonts.montserrat(
                                  color: const Color(0xFFFFC107),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Badge 2: WHAT IS RAN IDEA ANYWAY (Clickable)
                            Expanded(
                              child: GestureDetector(
                                onTap: _showWhatIsRanIdeaModal,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.star_outline_rounded,
                                        size: 14,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          "WHAT IS RAN IDEA ANYWAY",
                                          style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.edit_outlined,
                                        size: 13,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 2. Main Card Container
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black, width: 2.5),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(2, 2),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabelText("OUTPUT"),
                                    const SizedBox(height: 2),
                                    Text(
                                      _currentIdea.tipeOutput,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF4648D4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  final item = FavoriteItem(
                                    id: _currentIdea.id,
                                    category: _currentIdea.tipeOutput,
                                    title: _currentIdea.temaIde,
                                    theme: _currentIdea.mainDesignStyle,
                                    supergraphics: _currentIdea.supergraphics,
                                    imagePath: _getSupergraphicsImage(
                                      _currentIdea.supergraphics,
                                    ),
                                    colors: _currentIdea.colorPaletteHex
                                        .map((hex) => _hexToColor(hex))
                                        .toList(),
                                    hexColors: _currentIdea.colorPaletteHex,
                                  );
                                  favoriteProvider.toggleFavorite(item);
                                },
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      isFav
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          _buildLabelText("CONCEPT TITLE"),
                          const SizedBox(height: 2),
                          _buildValueText(_currentIdea.temaIde),
                          const SizedBox(height: 14),

                          _buildLabelText("THEME"),
                          const SizedBox(height: 2),
                          _buildValueText(_currentIdea.mainDesignStyle),
                          const SizedBox(height: 14),

                          _buildLabelText("SUPERGRAPHICS"),
                          const SizedBox(height: 2),
                          _buildValueText(_currentIdea.supergraphics),
                          const SizedBox(height: 10),

                          GestureDetector(
                            onTap: _showImagePickerModal,
                            child: Container(
                              height: 125,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(2, 2),
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: _selectedImage != null
                                    ? Image.file(
                                        _selectedImage!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      )
                                    : Image.asset(
                                        _getSupergraphicsImage(
                                          _currentIdea.supergraphics,
                                        ),
                                        key: ValueKey(
                                          _currentIdea.supergraphics,
                                        ),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorBuilder:
                                            (
                                              context,
                                              error,
                                              stackTrace,
                                            ) => Image.asset(
                                              _getThemeImage(
                                                _currentIdea.mainDesignStyle,
                                              ),
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Container(
                                                    color: Colors.grey[200],
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.image,
                                                        size: 40,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                            ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          _buildLabelText("COLOR PALETTE"),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: _currentIdea.colorPaletteHex.map((hex) {
                              return _buildCircleColorBox(
                                _hexToColor(hex),
                                hex,
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 24),

                          Container(
                            width: double.infinity,
                            height: 52,
                            decoration: BoxDecoration(
                              color: _isPicking
                                  ? Colors.grey.shade400
                                  : const Color(0xFFFFC107),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Colors.black,
                                width: 2.5,
                              ),
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
                                onTap: _isPicking ? null : _generateRandomIdea,
                                child: Center(
                                  child: Text(
                                    _isPicking
                                        ? "GENERATING IDEA..."
                                        : "SHOW ME THE MOST RANDOM IDEA",
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat-Medium',
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Color(0xFFFFC107),
                  Color(0xFF00B0FF),
                  Colors.redAccent,
                  Colors.green,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelText(String text) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: 11,
        color: Colors.grey[500],
        fontWeight: FontWeight.w500,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildValueText(String text) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildCircleColorBox(Color color, String hex) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black26, width: 1),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          hex,
          style: GoogleFonts.montserrat(
            fontSize: 10,
            color: Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _getThemeImage(String themeName) {
    final cleanName = themeName.toLowerCase().trim();

    if (cleanName.contains('japandi')) {
      return 'assets/images/design/d_japandi.jpg';
    }
    if (cleanName.contains('bauhaus')) {
      return 'assets/images/design/d_bauhaus.jpg';
    }
    if (cleanName.contains('utilitarian')) {
      return 'assets/images/design/d_utilitarian.jpg';
    }
    if (cleanName.contains('bento')) {
      return 'assets/images/design/d_bentogrid.jpg';
    }
    if (cleanName.contains('pixel')) {
      return 'assets/images/design/d_pixelart.jpg';
    }
    if (cleanName.contains('memphis')) {
      return 'assets/images/design/d_memphis.jpg';
    }
    if (cleanName.contains('y2k')) return 'assets/images/design/d_y2k.jpg';
    if (cleanName.contains('pop')) return 'assets/images/design/d_popart.jpg';
    if (cleanName.contains('nouveau') || cleanName.contains('art deco')) {
      return 'assets/images/design/d_artnouveau.jpg';
    }
    if (cleanName.contains('surreal')) {
      return 'assets/images/design/d_surrealism.jpg';
    }
    if (cleanName.contains('boho') || cleanName.contains('bohemian')) {
      return 'assets/images/design/d_boho.jpg';
    }
    if (cleanName.contains('farmhouse') ||
        cleanName.contains('cottage') ||
        cleanName.contains('organic')) {
      return 'assets/images/design/d_farmhouse.jpg';
    }
    if (cleanName.contains('coquette')) {
      return 'assets/images/design/d_coquette.jpg';
    }
    if (cleanName.contains('graffiti')) {
      return 'assets/images/design/d_graffiti.jpg';
    }
    if (cleanName.contains('cyber')) {
      return 'assets/images/design/d_cybercore.jpg';
    }
    if (cleanName.contains('vaporwave')) {
      return 'assets/images/design/d_vaporwave.jpg';
    }
    if (cleanName.contains('scrapbook') || cleanName.contains('collage')) {
      return 'assets/images/design/d_scrapbookcollage.jpg';
    }
    if (cleanName.contains('brutalism') || cleanName.contains('brutalist')) {
      return 'assets/images/design/d_brutalism.jpg';
    }
    if (cleanName.contains('kitsch')) {
      return 'assets/images/design/d_kitsch.jpg';
    }
    if (cleanName.contains('mixed')) {
      return 'assets/images/design/d_mixedmedia.jpg';
    }

    return 'assets/images/design/d_bauhaus.jpg';
  }

  String _getSupergraphicsImage(String sgName) {
    final cleanName = sgName.toLowerCase().trim();

    if (cleanName.contains('bold') || cleanName.contains('geometric')) {
      return 'assets/images/supergraphics/sg_boldgeometric.png';
    }
    if (cleanName.contains('gradient') ||
        cleanName.contains('wash') ||
        cleanName.contains('distortion')) {
      return 'assets/images/supergraphics/sg_gradientwash.png';
    }
    if (cleanName.contains('mural') || cleanName.contains('illustrative')) {
      return 'assets/images/supergraphics/sg_illustrativemural.png';
    }
    if (cleanName.contains('optical') || cleanName.contains('illusion')) {
      return 'assets/images/supergraphics/sg_opticalillusion.png';
    }
    if (cleanName.contains('typo') ||
        cleanName.contains('wayfinding') ||
        cleanName.contains('grid') ||
        cleanName.contains('typography')) {
      return 'assets/images/supergraphics/sg_typowayfinding.png';
    }

    return 'assets/images/supergraphics/sg_boldgeometric.png';
  }
}
