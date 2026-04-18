import 'package:flutter/material.dart';

void main() {
  runApp(const BocetoVisualApp());
}

class BocetoVisualApp extends StatelessWidget {
  const BocetoVisualApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Boceto Visual AppMovilSpotify',
      theme: AppMockTheme.light(),
      home: const MockupShowcasePage(),
    );
  }
}

class MockupShowcasePage extends StatefulWidget {
  const MockupShowcasePage({super.key});

  @override
  State<MockupShowcasePage> createState() => _MockupShowcasePageState();
}

class _MockupShowcasePageState extends State<MockupShowcasePage> {
  int index = 0;

  final labels = const [
    'Splash',
    'Login',
    'Home',
    'Busqueda',
    'Player',
    'Acordes',
  ];

  Widget _buildCurrentScreen() {
    switch (index) {
      case 0:
        return SplashMockScreen(onContinue: () => setState(() => index = 1));
      case 1:
        return LoginMockScreen(
          onBack: () => setState(() => index = 0),
          onLogin: () => setState(() => index = 2),
        );
      case 2:
        return HomeMockScreen(
          onOpenSearch: () => setState(() => index = 3),
          onOpenPlayer: () => setState(() => index = 4),
          onTabSelected: (tabIndex) {
            if (tabIndex >= 0 && tabIndex < labels.length) {
              setState(() => index = tabIndex);
            }
          },
        );
      case 3:
        return SearchMockScreen(
          onBackToHome: () => setState(() => index = 2),
          onOpenPlayer: () => setState(() => index = 4),
        );
      case 4:
        return PlayerMockScreen(
          onBack: () => setState(() => index = 3),
          onViewChords: () => setState(() => index = 5),
        );
      case 5:
        return ChordsMockScreen(
          onBackToPlayer: () => setState(() => index = 4),
        );
      default:
        return SplashMockScreen(onContinue: () => setState(() => index = 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 1100;
    final currentScreen = _buildCurrentScreen();

    return Scaffold(
      backgroundColor: AppMockColors.background,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Boceto visual AppMovilSpotify'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                labels[index],
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: isDesktop
            ? Row(
                children: [
                  Expanded(
                    child: DesktopPreviewCard(
                      title: 'Vista Desktop de Presentacion',
                      child: MockScreenTransition(
                        screenIndex: index,
                        child: currentScreen,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  SizedBox(
                    width: 390,
                    child: MobileFrame(
                      child: MockScreenTransition(
                        screenIndex: index,
                        child: currentScreen,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Expanded(
                    child: MobileFrame(
                      child: MockScreenTransition(
                        screenIndex: index,
                        child: currentScreen,
                      ),
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Container(
            decoration: BoxDecoration(
              color: AppMockColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppMockColors.border),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(labels.length, (i) {
                  final selected = i == index;
                  return Padding(
                    padding: const EdgeInsets.all(6),
                    child: ChoiceChip(
                      label: Text(labels[i]),
                      selected: selected,
                      onSelected: (_) => setState(() => index = i),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MockScreenTransition extends StatelessWidget {
  final int screenIndex;
  final Widget child;

  const MockScreenTransition({
    super.key,
    required this.screenIndex,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (widget, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0.04, 0),
          end: Offset.zero,
        ).animate(animation);

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: offsetAnimation, child: widget),
        );
      },
      child: KeyedSubtree(key: ValueKey<int>(screenIndex), child: child),
    );
  }
}

class DesktopPreviewCard extends StatelessWidget {
  final String title;
  final Widget child;

  const DesktopPreviewCard({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppMockColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppMockColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: AppMockColors.background,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MobileFrame extends StatelessWidget {
  final Widget child;

  const MobileFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppMockColors.background,
          borderRadius: BorderRadius.circular(30),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 110,
                height: 5,
                decoration: BoxDecoration(
                  color: AppMockColors.border,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class SplashMockScreen extends StatelessWidget {
  final VoidCallback onContinue;

  const SplashMockScreen({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 38,
            backgroundColor: AppMockColors.surface,
          ),
          const SizedBox(height: 24),
          Text(
            'AppMovilSpotify',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Musica + Acordes en vivo',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Practica con claridad',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 28),
          PrimaryButton(label: 'Continuar con Spotify', onPressed: onContinue),
        ],
      ),
    );
  }
}

class LoginMockScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onLogin;

  const LoginMockScreen({
    super.key,
    required this.onBack,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          const SizedBox(height: 12),
          Text(
            'Inicia sesion',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Conecta tu cuenta para comenzar',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          const Center(
            child: CircleAvatar(
              radius: 30,
              backgroundColor: AppMockColors.surface,
            ),
          ),
          const SizedBox(height: 22),
          PrimaryButton(label: 'Iniciar con Spotify', onPressed: onLogin),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Politica de privacidad',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 26),
        ],
      ),
    );
  }
}

class HomeMockScreen extends StatelessWidget {
  final VoidCallback onOpenSearch;
  final VoidCallback onOpenPlayer;
  final ValueChanged<int> onTabSelected;

  const HomeMockScreen({
    super.key,
    required this.onOpenSearch,
    required this.onOpenPlayer,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hola, Luis Carlos',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Listo para practicar hoy',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          SearchBarMock(hint: 'Buscar canciones...', onTap: onOpenSearch),
          const SizedBox(height: 18),
          Text(
            'Recomendado para ti',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          SongCard(
            title: 'Cancion A',
            subtitle: 'Artista Uno',
            onTap: onOpenPlayer,
          ),
          const SizedBox(height: 10),
          SongCard(
            title: 'Cancion B',
            subtitle: 'Artista Dos',
            onTap: onOpenPlayer,
          ),
          const Spacer(),
          BottomTabsMock(onTabSelected: onTabSelected),
        ],
      ),
    );
  }
}

class SearchMockScreen extends StatelessWidget {
  final VoidCallback onBackToHome;
  final VoidCallback onOpenPlayer;

  const SearchMockScreen({
    super.key,
    required this.onBackToHome,
    required this.onOpenPlayer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBackToHome,
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              Text('Buscar', style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          const SizedBox(height: 12),
          const SearchBarMock(hint: 'Que cancion quieres practicar?'),
          const SizedBox(height: 16),
          Text('Resultados', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SongCard(
            title: 'Perfect',
            subtitle: 'Ed Sheeran',
            onTap: onOpenPlayer,
          ),
          const SizedBox(height: 10),
          SongCard(title: 'Yellow', subtitle: 'Coldplay', onTap: onOpenPlayer),
          const SizedBox(height: 10),
          SongCard(title: 'Fix You', subtitle: 'Coldplay', onTap: onOpenPlayer),
        ],
      ),
    );
  }
}

class PlayerMockScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onViewChords;

  const PlayerMockScreen({
    super.key,
    required this.onBack,
    required this.onViewChords,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              Text(
                'Reproduciendo',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: AppMockColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppMockColors.border),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Nombre de cancion',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text('Artista', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          const _ProgressRow(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.skip_previous_rounded),
              ),
              const SizedBox(width: 14),
              Container(
                width: 62,
                height: 62,
                decoration: const BoxDecoration(
                  color: AppMockColors.accent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pause_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.skip_next_rounded),
              ),
            ],
          ),
          const SizedBox(height: 18),
          PrimaryButton(label: 'Ver acordes', onPressed: onViewChords),
        ],
      ),
    );
  }
}

class ChordsMockScreen extends StatelessWidget {
  final VoidCallback onBackToPlayer;

  const ChordsMockScreen({super.key, required this.onBackToPlayer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBackToPlayer,
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
              Text('Acordes', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Cancion: Nombre de cancion',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          Text('Acorde actual', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 150,
              height: 84,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppMockColors.accent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Am',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text('Proximos', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          const Wrap(
            spacing: 8,
            children: [
              ChordChip(label: 'F'),
              ChordChip(label: 'C'),
              ChordChip(label: 'G'),
              ChordChip(label: 'Am'),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Timeline armonico',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          Container(
            height: 54,
            decoration: BoxDecoration(
              color: AppMockColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppMockColors.border),
            ),
            child: Row(
              children: const [
                Expanded(child: TimelineBlock(label: 'Am', active: true)),
                Expanded(child: TimelineBlock(label: 'F')),
                Expanded(child: TimelineBlock(label: 'C')),
                Expanded(child: TimelineBlock(label: 'G')),
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: const [
              Expanded(child: SecondaryButton(label: 'Modo simple')),
              SizedBox(width: 10),
              Expanded(child: SecondaryButton(label: 'Modo guitarra')),
            ],
          ),
        ],
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const PrimaryButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(onPressed: onPressed, child: Text(label)),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;

  const SecondaryButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: OutlinedButton(onPressed: () {}, child: Text(label)),
    );
  }
}

class SearchBarMock extends StatelessWidget {
  final String hint;
  final VoidCallback? onTap;

  const SearchBarMock({super.key, required this.hint, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppMockColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppMockColors.border),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              size: 20,
              color: AppMockColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(hint, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class SongCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const SongCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppMockColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppMockColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppMockColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BottomTabsMock extends StatelessWidget {
  final ValueChanged<int> onTabSelected;

  const BottomTabsMock({super.key, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppMockColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppMockColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => onTabSelected(2),
            icon: const Icon(Icons.home_rounded),
          ),
          IconButton(
            onPressed: () => onTabSelected(3),
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            onPressed: () => onTabSelected(4),
            icon: const Icon(Icons.play_circle_rounded),
          ),
          IconButton(
            onPressed: () => onTabSelected(5),
            icon: const Icon(Icons.music_note_rounded),
          ),
        ],
      ),
    );
  }
}

class ChordChip extends StatelessWidget {
  final String label;

  const ChordChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppMockColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppMockColors.border),
      ),
      child: Text(label, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}

class TimelineBlock extends StatelessWidget {
  final String label;
  final bool active;

  const TimelineBlock({super.key, required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: active
            ? AppMockColors.accent.withValues(alpha: 0.14)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: active ? AppMockColors.accent : AppMockColors.textSecondary,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('01:15'),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: AppMockColors.border,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  color: AppMockColors.accent,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Text('03:40'),
      ],
    );
  }
}

class AppMockColors {
  static const background = Color(0xFFF5F5F7);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF111111);
  static const textSecondary = Color(0xFF6E6E73);
  static const border = Color(0xFFD2D2D7);
  static const accent = Color(0xFF0071E3);
}

class AppMockTheme {
  static ThemeData light() {
    const textTheme = TextTheme(
      displaySmall: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w600,
        color: AppMockColors.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppMockColors.textPrimary,
      ),
      headlineSmall: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppMockColors.textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppMockColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppMockColors.textPrimary,
      ),
      titleSmall: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppMockColors.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        color: AppMockColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppMockColors.textSecondary,
      ),
      bodySmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppMockColors.textSecondary,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppMockColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppMockColors.accent,
        surface: AppMockColors.surface,
        onSurface: AppMockColors.textPrimary,
      ),
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: AppMockColors.textPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppMockColors.accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppMockColors.textPrimary,
          side: const BorderSide(color: AppMockColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: AppMockColors.surface,
        selectedColor: Color(0x220071E3),
        shape: StadiumBorder(side: BorderSide(color: AppMockColors.border)),
        labelStyle: TextStyle(color: AppMockColors.textPrimary),
      ),
    );
  }
}
