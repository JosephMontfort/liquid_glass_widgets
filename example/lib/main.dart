import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:liquid_glass_widgets_example/constants/glass_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:liquid_glass_widgets_example/apple_mail/apple_mail_demo.dart';
import 'package:liquid_glass_widgets_example/apple_messages/apple_messages_demo.dart';
import 'package:liquid_glass_widgets_example/apple_music/apple_music_demo.dart';
import 'package:liquid_glass_widgets_example/apple_news/apple_news_demo.dart';
import 'package:liquid_glass_widgets_example/apple_podcasts/apple_podcasts_demo.dart';
import 'package:liquid_glass_widgets_example/apple_lockscreen/keypad_lock_screen_demo.dart';
import 'package:liquid_glass_widgets_example/demos/nav_bar_patterns_demo.dart';
import 'package:liquid_glass_widgets_example/demos/glass_menu_demo.dart';
import 'package:liquid_glass_widgets_example/demos/glass_modal_sheet_demo.dart';
import 'package:liquid_glass_widgets_example/demos/video_player_demo.dart';
import 'package:liquid_glass_widgets_example/demos/text_field_demo.dart';
import 'package:liquid_glass_widgets_example/demos/bottom_bar_tab_width_demo.dart';
import 'package:liquid_glass_widgets_example/demos/minimizable_bar_demo.dart';
import 'package:liquid_glass_widgets_example/demos/buttons_and_shadows_demo.dart';
import 'package:liquid_glass_widgets_example/demos/content_aware_brightness_demo.dart';
import 'package:liquid_glass_widgets_example/demos/indicator_parity_demo.dart';
import 'package:liquid_glass_widgets_example/demos/rtl_layout_demo.dart';
import 'package:liquid_glass_widgets_example/demos/meniscus_and_blur_demo.dart';
import 'package:liquid_glass_widgets_example/demos/materialize_demo.dart';
import 'package:liquid_glass_widgets_example/demos/scroll_edge_style_demo.dart';
import 'package:liquid_glass_widgets_example/demos/touch_specular_and_vibrancy_demo.dart';

import 'package:liquid_glass_widgets_example/demos/google_maps_demo.dart'
    show PlatformViewDemo;
import 'package:liquid_glass_widgets_example/demos/quality_comparison_demo.dart'
    show GlassQualityComparisonDemo;
import 'package:liquid_glass_widgets_example/demos/color_fidelity_demo.dart'
    show ColorFidelityDemoPage;
import 'package:liquid_glass_widgets_example/demos/tab_bar_menu_demo.dart'
    show TabBarMenuDemoPage;
import 'package:liquid_glass_widgets_example/demos/lists_pickers_and_nav_demo.dart'
    show ListsPickersAndNavDemoPage;
import 'package:liquid_glass_widgets_example/pages/containers_page.dart';
import 'package:liquid_glass_widgets_example/pages/feedback_page.dart';
import 'package:liquid_glass_widgets_example/pages/input_page.dart';
import 'package:liquid_glass_widgets_example/pages/interactive_page.dart';
import 'package:liquid_glass_widgets_example/pages/overlays_page.dart';
import 'package:liquid_glass_widgets_example/pages/surfaces_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiquidGlassWidgets.initialize();
  runApp(LiquidGlassWidgets.wrap(child: const AppleLiquidGlassShowcaseApp()));
}

class AppleLiquidGlassShowcaseApp extends StatefulWidget {
  const AppleLiquidGlassShowcaseApp({super.key});

  @override
  State<AppleLiquidGlassShowcaseApp> createState() =>
      _AppleLiquidGlassShowcaseAppState();
}

class _AppleLiquidGlassShowcaseAppState
    extends State<AppleLiquidGlassShowcaseApp> {
  /// Global brightness toggle — shared via [_BrightnessScope].
  Brightness _brightness = Brightness.dark;

  /// Global glass style preset — shared via [_BrightnessScope] and [GlassTheme].
  GlassStyle _style = GlassStyle.ios27;

  /// Global glass quality tier — shared via [_BrightnessScope] and [GlassTheme].
  GlassQuality _quality = GlassQuality.premium;

  @override
  void initState() {
    super.initState();
    kMailUseIos27.addListener(_onMailStyleChanged);
  }

  @override
  void dispose() {
    kMailUseIos27.removeListener(_onMailStyleChanged);
    super.dispose();
  }

  void _onMailStyleChanged() {
    final target = kMailUseIos27.value ? GlassStyle.ios27 : GlassStyle.ios26;
    if (_style != target) {
      setState(() => _style = target);
    }
  }

  void _toggleBrightness() {
    setState(() {
      _brightness =
          _brightness == Brightness.dark ? Brightness.light : Brightness.dark;
    });
  }

  void _setStyle(GlassStyle style) {
    if (_style == style) return;
    setState(() {
      _style = style;
    });
    if (style == GlassStyle.ios27 && !kMailUseIos27.value) {
      kMailUseIos27.value = true;
    } else if (style == GlassStyle.ios26 && kMailUseIos27.value) {
      kMailUseIos27.value = false;
    }
  }

  void _setQuality(GlassQuality quality) {
    if (_quality == quality) return;
    setState(() {
      _quality = quality;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _brightness == Brightness.dark;

    final baseTheme = switch (_style) {
      GlassStyle.ios27 => GlassThemeData.ios27(brightness: _brightness),
      GlassStyle.ios26 => GlassThemeData.ios26(brightness: _brightness),
      GlassStyle.classic => GlassThemeData.classic(brightness: _brightness),
    };

    final effectiveTheme = baseTheme.copyWith(
      light: baseTheme.light.copyWith(quality: _quality),
      dark: baseTheme.dark.copyWith(quality: _quality),
    );

    return GlassTheme(
      data: effectiveTheme,
      child: _BrightnessScope(
        brightness: _brightness,
        toggleBrightness: _toggleBrightness,
        style: _style,
        setStyle: _setStyle,
        quality: _quality,
        setQuality: _setQuality,
        child: CupertinoApp(
          title: 'Liquid Glass Widgets',
          theme: CupertinoThemeData(
            brightness: _brightness,
          ),
          // Demo pages use Material widgets (Scaffold, showModalBottomSheet)
          // that require these localizations. Not needed for glass widgets.
          localizationsDelegates: const [
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
          ],
          // Provide a matching Material Theme for any Scaffold widgets in demo pages.
          builder: (context, child) => Theme(
            data: isDark
                ? ThemeData.dark(useMaterial3: true)
                : ThemeData.light(useMaterial3: true),
            // Hosts pinned nav-bar chrome (back button + actions) above the
            // Navigator so it stays put while pages slide during push/pop.
            child: GlassNavigationShell(child: child!),
          ),
          home: const ShowcaseHomePage(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

/// Inherited widget exposing the current [Brightness], [GlassStyle], [GlassQuality],
/// and callbacks to any descendant widget in the example app.
class _BrightnessScope extends InheritedWidget {
  const _BrightnessScope({
    required this.brightness,
    required this.toggleBrightness,
    required this.style,
    required this.setStyle,
    required this.quality,
    required this.setQuality,
    required super.child,
  });

  final Brightness brightness;
  final VoidCallback toggleBrightness;
  final GlassStyle style;
  final ValueChanged<GlassStyle> setStyle;
  final GlassQuality quality;
  final ValueChanged<GlassQuality> setQuality;

  static _BrightnessScope of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_BrightnessScope>()!;
  }

  @override
  bool updateShouldNotify(_BrightnessScope oldWidget) =>
      brightness != oldWidget.brightness ||
      style != oldWidget.style ||
      quality != oldWidget.quality;
}

class _GlassStyleSelector extends StatelessWidget {
  const _GlassStyleSelector();

  static const _styles = [
    GlassStyle.ios27,
    GlassStyle.ios26,
  ];

  @override
  Widget build(BuildContext context) {
    final scope = _BrightnessScope.of(context);
    final selectedIndex = scope.style == GlassStyle.ios26 ? 1 : 0;

    return GlassSegmentedControl(
      useOwnLayer: true,
      selectedIndex: selectedIndex,
      onSegmentSelected: (index) => scope.setStyle(_styles[index]),
      segments: const [
        GlassSegment(label: 'iOS 27'),
        GlassSegment(label: 'iOS 26'),
      ],
    );
  }
}

// =============================================================================
// Home Page — GlassBottomBar as hero + content tabs
// =============================================================================

class ShowcaseHomePage extends StatefulWidget {
  const ShowcaseHomePage({super.key});

  @override
  State<ShowcaseHomePage> createState() => _ShowcaseHomePageState();
}

class _ShowcaseHomePageState extends State<ShowcaseHomePage> {
  int _selectedTab = 0;
  bool _isSearchActive = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static const _tabs = [
    GlassTab(
      label: 'Explore',
      icon: Icon(CupertinoIcons.compass),
      activeIcon: Icon(CupertinoIcons.compass_fill),
    ),
    GlassTab(
      label: 'Widgets',
      icon: Icon(CupertinoIcons.square_grid_2x2),
      activeIcon: Icon(CupertinoIcons.square_grid_2x2_fill),
    ),
    GlassTab(
      label: 'Demos',
      icon: Icon(Icons.apple_outlined, size: 30),
      activeIcon: Icon(Icons.apple, size: 30),
    ),
    GlassTab(
      label: 'Examples',
      icon: Icon(CupertinoIcons.cube),
      activeIcon: Icon(CupertinoIcons.cube_fill),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scope = _BrightnessScope.of(context);
    final isDark = scope.brightness == Brightness.dark;

    return GlassScaffold(
      background: const ShowcaseBackground(),
      statusBarStyle:
          isDark ? GlassStatusBarStyle.light : GlassStatusBarStyle.dark,
      topEdgeFade: true,
      appBar: GlassAppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Liquid Glass',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: CupertinoColors.label.resolveFrom(context),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: scope.quality == GlassQuality.premium
                    ? const Color(0xFFA855F7).withValues(alpha: 0.25)
                    : (scope.quality == GlassQuality.standard
                        ? CupertinoColors.activeBlue.withValues(alpha: 0.25)
                        : CupertinoColors.systemGrey.withValues(alpha: 0.25)),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: scope.quality == GlassQuality.premium
                      ? const Color(0xFFA855F7).withValues(alpha: 0.6)
                      : (scope.quality == GlassQuality.standard
                          ? CupertinoColors.activeBlue.withValues(alpha: 0.6)
                          : CupertinoColors.systemGrey.withValues(alpha: 0.6)),
                  width: 0.8,
                ),
              ),
              child: Text(
                '${scope.style.name.toUpperCase()} · ${scope.quality.name.toUpperCase()}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: scope.quality == GlassQuality.premium
                      ? const Color(0xFFA855F7)
                      : (scope.quality == GlassQuality.standard
                          ? CupertinoColors.activeBlue
                          : CupertinoColors.secondaryLabel.resolveFrom(context)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          GlassPullDownButton(
            icon: const Icon(CupertinoIcons.slider_horizontal_3, size: 20),
            semanticLabel: 'Settings and Quality Tiers',
            items: [
              GlassMenuItem(
                title: 'Quality Tier',
                icon: const Icon(CupertinoIcons.sparkles),
                subtitle: scope.quality.name.toUpperCase(),
                onTap: () {},
                submenu: [
                  GlassMenuItem(
                    title: 'Premium (Impeller)',
                    subtitle: 'Full 16-shape shader, refraction & dispersion',
                    isSelected: scope.quality == GlassQuality.premium,
                    trailing: scope.quality == GlassQuality.premium
                        ? const Icon(CupertinoIcons.checkmark, size: 16)
                        : null,
                    onTap: () => scope.setQuality(GlassQuality.premium),
                  ),
                  GlassMenuItem(
                    title: 'Standard (2D Shader)',
                    subtitle: '60/120fps optimized single-pass',
                    isSelected: scope.quality == GlassQuality.standard,
                    trailing: scope.quality == GlassQuality.standard
                        ? const Icon(CupertinoIcons.checkmark, size: 16)
                        : null,
                    onTap: () => scope.setQuality(GlassQuality.standard),
                  ),
                  GlassMenuItem(
                    title: 'Minimal (Frosted)',
                    subtitle: 'Zero shader overhead, BackdropFilter fallback',
                    isSelected: scope.quality == GlassQuality.minimal,
                    trailing: scope.quality == GlassQuality.minimal
                        ? const Icon(CupertinoIcons.checkmark, size: 16)
                        : null,
                    onTap: () => scope.setQuality(GlassQuality.minimal),
                  ),
                ],
              ),
              GlassMenuItem(
                title: 'Design Era',
                icon: const Icon(CupertinoIcons.layers_alt),
                subtitle: scope.style.name.toUpperCase(),
                onTap: () {},
                submenu: [
                  GlassMenuItem(
                    title: 'iOS 27',
                    subtitle: 'Paraxial lens, frost, rimShade & rimLight',
                    isSelected: scope.style == GlassStyle.ios27,
                    trailing: scope.style == GlassStyle.ios27
                        ? const Icon(CupertinoIcons.checkmark, size: 16)
                        : null,
                    onTap: () => scope.setStyle(GlassStyle.ios27),
                  ),
                  GlassMenuItem(
                    title: 'iOS 26',
                    subtitle: 'Fluid jelly physics, dynamic rim highlights',
                    isSelected: scope.style == GlassStyle.ios26,
                    trailing: scope.style == GlassStyle.ios26
                        ? const Icon(CupertinoIcons.checkmark, size: 16)
                        : null,
                    onTap: () => scope.setStyle(GlassStyle.ios26),
                  ),
                  GlassMenuItem(
                    title: 'Classic',
                    subtitle: 'Standard frosted glass styling',
                    isSelected: scope.style == GlassStyle.classic,
                    trailing: scope.style == GlassStyle.classic
                        ? const Icon(CupertinoIcons.checkmark, size: 16)
                        : null,
                    onTap: () => scope.setStyle(GlassStyle.classic),
                  ),
                ],
              ),
              const GlassMenuDivider(),
              GlassMenuItem(
                title: isDark ? 'Light Mode' : 'Dark Mode',
                icon: Icon(isDark ? CupertinoIcons.sun_max : CupertinoIcons.moon),
                onTap: scope.toggleBrightness,
              ),
            ],
          ),
        ],
      ),
      bottomBar: GlassTabBar.searchable(
        selectedIndex: _selectedTab,
        onTabSelected: (i) => setState(() {
          _selectedTab = i;
          _isSearchActive = false;
        }),
        isSearchActive: _isSearchActive,
        searchConfig: GlassSearchBarConfig(
          hintText: 'Search widgets, demos...',
          controller: _searchController,
          onSearchToggle: (active) => setState(() {
            _isSearchActive = active;
            if (!active) {
              _searchQuery = '';
              _searchController.clear();
            }
          }),
          onChanged: (q) => setState(() => _searchQuery = q),
        ),
        selectedIconColor: const Color(0xFFA855F7),
        iconSize: 28,
        labelFontSize: 10,
        iconLabelSpacing: 0,
        extraButton: GlassTabBarExtraButton(
          icon: Icon(isDark ? CupertinoIcons.sun_max : CupertinoIcons.moon),
          label: isDark ? 'Light mode' : 'Dark mode',
          onTap: scope.toggleBrightness,
        ),
        tabs: _tabs,
      ),
      body: _isSearchActive
          ? _SearchResultsView(
              query: _searchQuery,
              onSelect: () => setState(() => _isSearchActive = false),
            )
          : AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: switch (_selectedTab) {
                0 => const _ExploreTab(key: ValueKey('explore')),
                1 => const _WidgetsTab(key: ValueKey('widgets')),
                2 => const _DemosTab(key: ValueKey('demos')),
                _ => const _ExamplesTab(key: ValueKey('examples')),
              },
            ),
    );
  }
}

// =============================================================================
// Explore Tab — hero overview
// =============================================================================

class _ExploreTab extends StatelessWidget {
  const _ExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Liquid Glass Widgets',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: CupertinoColors.label.resolveFrom(context),
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'iOS 26 & 27 Flutter Widget Toolkit',
                    style: TextStyle(
                      fontSize: 17,
                      color:
                          CupertinoColors.secondaryLabel.resolveFrom(context),
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 18),
                  const _GlassStyleSelector(),
                  SizedBox(height: 24),

                  // ── Featured demo — large card ────────────────────
                  GestureDetector(
                    onTap: () =>
                        _openDemo(context, const AppleMusicHomeScreen()),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF8B0000),
                            Color(0xFFFA2D48),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.apple_outlined,
                                  color: CupertinoColors.white, size: 30),
                              SizedBox(width: 6),
                              Text(
                                'Music',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: CupertinoColors.white,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            'Apple Music recreation\n with Liquid Glass Widgets',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: CupertinoColors.white,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Searchable bottom bar · Play pill · Tab navigation',
                            style: TextStyle(
                              fontSize: 13,
                              color:
                                  CupertinoColors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // ── Two smaller demo cards ────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _SmallDemoCard(
                          title: 'Messages',
                          icon: CupertinoIcons.chat_bubble_2_fill,
                          color: const Color(0xFF34C759),
                          destination: const MessagesScreen(),
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: _SmallDemoCard(
                          title: 'Podcasts',
                          icon: CupertinoIcons.mic_fill,
                          color: const Color(0xFFA855F7),
                          destination: const ApplePodcastsHomeScreen(),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 32),

                  // ── Staggered widget preview ──────────────────────
                  Text(
                    'Widget Catalog',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: CupertinoColors.label.resolveFrom(context),
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 16),

                  // ── Masonry: tall card + two stacked ──────────
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Left: tall card spanning both right cards
                        Expanded(
                          flex: 1,
                          child: _StaggeredCatalogCard(
                            icon: CupertinoIcons.rectangle_3_offgrid_fill,
                            title: 'Surfaces',
                            subtitle: 'AppBar · BottomBar · SearchBar · TabBar',
                            destination: const SurfacesPage(),
                          ),
                        ),
                        SizedBox(width: 14),
                        // Right: two stacked cards
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _StaggeredCatalogCard(
                                icon: CupertinoIcons.hand_point_right_fill,
                                title: 'Interactive',
                                subtitle: 'Button · Switch · Slider',
                                height: 120,
                                destination: const InteractivePage(),
                              ),
                              SizedBox(height: 14),
                              _StaggeredCatalogCard(
                                icon: CupertinoIcons.hourglass,
                                title: 'Feedback',
                                subtitle: 'Progress · Toast',
                                height: 120,
                                destination: const FeedbackPage(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14),

                  // ── Row of two ──────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _StaggeredCatalogCard(
                          icon: CupertinoIcons.keyboard,
                          title: 'Input',
                          subtitle: 'TextField · SearchBar',
                          height: 120,
                          destination: const InputPage(),
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: _StaggeredCatalogCard(
                          icon: CupertinoIcons.square_stack_fill,
                          title: 'Overlays',
                          subtitle: 'Sheet · Dialog · Menu · Popover',
                          height: 120,
                          destination: const OverlaysPage(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),

                  // ── Full-width card ─────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _StaggeredCatalogCard(
                          icon: CupertinoIcons.square_stack_3d_up_fill,
                          title: 'Containers',
                          subtitle: 'Card · Panel · Container',
                          height: 100,
                          destination: const ContainersPage(),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Widgets Tab — full catalog
// =============================================================================

class _WidgetsTab extends StatelessWidget {
  const _WidgetsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Widgets',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: CupertinoColors.label.resolveFrom(context),
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Browse the full widget catalog.',
                    style: TextStyle(
                      fontSize: 15,
                      color:
                          CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Row 1: Containers + Interactive
                  Row(
                    children: [
                      Expanded(
                        child: _SmallDemoCard(
                          title: 'Containers',
                          icon: CupertinoIcons.square_stack_3d_up_fill,
                          color: const Color(0xFF007AFF),
                          destination: const ContainersPage(),
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: _SmallDemoCard(
                          title: 'Interactive',
                          icon: CupertinoIcons.hand_point_right_fill,
                          color: const Color(0xFFFF9500),
                          destination: const InteractivePage(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),

                  // Row 2: Feedback + Overlays
                  Row(
                    children: [
                      Expanded(
                        child: _SmallDemoCard(
                          title: 'Feedback',
                          icon: CupertinoIcons.hourglass,
                          color: const Color(0xFF34C759),
                          destination: const FeedbackPage(),
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: _SmallDemoCard(
                          title: 'Overlays',
                          icon: CupertinoIcons.square_stack_fill,
                          color: const Color(0xFFAF52DE),
                          destination: const OverlaysPage(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),

                  // Row 3: Surfaces + Input
                  Row(
                    children: [
                      Expanded(
                        child: _SmallDemoCard(
                          title: 'Surfaces',
                          icon: CupertinoIcons.rectangle_3_offgrid_fill,
                          color: const Color(0xFF5AC8FA),
                          destination: const SurfacesPage(),
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: _SmallDemoCard(
                          title: 'Input',
                          icon: CupertinoIcons.keyboard,
                          color: const Color(0xFFFF2D55),
                          destination: const InputPage(),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Demos Tab — full-screen app demos
// =============================================================================

class _DemosTab extends StatelessWidget {
  const _DemosTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Demos',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: CupertinoColors.label.resolveFrom(context),
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Polished Apple app reproductions using the active glass style.',
                    style: TextStyle(
                      fontSize: 15,
                      color:
                          CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                  ),
                  SizedBox(height: 16),
                  const _GlassStyleSelector(),
                  SizedBox(height: 24),

                  // Large featured cards
                  _LargeDemoCard(
                    title: 'Apple Mail',
                    subtitle:
                        'iOS 27 glass demo · pinned nav, gel morph & compose · compare iOS 26 in Inbox ··· menu',
                    icon: CupertinoIcons.mail_solid,
                    gradient: const [
                      Color(0xFF0A3D62),
                      Color(0xFF007AFF),
                    ],
                    destination: const AppleMailHomeScreen(),
                  ),
                  SizedBox(height: 14),

                  _LargeDemoCard(
                    title: 'Apple Music',
                    subtitle:
                        'Searchable bottom bar, play pill, tab navigation',
                    icon: CupertinoIcons.music_note_2,
                    gradient: const [
                      Color(0xFF8B0000),
                      Color(0xFFFA2D48),
                    ],
                    destination: const AppleMusicHomeScreen(),
                  ),
                  SizedBox(height: 14),

                  _LargeDemoCard(
                    title: 'Messages',
                    subtitle: 'Conversations, edit menus & filter controls',
                    icon: CupertinoIcons.chat_bubble_2_fill,
                    gradient: const [
                      Color(0xFF0A4D20),
                      Color(0xFF34C759),
                    ],
                    destination: const MessagesScreen(),
                  ),
                  SizedBox(height: 14),

                  _LargeDemoCard(
                    title: 'Podcasts',
                    subtitle:
                        'Mini-player, now playing sheet & scroll collapse',
                    icon: CupertinoIcons.mic_fill,
                    gradient: const [
                      Color(0xFF4A1A6B),
                      Color(0xFFA855F7),
                    ],
                    destination: const ApplePodcastsHomeScreen(),
                  ),
                  SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: _SmallDemoCard(
                          title: 'News',
                          icon: CupertinoIcons.news,
                          color: const Color(0xFFFF3B30),
                          destination: const AppleNewsHomeScreen(),
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: _SmallDemoCard(
                          title: 'Lock Screen',
                          icon: CupertinoIcons.lock_fill,
                          color: const Color(0xFF5856D6),
                          destination: const KeypadLockScreenDemo(),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Examples Tab — Widget patterns & component reference
// =============================================================================

class _ExamplesTab extends StatelessWidget {
  const _ExamplesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Examples',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: CupertinoColors.label.resolveFrom(context),
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Widget modes & configuration reference.',
                    style: TextStyle(
                      fontSize: 15,
                      color:
                          CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Row 1: Nav Patterns + Context Menus
                  Row(
                    children: [
                      Expanded(
                        child: _SmallDemoCard(
                          title: 'Nav Patterns',
                          icon: CupertinoIcons.rectangle_split_3x1,
                          color: const Color(0xFF007AFF),
                          destination: const NavBarPatternsDemo(),
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: _SmallDemoCard(
                          title: 'Menus',
                          icon: CupertinoIcons.ellipsis_circle_fill,
                          color: const Color(0xFFFF9500),
                          destination: const MenuDemoPage(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),

                  // Large card: Lists, Pickers & Nav
                  _LargeDemoCard(
                    title: 'Lists, Pickers & Nav',
                    subtitle:
                        'Swipe & context menus · edit & reorder · disclosure · date pickers · full-screen cover & NavigationStack',
                    icon: CupertinoIcons.square_stack_3d_up_fill,
                    gradient: const [
                      Color(0xFF1A2980),
                      Color(0xFF26D0CE),
                    ],
                    destination: const ListsPickersAndNavDemoPage(),
                  ),
                  SizedBox(height: 14),

                  // Large card: Tab Bar Menus
                  _LargeDemoCard(
                    title: 'Tab Bar Menus',
                    subtitle:
                        'Pull-down menus on bottom, minimizable & searchable bars (#275)',
                    icon: CupertinoIcons.ellipsis_vertical_circle_fill,
                    gradient: const [
                      Color(0xFF2E0854),
                      Color(0xFF8E2DE2),
                    ],
                    destination: const TabBarMenuDemoPage(),
                  ),
                  SizedBox(height: 14),

                  // Large card: Modal Sheets
                  _LargeDemoCard(
                    title: 'Modal Sheets',
                    subtitle:
                        'Standard, peek, Apple Maps & smart silence modes',
                    icon: CupertinoIcons.rectangle_on_rectangle,
                    gradient: const [
                      Color(0xFF0E4D92),
                      Color(0xFF5AC8FA),
                    ],
                    destination: const ShowcaseApp(),
                  ),
                  SizedBox(height: 14),

                  // Row 2: Text Fields + Video Player
                  Row(
                    children: [
                      Expanded(
                        child: _SmallDemoCard(
                          title: 'Text Fields',
                          icon: CupertinoIcons.textbox,
                          color: const Color(0xFF34C759),
                          destination: const TextFieldDemo(),
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: _SmallDemoCard(
                          title: 'Video Player',
                          icon: CupertinoIcons.play_circle_fill,
                          color: const Color(0xFFFF2D55),
                          destination: const VideoGlassDemoPage(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),

                  // Row 3: Tab Widths
                  Row(
                    children: [
                      Expanded(
                        child: _SmallDemoCard(
                          title: 'Tab Widths',
                          icon: CupertinoIcons.slider_horizontal_3,
                          color: const Color(0xFFAF52DE),
                          destination: const TabWidthDemoPage(),
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: _SmallDemoCard(
                          title: 'Platform View',
                          icon: CupertinoIcons.map_fill,
                          color: const Color(0xFF5AC8FA),
                          destination: const PlatformViewDemo(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),

                  // Row 4: Quality Tiers & Color Fidelity
                  Row(
                    children: [
                      Expanded(
                        child: _SmallDemoCard(
                          title: 'Quality Tiers',
                          icon: CupertinoIcons.sparkles,
                          color: const Color(0xFFFFB340),
                          destination: const GlassQualityComparisonDemo(),
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: _SmallDemoCard(
                          title: 'Color Fidelity',
                          icon: CupertinoIcons.color_filter,
                          color: const Color(0xFF00F5D4),
                          destination: const ColorFidelityDemoPage(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),

                  _LargeDemoCard(
                    title: 'Materialize',
                    subtitle:
                        'glassEffectTransition(.materialize) — entrance & exit',
                    icon: CupertinoIcons.sparkles,
                    gradient: const [
                      Color(0xFF1B2A4A),
                      Color(0xFF7B2D5E),
                    ],
                    destination: const MaterializeDemo(),
                  ),
                  SizedBox(height: 14),

                  _LargeDemoCard(
                    title: 'Scroll Edge Effect',
                    subtitle:
                        'blur · soft · hard — live style switcher + maxSigma tuner',
                    icon: CupertinoIcons.arrow_up_to_line,
                    gradient: const [
                      Color(0xFF003566),
                      Color(0xFF0096C7),
                    ],
                    destination: const ScrollEdgeStyleDemo(),
                  ),
                  SizedBox(height: 14),

                  _LargeDemoCard(
                    title: 'Minimizable Bar',
                    subtitle:
                        'tabBarMinimizeBehavior — minimizes as you scroll',
                    icon: CupertinoIcons.arrow_down_to_line_alt,
                    gradient: const [
                      Color(0xFF0A2342),
                      Color(0xFF0A84FF),
                    ],
                    destination: const MinimizableBarDemo(),
                  ),
                  SizedBox(height: 14),

                  _LargeDemoCard(
                    title: 'Buttons & Shadows',
                    subtitle: 'Glass elevations and GPU SDF shadows',
                    icon: CupertinoIcons.layers_fill,
                    gradient: const [
                      Color(0xFFFFB340), // Vibrant Amber
                      Color(0xFFE58600), // Deep Orange
                    ],
                    destination: const ShadowClippingDemoPage(),
                  ),
                  SizedBox(height: 14),

                  _LargeDemoCard(
                    title: 'Adaptive Brightness',
                    subtitle:
                        'Content-aware light/dark bar adaptation on scroll',
                    icon: CupertinoIcons.sun_dust_fill,
                    gradient: const [
                      Color(0xFF1C1C2E),
                      Color(0xFF5AC8FA),
                    ],
                    destination: const ContentAwareBrightnessDemo(),
                  ),
                  SizedBox(height: 14),

                  _LargeDemoCard(
                    title: 'Indicator Parity',
                    subtitle:
                        'All 5 pill widgets — live pinch / expansion / aberration tuner',
                    icon: CupertinoIcons.dial_fill,
                    gradient: const [
                      Color(0xFF5E3AFF),
                      Color(0xFF0A84FF),
                    ],
                    destination: const IndicatorParityDemoPage(),
                  ),
                  SizedBox(height: 14),

                  _LargeDemoCard(
                    title: 'RTL Layout',
                    subtitle:
                        'Automatic mirroring of layout and physics in RTL',
                    icon: CupertinoIcons.arrow_right_arrow_left_square_fill,
                    gradient: const [
                      Color(0xFF8E2DE2),
                      Color(0xFF4A00E0),
                    ],
                    destination: const RtlLayoutDemo(),
                  ),
                  SizedBox(height: 14),

                  _LargeDemoCard(
                    title: 'Meniscus & Blur Lab',
                    subtitle:
                        'Optical rim darkening tuner (edgeAbsorption) & 24-tap blur test',
                    icon: CupertinoIcons.circle_righthalf_fill,
                    gradient: const [
                      Color(0xFF00C6FF),
                      Color(0xFF0072FF),
                    ],
                    destination: const MeniscusAndBlurDemoPage(),
                  ),
                  SizedBox(height: 14),

                  _LargeDemoCard(
                    title: 'Touch & Vibrancy',
                    subtitle:
                        'Shader contact specular highlight, nested vibrancy fill & menu tracking',
                    icon: CupertinoIcons.sparkles,
                    gradient: const [
                      Color(0xFF0F2027),
                      Color(0xFF203A43),
                      Color(0xFF2C5364),
                    ],
                    destination: const TouchSpecularAndVibrancyDemo(),
                  ),
                  SizedBox(height: 14),

                  SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Shared Widgets
// =============================================================================

void _openDemo(BuildContext context, Widget destination) {
  final nav = Navigator.of(context);
  if (nav.userGestureInProgress) return;
  nav.push(CupertinoPageRoute<void>(builder: (_) => destination));
}

/// Staggered glass catalog card — variable height, glass background.
class _StaggeredCatalogCard extends StatelessWidget {
  const _StaggeredCatalogCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.height,
    required this.destination,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final double? height;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    Widget button = GlassButton.custom(
      onTap: () => _openDemo(context, destination),
      width: double.infinity,
      height: height ?? 254, // tall card default
      shape: const LiquidRoundedSuperellipse(borderRadius: 20),
      interactionScale: 0.98,
      stretch: 0.06,
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
              size: 24,
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.label.resolveFrom(context),
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
      ),
    );

    return button;
  }
}

/// Small demo card with accent color.
class _SmallDemoCard extends StatelessWidget {
  const _SmallDemoCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.destination,
  });

  final String title;
  final IconData icon;
  final Color color;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDemo(context, destination),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.7),
              color,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: CupertinoColors.white, size: 22),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: CupertinoColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Large demo card with gradient.
class _LargeDemoCard extends StatelessWidget {
  const _LargeDemoCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.destination,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDemo(context, destination),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: CupertinoColors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.white.withValues(alpha: 0.7),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: CupertinoColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: CupertinoColors.white, size: 26),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Search Results View & Catalog Data
// =============================================================================

class _CatalogItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String category;
  final Widget destination;

  const _CatalogItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.category,
    required this.destination,
  });
}

class _SearchResultsView extends StatelessWidget {
  const _SearchResultsView({
    required this.query,
    required this.onSelect,
  });

  final String query;
  final VoidCallback onSelect;

  static const List<_CatalogItem> _allItems = [
    // Apple App Recreations
    _CatalogItem(
      title: 'Apple Mail',
      subtitle: 'iOS 27 glass demo · pinned nav, gel morph & compose',
      icon: CupertinoIcons.mail_solid,
      category: 'Apple Demos',
      destination: AppleMailHomeScreen(),
    ),
    _CatalogItem(
      title: 'Apple Music',
      subtitle: 'Searchable bottom bar, play pill, tab navigation',
      icon: CupertinoIcons.music_note_2,
      category: 'Apple Demos',
      destination: AppleMusicHomeScreen(),
    ),
    _CatalogItem(
      title: 'Apple Messages',
      subtitle: 'Conversations, teardrop edit menus & filters',
      icon: CupertinoIcons.chat_bubble_2_fill,
      category: 'Apple Demos',
      destination: MessagesScreen(),
    ),
    _CatalogItem(
      title: 'Apple Podcasts',
      subtitle: 'Mini-player, now playing sheet & scroll collapse',
      icon: CupertinoIcons.mic_fill,
      category: 'Apple Demos',
      destination: ApplePodcastsHomeScreen(),
    ),
    _CatalogItem(
      title: 'Apple News',
      subtitle: 'Editorial layout, topic pill carousel & glass header',
      icon: CupertinoIcons.news,
      category: 'Apple Demos',
      destination: AppleNewsHomeScreen(),
    ),
    _CatalogItem(
      title: 'Keypad Lock Screen',
      subtitle: 'Full-bleed blur, glass numeric keypad & emergency dialer',
      icon: CupertinoIcons.lock_fill,
      category: 'Apple Demos',
      destination: KeypadLockScreenDemo(),
    ),

    // Widget Categories
    _CatalogItem(
      title: 'Containers & Cards',
      subtitle: 'Card · Panel · Grouped Section · Divider · Stepper',
      icon: CupertinoIcons.square_stack_3d_up_fill,
      category: 'Widgets',
      destination: ContainersPage(),
    ),
    _CatalogItem(
      title: 'Interactive Controls',
      subtitle: 'Button · Switch · Slider · Segmented · PullDownButton',
      icon: CupertinoIcons.hand_point_right_fill,
      category: 'Widgets',
      destination: InteractivePage(),
    ),
    _CatalogItem(
      title: 'Input Fields',
      subtitle: 'TextField · TextArea · PasswordField · SearchBar · Picker',
      icon: CupertinoIcons.keyboard,
      category: 'Widgets',
      destination: InputPage(),
    ),
    _CatalogItem(
      title: 'Feedback Indicators',
      subtitle: 'ProgressIndicator · Toast · HUD',
      icon: CupertinoIcons.hourglass,
      category: 'Widgets',
      destination: FeedbackPage(),
    ),
    _CatalogItem(
      title: 'Overlays & Modals',
      subtitle: 'Sheet · Dialog · Action Sheet · Menu · Popover',
      icon: CupertinoIcons.square_stack_fill,
      category: 'Widgets',
      destination: OverlaysPage(),
    ),
    _CatalogItem(
      title: 'Surfaces & Bars',
      subtitle: 'AppBar · TabBar · Toolbar · NavigationShell',
      icon: CupertinoIcons.rectangle_3_offgrid_fill,
      category: 'Widgets',
      destination: SurfacesPage(),
    ),

    // Advanced Examples & Demos
    _CatalogItem(
      title: 'Navigation Patterns',
      subtitle: 'Scaffold Nav · Scroll Collapse · Pinned Chrome',
      icon: CupertinoIcons.rectangle_split_3x1,
      category: 'Examples',
      destination: NavBarPatternsDemo(),
    ),
    _CatalogItem(
      title: 'Glass Menus (9 Alignments)',
      subtitle: 'Teardrop Liquid Morph, submenus & swipe-to-select',
      icon: CupertinoIcons.ellipsis_circle_fill,
      category: 'Examples',
      destination: MenuDemoPage(),
    ),
    _CatalogItem(
      title: 'Lists, Pickers & Nav',
      subtitle: 'Swipe actions, edit & reorder, disclosure, date pickers',
      icon: CupertinoIcons.square_stack_3d_up_fill,
      category: 'Examples',
      destination: ListsPickersAndNavDemoPage(),
    ),
    _CatalogItem(
      title: 'Tab Bar Menus',
      subtitle: 'Pull-down menus on bottom, minimizable & searchable bars',
      icon: CupertinoIcons.ellipsis_vertical_circle_fill,
      category: 'Examples',
      destination: TabBarMenuDemoPage(),
    ),
    _CatalogItem(
      title: 'Modal Sheets (Peek/Half/Full)',
      subtitle: 'Liquid morph triggers, detents, Apple Maps gestures',
      icon: CupertinoIcons.rectangle_on_rectangle,
      category: 'Examples',
      destination: ShowcaseApp(),
    ),
    _CatalogItem(
      title: 'Text Field Styling',
      subtitle: 'Liquid focus outline, error states & solid wells',
      icon: CupertinoIcons.textbox,
      category: 'Examples',
      destination: TextFieldDemo(),
    ),
    _CatalogItem(
      title: 'Video Player Controls',
      subtitle: 'Liquid glass scrubbing slider & floating player chrome',
      icon: CupertinoIcons.play_circle_fill,
      category: 'Examples',
      destination: VideoGlassDemoPage(),
    ),
    _CatalogItem(
      title: 'Tab Width Showcase',
      subtitle: 'Adaptive tab widths, labels & icon spacing',
      icon: CupertinoIcons.slider_horizontal_3,
      category: 'Examples',
      destination: TabWidthDemoPage(),
    ),
    _CatalogItem(
      title: 'Minimizable Bar',
      subtitle: 'Collapse-to-pill on scroll (iOS 26 behavior)',
      icon: CupertinoIcons.arrow_down_to_line_alt,
      category: 'Examples',
      destination: MinimizableBarDemo(),
    ),
    _CatalogItem(
      title: 'Buttons & Shadows',
      subtitle: 'Press parity, squeeze stretch & GPU SDF shadows',
      icon: CupertinoIcons.layers_fill,
      category: 'Examples',
      destination: ShadowClippingDemoPage(),
    ),
    _CatalogItem(
      title: 'Content-Aware Brightness',
      subtitle: 'Dynamic contrast detection over dark and light backdrops',
      icon: CupertinoIcons.sun_dust_fill,
      category: 'Examples',
      destination: ContentAwareBrightnessDemo(),
    ),
    _CatalogItem(
      title: 'Indicator Parity Harness',
      subtitle: 'All 5 indicator pill widgets compared side-by-side',
      icon: CupertinoIcons.dial_fill,
      category: 'Examples',
      destination: IndicatorParityDemoPage(),
    ),
    _CatalogItem(
      title: 'RTL Layout Mirroring',
      subtitle: 'Full RTL physics, drag direction & layout flipping',
      icon: CupertinoIcons.arrow_right_arrow_left_square_fill,
      category: 'Examples',
      destination: RtlLayoutDemo(),
    ),
    _CatalogItem(
      title: 'Meniscus & Optical Blur',
      subtitle: 'Optical rim darkening & 24-tap Gaussian blur',
      icon: CupertinoIcons.circle_righthalf_fill,
      category: 'Examples',
      destination: MeniscusAndBlurDemoPage(),
    ),
    _CatalogItem(
      title: 'Glass Materialize',
      subtitle: 'Progressive defogging entrance and exit transitions',
      icon: CupertinoIcons.sparkles,
      category: 'Examples',
      destination: MaterializeDemo(),
    ),
    _CatalogItem(
      title: 'Scroll Edge Effect',
      subtitle: 'Graduated ProgressiveBlur dissolve headers',
      icon: CupertinoIcons.arrow_up_to_line,
      category: 'Examples',
      destination: ScrollEdgeStyleDemo(),
    ),
    _CatalogItem(
      title: 'Touch Specular & Vibrancy',
      subtitle: 'Finger-following specular highlights & nested vibrancy fill',
      icon: CupertinoIcons.sparkles,
      category: 'Examples',
      destination: TouchSpecularAndVibrancyDemo(),
    ),
    _CatalogItem(
      title: 'Quality Tiers Comparison',
      subtitle: 'Premium vs Standard vs Minimal visual comparison',
      icon: CupertinoIcons.sparkles,
      category: 'Examples',
      destination: GlassQualityComparisonDemo(),
    ),
    _CatalogItem(
      title: 'Color Fidelity',
      subtitle: 'Glass.clear vs Glass.regular color absorption',
      icon: CupertinoIcons.color_filter,
      category: 'Examples',
      destination: ColorFidelityDemoPage(),
    ),
    _CatalogItem(
      title: 'Platform View Passthrough',
      subtitle: 'Compositing glass directly over native Google Maps view',
      icon: CupertinoIcons.map_fill,
      category: 'Examples',
      destination: PlatformViewDemo(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cleanQuery = query.trim().toLowerCase();
    final filtered = cleanQuery.isEmpty
        ? _allItems
        : _allItems.where((item) {
            return item.title.toLowerCase().contains(cleanQuery) ||
                item.subtitle.toLowerCase().contains(cleanQuery) ||
                item.category.toLowerCase().contains(cleanQuery);
          }).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.search,
                    size: 18,
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    cleanQuery.isEmpty
                        ? 'Catalog Search (${_allItems.length} components)'
                        : 'Matching Results (${filtered.length})',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (filtered.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.search,
                    size: 48,
                    color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No components found for "$query"',
                    style: TextStyle(
                      fontSize: 16,
                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = filtered[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GlassContainer.card(
                      surfaceStyle: GlassSurfaceStyle.solid,
                      onTap: () {
                        onSelect();
                        _openDemo(context, item.destination);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFA855F7).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                item.icon,
                                size: 20,
                                color: const Color(0xFFA855F7),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: CupertinoColors.label.resolveFrom(context),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          item.category,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: CupertinoColors.secondaryLabel.resolveFrom(context),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    item.subtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              CupertinoIcons.chevron_right,
                              size: 16,
                              color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: filtered.length,
              ),
            ),
          ),
      ],
    );
  }
}
