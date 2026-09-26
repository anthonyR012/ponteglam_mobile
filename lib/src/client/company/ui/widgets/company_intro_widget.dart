import 'package:flutter/material.dart';
import 'package:ponte_glam/config/theme/theme.dart';
import 'package:ponte_glam/config/constant/assets_constant.dart';
import 'package:ponte_glam/di/shared_imports.dart';
import 'package:ponte_glam/src/client/sign_up/domain/use_case/get_legal_content.dart';

class CompanyIntroWidget extends StatefulWidget {
  final VoidCallback onFinished;
  const CompanyIntroWidget({super.key, required this.onFinished});

  @override
  State<CompanyIntroWidget> createState() => _CompanyIntroWidgetState();
}

class _CompanyIntroWidgetState extends State<CompanyIntroWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishIntro() async {
    final prefs = getIt<SharedPreferences>();
    await prefs.setBool(keyCompanyIntroSeen, true);
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildWelcomeSlide(),
              _buildProcessSlide(),
              _buildFeesSlide(),
            ],
          ),
        ),
        _buildBottomControls(),
      ],
    );
  }

  Widget _buildWelcomeSlide() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: secondaryColorTheme.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.storefront_rounded,
              size: 70,
              color: secondaryColorTheme,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            '¡Ofrece tus Servicios!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: primaryColorTheme,
              fontFamily: fontFamilyMontserrat,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Conviértete en proveedor en PonteGlam y conecta con miles de clientes en tu zona que buscan servicios de belleza, estética y bienestar. Gestiona tus citas, colaboradores y ganancias de forma profesional.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: grayTextColorTheme.withValues(alpha: 0.9),
              fontFamily: fontFamilyMontserrat,
            ),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColorTheme.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: primaryColorTheme.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.verified_user_rounded,
                  color: secondaryColorTheme,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Es seguro, fácil y te da control total sobre tu negocio.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: primaryColorTheme,
                      fontFamily: fontFamilyMontserrat,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessSlide() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              '¿Cómo funciona el proceso?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColorTheme,
                fontFamily: fontFamilyMontserrat,
              ),
            ),
          ),
          const SizedBox(height: 30),
          _buildStepCard(
            stepNumber: '1',
            title: 'Información de la Compañía',
            description:
                'Registra el nombre oficial, una breve descripción comercial y sube el logotipo o imagen de perfil de tu negocio.',
            icon: Icons.business_rounded,
          ),
          const SizedBox(height: 16),
          _buildStepCard(
            stepNumber: '2',
            title: 'Dirección y Ubicación',
            description:
                'Especifica la dirección física de tu establecimiento en el mapa o configúralo si decides prestar servicios móviles a domicilio.',
            icon: Icons.map_rounded,
          ),
          const SizedBox(height: 16),
          _buildStepCard(
            stepNumber: '3',
            title: 'Configuración de Horarios',
            description:
                'Define los días de la semana y los horarios específicos en los que tu negocio estará abierto y disponible para recibir reservas de clientes.',
            icon: Icons.schedule_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required String stepNumber,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColorTheme, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: secondaryColorTheme.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              stepNumber,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: secondaryColorTheme,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: primaryColorTheme, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: primaryColorTheme,
                          fontFamily: fontFamilyMontserrat,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: grayTextColorTheme.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeesSlide() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Column(
        children: [
          Text(
            'Transparencia y Cobros',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColorTheme,
              fontFamily: fontFamilyMontserrat,
            ),
          ),
          const SizedBox(height: 24),
          FutureBuilder<String>(
            future: getIt<GetLegalContent>().call('supplier_usage_notice'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: CircularProgressIndicator(
                      color: secondaryColorTheme,
                    ),
                  ),
                );
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cancelColorTheme.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: cancelColorTheme.withValues(alpha: 0.2)),
                  ),
                  child: const Text(
                    'No se pudo cargar la información de cobros en este momento. Por favor inténtalo de nuevo.',
                    style: TextStyle(color: cancelColorTheme),
                  ),
                );
              }

              final content = snapshot.data!;

              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber.shade200, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.shade100.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Colors.amber.shade800,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Detalles de Comisiones',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900,
                            fontFamily: fontFamilyMontserrat,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      content,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.amber.shade900,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedOpacity(
            opacity: _currentPage < 2 ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: _currentPage == 2,
              child: TextButton(
                onPressed: _finishIntro,
                child: const Text(
                  'Omitir',
                  style: TextStyle(
                    color: grayTextColorTheme,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: List.generate(3, (index) => _buildIndicator(index)),
          ),
          ElevatedButton(
            onPressed: () {
              if (_currentPage < 2) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                _finishIntro();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColorTheme,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: _currentPage == 2 ? 24 : 16,
                vertical: 14,
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _currentPage == 2 ? 'Comenzar' : 'Siguiente',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  _currentPage == 2
                      ? Icons.check_circle_outline_rounded
                      : Icons.arrow_forward_rounded,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(int index) {
    final isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? secondaryColorTheme : grayTextColorTheme.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
