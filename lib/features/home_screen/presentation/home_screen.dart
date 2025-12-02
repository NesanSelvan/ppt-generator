import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppt_generator/core/constants/app_routes.dart';
import 'package:ppt_generator/core/theme/bloc/theme_bloc.dart';
import 'package:ppt_generator/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ppt_generator/features/auth/presentation/bloc/auth_event.dart';
import 'package:ppt_generator/features/auth/presentation/bloc/auth_state.dart';
import 'package:ppt_generator/features/home_screen/presentation/bloc/ppt_generator_bloc.dart';
import 'package:ppt_generator/features/home_screen/presentation/bloc/ppt_generator_event.dart';
import 'package:ppt_generator/features/home_screen/presentation/bloc/ppt_generator_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final topicController = TextEditingController();
  final audienceController = TextEditingController();
  final extraInfoController = TextEditingController();

  String templateType = 'Default';

  double slideCount = 10;
  String language = 'en';
  String templateStyle = 'bullet-point1';
  String model = 'gpt-3.5';

  bool aiImages = true;
  bool imageOnEachSlide = true;
  bool googleImages = false;
  bool googleText = false;

  final watermarkWidthController = TextEditingController();
  final watermarkHeightController = TextEditingController();
  final watermarkUrlController = TextEditingController();
  String watermarkPosition = 'Bottom Right';

  final List<String> languages = ['en', 'es', 'fr', 'de', 'it', 'pt'];
  final List<String> models = ['gpt-3.5', 'gpt-4'];
  final List<String> watermarkPositions = [
    'Top Left',
    'Top Right',
    'Bottom Left',
    'Bottom Right',
  ];

  final List<String> defaultTemplates = [
    'bullet-point1',
    'bullet-point2',
    'bullet-point4',
    'bullet-point5',
    'bullet-point6',
    'bullet-point7',
    'bullet-point8',
    'bullet-point9',
    'bullet-point10',
    'custom2',
    'custom3',
    'custom4',
    'custom5',
    'custom6',
    'custom7',
    'custom8',
    'custom9',
    'verticalBulletPoint1',
    'verticalCustom1',
  ];

  final List<String> editableTemplates = [
    'ed-bullet-point9',
    'ed-bullet-point7',
    'ed-bullet-point6',
    'ed-bullet-point5',
    'ed-bullet-point2',
    'ed-bullet-point4',
    'ed-bullet-point1',
    'custom gold 1',
    'custom Dark 1',
    'custom sync 1',
    'custom sync 2',
    'custom sync 3',
    'custom sync 4',
    'custom sync 5',
    'custom sync 6',
    'custom-ed-7',
    'custom-ed-8',
    'custom-ed-9',
    'custom-ed-10',
    'custom-ed-11',
    'custom-ed-12',
    'pitchdeckorignal',
    'pitch-deck-2',
    'pitch-deck-3',
  ];

  List<String> get currentTemplateOptions =>
      templateType == 'Default' ? defaultTemplates : editableTemplates;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Create Presentation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                String email = '';
                String name = '';
                if (state is AuthAuthenticated) {
                  email = state.user.email ?? '';
                  name = (state.user.userMetadata?['name'] ?? '').toString();
                }

                final bool isDark =
                    Theme.of(context).brightness == Brightness.dark;
                final Color headerBg = isDark
                    ? Colors.grey[900]!
                    : Colors.black;
                final Color headerText = Colors.white;
                final Color avatarBg = isDark
                    ? Colors.grey[700]!
                    : Colors.white;
                final Color avatarText = isDark ? Colors.white : Colors.black;

                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 24,
                    bottom: 28,
                    left: 20,
                    right: 20,
                  ),
                  decoration: BoxDecoration(color: headerBg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: avatarBg,
                        child: name.isNotEmpty
                            ? Text(
                                name[0].toUpperCase(),
                                style: TextStyle(
                                  color: avatarText,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Icon(Icons.person, color: avatarText, size: 36),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        name.isNotEmpty ? name : 'Welcome',
                        style: TextStyle(
                          color: headerText,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email.isNotEmpty ? email : 'No email',
                        style: TextStyle(
                          color: headerText.withOpacity(0.7),
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  _buildDrawerSectionTitle('Settings'),
                  const SizedBox(height: 8),

                  BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, state) {
                      final bool isDark = state.themeMode == ThemeMode.dark;
                      return _buildDrawerMenuItem(
                        icon: isDark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        title: 'Appearance',
                        subtitle: isDark ? 'Dark mode' : 'Light mode',
                        trailing: Switch.adaptive(
                          value: isDark,
                          onChanged: (_) {
                            context.read<ThemeBloc>().add(ToggleTheme());
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  _buildDrawerSectionTitle('Account'),
                  const SizedBox(height: 8),

                  _buildDrawerMenuItem(
                    icon: Icons.history_rounded,
                    title: 'History',
                    subtitle: 'View past presentations',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(AppRoutes.history_screen);
                    },
                  ),
                ],
              ),
            ),

            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.5),
                    ),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              context.read<AuthBloc>().add(
                                AuthLogoutRequested(),
                              );
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                AppRoutes.login_screen,
                                (route) => false,
                              );
                            },
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_rounded, color: Colors.red, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionCard(
                      title: "Topic & Audience",
                      icon: Icons.topic_outlined,
                      children: [
                        _buildTextField(
                          controller: topicController,
                          label: 'Topic',
                          hint: 'e.g., The Future of AI',
                          icon: Icons.lightbulb_outline,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: audienceController,
                          label: 'Audience',
                          hint: 'e.g., Students, Investors',
                          icon: Icons.people_outline,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: extraInfoController,
                          label: 'Extra Info Source',
                          hint: 'e.g., Focus on recent developments',
                          icon: Icons.info_outline,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSectionCard(
                      title: "Template Configuration",
                      icon: Icons.dashboard_customize_outlined,
                      children: [
                        _buildTemplateTypeSelector(),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown(
                                label: 'Language',
                                value: language,
                                items: languages,
                                onChanged: (v) => setState(() => language = v!),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDropdown(
                                label: 'Style',
                                value: templateStyle,
                                items: currentTemplateOptions,
                                onChanged: (v) =>
                                    setState(() => templateStyle = v!),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown(
                          label: 'AI Model',
                          value: model,
                          items: models,
                          onChanged: (v) => setState(() => model = v!),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Slide Count",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  inactiveTrackColor:
                                      Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.grey[300]
                                      : Colors.grey[700],
                                  thumbColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  overlayColor: Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.1),
                                  trackHeight: 4.0,
                                ),
                                child: Slider(
                                  value: slideCount,
                                  min: 1,
                                  max: 50,
                                  divisions: 49,
                                  label: slideCount.round().toString(),
                                  onChanged: (value) =>
                                      setState(() => slideCount = value),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                slideCount.round().toString(),
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSectionCard(
                      title: "Content Options",
                      icon: Icons.settings_suggest_outlined,
                      children: [
                        _buildSwitchTile(
                          "AI Images",
                          "Generate relevant images using AI",
                          aiImages,
                          (v) => setState(() => aiImages = v),
                        ),
                        _buildSwitchTile(
                          "Image per Slide",
                          "Include an image on every slide",
                          imageOnEachSlide,
                          (v) => setState(() => imageOnEachSlide = v),
                        ),
                        _buildSwitchTile(
                          "Google Images",
                          "Fetch images from Google",
                          googleImages,
                          (v) => setState(() => googleImages = v),
                        ),
                        _buildSwitchTile(
                          "Google Text",
                          "Fetch content from Google",
                          googleText,
                          (v) => setState(() => googleText = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ExpansionTile(
                      title: const Text(
                        "Watermark Settings (Optional)",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      leading: const Icon(Icons.branding_watermark_outlined),
                      childrenPadding: const EdgeInsets.all(16),
                      backgroundColor: Theme.of(context).cardColor,
                      collapsedBackgroundColor: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: watermarkWidthController,
                                label: 'Width',
                                hint: 'e.g. 100',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                controller: watermarkHeightController,
                                label: 'Height',
                                hint: 'e.g. 50',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: watermarkUrlController,
                          label: 'Brand URL',
                          hint: 'https://example.com/logo.png',
                          icon: Icons.link,
                        ),
                        const SizedBox(height: 12),
                        _buildDropdown(
                          label: 'Position',
                          value: watermarkPosition,
                          items: watermarkPositions,
                          onChanged: (v) =>
                              setState(() => watermarkPosition = v!),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null
            ? Icon(icon, color: Colors.grey[600], size: 20)
            : null,
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.light
            ? Colors.grey[50]
            : Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[50]
                : Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              menuMaxHeight: 300,
              borderRadius: BorderRadius.circular(10),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey[100]
            : Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTypeOption('Default', templateType == 'Default', () {
              setState(() {
                templateType = 'Default';
                templateStyle = defaultTemplates.first;
              });
            }),
          ),
          Expanded(
            child: _buildTypeOption('Editable', templateType == 'Editable', () {
              setState(() {
                templateType = 'Editable';
                templateStyle = editableTemplates.first;
              });
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOption(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).cardColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.black,
            activeTrackColor: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: Theme.of(context).hintColor,
        ),
      ),
    );
  }

  Widget _buildDrawerMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color iconBgColor = isDark ? Colors.grey[800]! : Colors.grey[100]!;
    final Color iconColor = isDark ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.grey[800]!.withOpacity(0.5)
                  : Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: iconColor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing,
                if (trailing == null && onTap != null)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BlocListener<PptGeneratorBloc, PptGeneratorState>(
        listener: (context, state) {
          if (state is PptGeneratorLoading) {
            Navigator.of(context).pushNamed(AppRoutes.loading_screen);
          } else if (state is PptGeneratorSuccess) {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.ppt_viewer_screen,
              arguments: state.pptUrl,
            );
          } else if (state is PptGeneratorFailure) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            elevation: 0,
          ),
          onPressed: () {
            final topic = topicController.text.trim();

            if (topic.isNotEmpty) {
              context.read<PptGeneratorBloc>().add(
                GeneratePptRequested(
                  topic: topic,
                  audience: audienceController.text.trim(),
                  slideCount: slideCount.toInt(),
                  language: language,
                  templateStyle: templateStyle,
                  model: model,
                  aiImages: aiImages,
                  imageOnEachSlide: imageOnEachSlide,
                  googleImages: googleImages,
                  googleText: googleText,
                  extraInfoSource: extraInfoController.text.trim(),
                  email: context.read<AuthBloc>().state is AuthAuthenticated
                      ? (context.read<AuthBloc>().state as AuthAuthenticated)
                                .user
                                .email ??
                            ''
                      : '',
                  accessId: context.read<AuthBloc>().state is AuthAuthenticated
                      ? (context.read<AuthBloc>().state as AuthAuthenticated)
                            .user
                            .id
                      : '',
                  watermark: {
                    'width': watermarkWidthController.text,
                    'height': watermarkHeightController.text,
                    'brandURL': watermarkUrlController.text,
                    'position': watermarkPosition,
                  },
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a topic')),
              );
            }
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome),
              SizedBox(width: 12),
              Text(
                'Generate Presentation',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
