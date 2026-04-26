import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../models/document_asset.dart';

class TemplateThumbnail extends StatelessWidget {
  const TemplateThumbnail({
    super.key,
    required this.templateId,
    required this.type,
    this.isSelected = false,
  });

  final String templateId;
  final DocumentType type;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    // A4: 1 : 1.414. Business cards: 1.75 : 1.
    double aspectRatio = 1 / 1.414;
    if (type == DocumentType.businessCard) aspectRatio = 3.5 / 2;
    if (type == DocumentType.logo || type == DocumentType.icon) aspectRatio = 1.0;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6B35) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? const Color(0xFFFF6B35).withOpacity(0.2) 
                  : Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: _buildLayout(),
      ),
    );
  }

  Widget _buildLayout() {
    switch (templateId) {
      // Invoices
      case 'inv-modern': return const _ModernMinimalLayout();
      case 'inv-classic': return const _CorporateClassicLayout();
      case 'inv-bold': return const _BoldAccentLayout();
      case 'inv-service': return const _InvoiceServiceLayout();
      case 'inv-simple': return const _InvoiceSimpleLayout();
      case 'inv-luxury': return const _InvoiceLuxuryLayout();
      
      // Proposals
      case 'prop-executive': return const _ExecutiveLayout();
      case 'prop-creative': return const _CreativeLayout();
      case 'prop-technical': return const _TechnicalLayout();
      case 'prop-startup': return const _ProposalStartupLayout();
      case 'prop-roadmap': return const _ProposalRoadmapLayout();
      
      // Letterheads
      case 'lh-centered': return const _LetterheadCenteredLayout();
      case 'lh-sidebar': return const _LetterheadSidebarLayout();
      case 'lh-minimal-header': return const _LetterheadMinimalLayout();
      case 'lh-cornered': return const _LetterheadCorneredLayout();
      
      // Business Cards
      case 'bc-minimal': return const _BusinessCardMinimalLayout();
      case 'bc-geometric': return const _BusinessCardGeometricLayout();
      case 'bc-classic': return const _BusinessCardClassicLayout();
      case 'bc-vertical': return const _BusinessCardVerticalLayout();
      case 'bc-social': return const _BusinessCardSocialLayout();

      // Contracts
      case 'con-standard': return const _ContractStandardLayout();
      case 'con-modern': return const _ContractModernLayout();
      case 'con-simple': return const _ContractSimpleLayout();
      case 'con-nda': return const _ContractNDALayout();
      case 'con-sow': return const _ContractSOWLayout();

      // Logos
      case 'logo-minimal': return const _LogoMinimalLayout();
      case 'logo-typography': return const _LogoTypographyLayout();
      case 'logo-emblem': return const _LogoEmblemLayout();
      case 'logo-monogram': return const _LogoMonogramLayout();
      case 'logo-tech': return const _LogoTechLayout();

      // Icons
      case 'icon-flat': return const _IconFlatLayout();
      case 'icon-gradient': return const _IconGradientLayout();
      case 'icon-glyph': return const _IconGlyphLayout();
      case 'icon-glass': return const _IconGlassLayout();
      case 'icon-isometric': return const _IconIsometricLayout();

      default:
        return _DefaultAbstractLayout(type: type);
    }
  }
}

// ── INVOICE LAYOUTS ─────────────────────────────────────────────────────────

class _ModernMinimalLayout extends StatelessWidget {
  const _ModernMinimalLayout();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 14, height: 14, color: Colors.grey.shade800),
              Container(width: 20, height: 6, color: Colors.grey.shade800),
            ],
          ),
          const SizedBox(height: 12),
          Container(width: 25, height: 2, color: Colors.grey.shade300),
          const SizedBox(height: 2),
          Container(width: 40, height: 2, color: Colors.grey.shade200),
          const Spacer(),
          for (int i = 0; i < 5; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(
                children: [
                  Container(width: 35, height: 1.5, color: Colors.grey.shade200),
                  const Spacer(),
                  Container(width: 12, height: 1.5, color: Colors.grey.shade400),
                ],
              ),
            ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: Container(width: 30, height: 8, color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }
}

class _CorporateClassicLayout extends StatelessWidget {
  const _CorporateClassicLayout();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 4, color: Colors.grey.shade800),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 12, height: 12, color: Colors.grey.shade300),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(width: 20, height: 3, color: Colors.grey.shade700),
                        const SizedBox(height: 2),
                        Container(width: 15, height: 2, color: Colors.grey.shade400),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Container(height: 1, width: double.infinity, color: Colors.grey.shade200),
                const SizedBox(height: 8),
                for (int i = 0; i < 6; i++)
                  Container(
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 2),
                    decoration: BoxDecoration(
                      color: i == 0 ? Colors.grey.shade100 : Colors.transparent,
                      border: Border.all(color: Colors.grey.shade100, width: 0.5),
                    ),
                  ),
                const Spacer(),
                Row(
                  children: [
                    const Spacer(),
                    Container(width: 22, height: 18, decoration: BoxDecoration(color: Colors.grey.shade50, border: Border.all(color: Colors.grey.shade200))),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BoldAccentLayout extends StatelessWidget {
  const _BoldAccentLayout();
  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF1A1A1A);
    const accent = Color(0xFFFF6B35);
    return Column(
      children: [
        Container(
          height: 30,
          width: double.infinity,
          color: primary,
          child: Center(child: Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2)))),
        ),
        Container(height: 3, width: double.infinity, color: accent),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 4),
                Container(width: 40, height: 5, color: primary.withOpacity(0.8)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 25, height: 12, color: Colors.grey.shade100),
                    Container(width: 25, height: 12, color: Colors.grey.shade100),
                  ],
                ),
                const Spacer(),
                Container(height: 5, width: double.infinity, color: Colors.grey.shade200),
                const SizedBox(height: 4),
                for (int i = 0; i < 4; i++)
                   Container(height: 2, margin: const EdgeInsets.only(bottom: 3), color: Colors.grey.shade100),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(width: 35, height: 12, decoration: BoxDecoration(color: accent.withOpacity(0.15), border: Border(left: BorderSide(color: accent, width: 2)))),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _InvoiceServiceLayout extends StatelessWidget {
  const _InvoiceServiceLayout();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 15, height: 15, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          Container(width: 40, height: 4, color: Colors.grey.shade800),
          const SizedBox(height: 15),
          for (int i = 0; i < 3; i++) ...[
            Row(
              children: [
                Container(width: 10, height: 10, color: Colors.grey.shade100),
                const SizedBox(width: 8),
                Expanded(child: Container(height: 10, color: Colors.grey.shade50)),
              ],
            ),
            const SizedBox(height: 6),
          ],
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: Container(width: 20, height: 10, color: Colors.grey.shade300),
          )
        ],
      ),
    );
  }
}

class _InvoiceSimpleLayout extends StatelessWidget {
  const _InvoiceSimpleLayout();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(width: 20, height: 20, decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle)),
          const SizedBox(height: 8),
          Container(width: 40, height: 3, color: Colors.grey.shade800),
          const SizedBox(height: 20),
          for (int i = 0; i < 4; i++) ...[
            Container(width: double.infinity, height: 1, color: Colors.grey.shade200),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 30, height: 2, color: Colors.grey.shade400),
                Container(width: 10, height: 2, color: Colors.grey.shade600),
              ],
            ),
            const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }
}

class _InvoiceLuxuryLayout extends StatelessWidget {
  const _InvoiceLuxuryLayout();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A1A),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD4AF37), width: 1))),
          const SizedBox(height: 15),
          Container(width: 40, height: 2, color: const Color(0xFFD4AF37).withOpacity(0.5)),
          const Spacer(),
          for (int i = 0; i < 4; i++)
             Container(width: double.infinity, height: 1, margin: const EdgeInsets.only(bottom: 6), color: Colors.white10),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: Container(width: 25, height: 6, color: const Color(0xFFD4AF37)),
          )
        ],
      ),
    );
  }
}

// ── PROPOSAL LAYOUTS ────────────────────────────────────────────────────────

class _ExecutiveLayout extends StatelessWidget {
  const _ExecutiveLayout();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 50, height: 6, color: Colors.grey.shade800),
          const SizedBox(height: 8),
          Container(width: double.infinity, height: 1.5, color: Colors.grey.shade300),
          const SizedBox(height: 6),
          for (int i = 0; i < 10; i++)
            Container(
              width: i == 4 || i == 8 ? 40 : double.infinity,
              height: 2,
              margin: const EdgeInsets.only(bottom: 2.5),
              color: Colors.grey.shade100,
            ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 20, height: 20, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(4))),
              Container(width: 30, height: 6, color: Colors.grey.shade400),
            ],
          )
        ],
      ),
    );
  }
}

class _CreativeLayout extends StatelessWidget {
  const _CreativeLayout();
  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFFF6B35);
    return Stack(
      children: [
        Positioned(
          top: -15,
          right: -15,
          child: Container(width: 50, height: 50, decoration: BoxDecoration(color: accent.withOpacity(0.1), shape: BoxShape.circle)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 18, height: 18, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 16),
              Container(width: 50, height: 10, color: accent.withOpacity(0.3)),
              const SizedBox(height: 6),
              Container(width: 35, height: 4, color: Colors.grey.shade200),
              const Spacer(),
              for (int i = 0; i < 5; i++)
                Container(width: double.infinity, height: 2, margin: const EdgeInsets.only(bottom: 3), color: Colors.grey.shade100),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(width: 12, height: 12, decoration: BoxDecoration(color: accent.withOpacity(0.2), shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  Container(width: 25, height: 3, color: Colors.grey.shade200),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class _TechnicalLayout extends StatelessWidget {
  const _TechnicalLayout();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 10, height: 10, color: Colors.grey.shade900),
              const SizedBox(width: 6),
              Container(width: 40, height: 4, color: Colors.grey.shade300),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < 3; i++) ...[
            Container(width: 25, height: 3, color: Colors.grey.shade400),
            const SizedBox(height: 4),
            Container(width: double.infinity, height: 15, decoration: BoxDecoration(color: Colors.grey.shade50, border: Border.all(color: Colors.grey.shade200))),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _ProposalStartupLayout extends StatelessWidget {
  const _ProposalStartupLayout();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 30, height: 30, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
          const Spacer(),
          Container(width: 60, height: 12, color: Colors.black),
          const SizedBox(height: 8),
          Container(width: 40, height: 6, color: const Color(0xFFFF6B35)),
          const Spacer(flex: 2),
          Container(width: double.infinity, height: 2, color: Colors.grey.shade200),
        ],
      ),
    );
  }
}

class _ProposalRoadmapLayout extends StatelessWidget {
  const _ProposalRoadmapLayout();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 45, height: 4, color: Colors.grey.shade800),
          const SizedBox(height: 20),
          for (int i = 0; i < 4; i++) ...[
            Row(
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: i == 0 ? const Color(0xFFFF6B35) : Colors.grey.shade300, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(child: Container(height: 2, color: Colors.grey.shade100)),
              ],
            ),
            if (i < 3) Container(width: 1, height: 12, margin: const EdgeInsets.only(left: 3.5), color: Colors.grey.shade200),
          ],
        ],
      ),
    );
  }
}

// ── LETTERHEAD LAYOUTS ──────────────────────────────────────────────────────

class _LetterheadCenteredLayout extends StatelessWidget {
  const _LetterheadCenteredLayout();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                Container(width: 16, height: 16, decoration: BoxDecoration(color: Colors.grey.shade400, shape: BoxShape.circle)),
                const SizedBox(height: 4),
                Container(width: 30, height: 3, color: Colors.grey.shade800),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 20, height: 2, color: Colors.grey.shade300),
                const SizedBox(height: 4),
                Container(width: 40, height: 2, color: Colors.grey.shade200),
              ],
            ),
          ),
          const Spacer(),
          for (int i = 0; i < 12; i++)
            Container(width: double.infinity, height: 1.5, margin: const EdgeInsets.only(bottom: 3), color: Colors.grey.shade100),
          const Spacer(),
          Container(width: double.infinity, height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 10, height: 2, color: Colors.grey.shade300),
              const SizedBox(width: 8),
              Container(width: 10, height: 2, color: Colors.grey.shade300),
              const SizedBox(width: 8),
              Container(width: 10, height: 2, color: Colors.grey.shade300),
            ],
          )
        ],
      ),
    );
  }
}

class _LetterheadSidebarLayout extends StatelessWidget {
  const _LetterheadSidebarLayout();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 25,
          height: double.infinity,
          color: Colors.grey.shade50,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Column(
            children: [
              Container(width: 14, height: 14, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              const Spacer(),
              for (int i = 0; i < 4; i++) ...[
                Container(width: 12, height: 2, color: Colors.grey.shade300),
                const SizedBox(height: 4),
              ],
              const Spacer(),
              Container(width: 12, height: 12, color: Colors.grey.shade200),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(width: 25, height: 3, color: Colors.grey.shade200),
                ),
                const SizedBox(height: 20),
                for (int i = 0; i < 15; i++)
                   Container(width: double.infinity, height: 1.5, margin: const EdgeInsets.only(bottom: 3), color: Colors.grey.shade100),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _LetterheadMinimalLayout extends StatelessWidget {
  const _LetterheadMinimalLayout();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 14, height: 14, color: Colors.black87),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(width: 25, height: 2, color: Colors.grey.shade400),
                  const SizedBox(height: 2),
                  Container(width: 20, height: 2, color: Colors.grey.shade400),
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          Container(width: double.infinity, height: 0.5, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          for (int i = 0; i < 18; i++)
            Container(width: i == 17 ? 50 : double.infinity, height: 1.5, margin: const EdgeInsets.only(bottom: 3), color: Colors.grey.shade100),
        ],
      ),
    );
  }
}

class _LetterheadCorneredLayout extends StatelessWidget {
  const _LetterheadCorneredLayout();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(width: 20, height: 20, color: Colors.grey.shade800),
          ),
          const SizedBox(height: 30),
          for (int i = 0; i < 15; i++)
             Container(width: double.infinity, height: 1.5, margin: const EdgeInsets.only(bottom: 4), color: Colors.grey.shade100),
        ],
      ),
    );
  }
}

// ── BUSINESS CARD LAYOUTS ───────────────────────────────────────────────────

class _BusinessCardMinimalLayout extends StatelessWidget {
  const _BusinessCardMinimalLayout();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Container(width: 32, height: 32, decoration: BoxDecoration(color: Colors.grey.shade900, shape: BoxShape.circle)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 50, height: 5, color: Colors.grey.shade900),
                const SizedBox(height: 3),
                Container(width: 35, height: 3, color: Colors.grey.shade400),
                const SizedBox(height: 8),
                Container(width: double.infinity, height: 1, color: Colors.grey.shade200),
                const SizedBox(height: 6),
                Container(width: 45, height: 2, color: Colors.grey.shade300),
                const SizedBox(height: 3),
                Container(width: 45, height: 2, color: Colors.grey.shade300),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _BusinessCardGeometricLayout extends StatelessWidget {
  const _BusinessCardGeometricLayout();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: -15,
          top: -15,
          child: Transform.rotate(angle: 0.4, child: Container(width: 60, height: 100, decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(4)))),
        ),
        Positioned(
          left: 5,
          top: 5,
          child: Container(width: 14, height: 14, decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle)),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(width: 55, height: 6, color: Colors.grey.shade900),
                const SizedBox(height: 4),
                Container(width: 40, height: 3, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                for (int i = 0; i < 3; i++)
                   Container(width: 30, height: 2, margin: const EdgeInsets.only(bottom: 3), color: Colors.grey.shade400),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _BusinessCardClassicLayout extends StatelessWidget {
  const _BusinessCardClassicLayout();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300, width: 0.5)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 12, height: 12, decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade800, width: 1.5))),
              const SizedBox(height: 8),
              Container(width: 60, height: 4, color: Colors.grey.shade900),
              const SizedBox(height: 2),
              Container(width: 40, height: 2, color: Colors.grey.shade600),
              const SizedBox(height: 10),
              Container(width: 50, height: 1, color: Colors.grey.shade200),
              const SizedBox(height: 8),
              Container(width: 55, height: 2, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}

class _BusinessCardVerticalLayout extends StatelessWidget {
  const _BusinessCardVerticalLayout();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          Container(width: 30, height: 30, decoration: BoxDecoration(color: Colors.grey.shade800, borderRadius: BorderRadius.circular(4))),
          const Spacer(),
          Container(width: 50, height: 6, color: Colors.black),
          const SizedBox(height: 4),
          Container(width: 30, height: 2, color: Colors.grey),
          const Spacer(),
          Container(width: double.infinity, height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 6),
          Container(width: 40, height: 2, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}

class _BusinessCardSocialLayout extends StatelessWidget {
  const _BusinessCardSocialLayout();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 15, height: 15, color: Colors.black),
              const SizedBox(width: 8),
              Container(width: 40, height: 4, color: Colors.black),
            ],
          ),
          const Spacer(),
          for (int i = 0; i < 3; i++) ...[
            Row(
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Container(width: 30, height: 2, color: Colors.grey.shade400),
              ],
            ),
            const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }
}

// ── CONTRACT LAYOUTS ────────────────────────────────────────────────────────

class _ContractStandardLayout extends StatelessWidget {
  const _ContractStandardLayout();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40, height: 5, color: Colors.grey.shade800)),
          const SizedBox(height: 12),
          for (int i = 0; i < 3; i++) ...[
            Container(width: 30, height: 3, color: Colors.grey.shade600),
            const SizedBox(height: 4),
            for (int j = 0; j < 3; j++)
              Container(width: double.infinity, height: 1.5, margin: const EdgeInsets.only(bottom: 2), color: Colors.grey.shade100),
            const SizedBox(height: 6),
          ],
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 30, height: 1, color: Colors.grey.shade400),
              Container(width: 30, height: 1, color: Colors.grey.shade400),
            ],
          )
        ],
      ),
    );
  }
}

class _ContractModernLayout extends StatelessWidget {
  const _ContractModernLayout();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 50, height: 8, color: Colors.grey.shade800),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(4)),
            child: Column(
              children: [
                Container(width: double.infinity, height: 3, color: Colors.grey.shade300),
                const SizedBox(height: 4),
                Container(width: 50, height: 3, color: Colors.grey.shade200),
              ],
            ),
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < 8; i++)
            Container(width: double.infinity, height: 2, margin: const EdgeInsets.only(bottom: 4), color: Colors.grey.shade100),
        ],
      ),
    );
  }
}

class _ContractSimpleLayout extends StatelessWidget {
  const _ContractSimpleLayout();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 12, height: 12, color: Colors.grey.shade300),
              const SizedBox(width: 8),
              Container(width: 35, height: 4, color: Colors.grey.shade800),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < 12; i++)
             Container(width: i % 4 == 0 ? 60 : double.infinity, height: 1.5, margin: const EdgeInsets.only(bottom: 3), color: Colors.grey.shade100),
          const Spacer(),
          Container(width: 40, height: 8, decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300))),
        ],
      ),
    );
  }
}

class _ContractNDALayout extends StatelessWidget {
  const _ContractNDALayout();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Container(width: 40, height: 6, color: Colors.black),
          const SizedBox(height: 20),
          Container(width: double.infinity, height: 40, decoration: BoxDecoration(color: Colors.grey.shade50, border: Border.all(color: Colors.grey.shade200))),
          const Spacer(),
          Container(width: double.infinity, height: 2, color: Colors.grey.shade200),
        ],
      ),
    );
  }
}

class _ContractSOWLayout extends StatelessWidget {
  const _ContractSOWLayout();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 50, height: 4, color: Colors.grey.shade800),
          const SizedBox(height: 12),
          for (int i = 0; i < 3; i++) ...[
            Container(width: 20, height: 2, color: Colors.grey.shade400),
            const SizedBox(height: 4),
            Container(width: double.infinity, height: 12, decoration: BoxDecoration(color: Colors.grey.shade50, border: Border.all(color: Colors.grey.shade100))),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

// ── LOGO LAYOUTS ───────────────────────────────────────────────────────────

class _LogoMinimalLayout extends StatelessWidget {
  const _LogoMinimalLayout();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade900, width: 2.5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(width: 16, height: 16, color: Colors.grey.shade900),
          ),
        ),
      ),
    );
  }
}

class _LogoTypographyLayout extends StatelessWidget {
  const _LogoTypographyLayout();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 18, height: 18, decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Container(width: 35, height: 8, decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(1))),
            ],
          ),
          const SizedBox(height: 4),
          Container(width: 45, height: 2, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}

class _LogoEmblemLayout extends StatelessWidget {
  const _LogoEmblemLayout();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade800, width: 1.5),
        ),
        padding: const EdgeInsets.all(4),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade800, width: 3),
          ),
          child: Center(
            child: Icon(Icons.star_rounded, color: Colors.grey.shade800, size: 24),
          ),
        ),
      ),
    );
  }
}

class _LogoMonogramLayout extends StatelessWidget {
  const _LogoMonogramLayout();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1))),
          const Text('BZ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }
}

class _LogoTechLayout extends StatelessWidget {
  const _LogoTechLayout();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < 3; i++)
            Container(width: 8, height: 24, margin: const EdgeInsets.symmetric(horizontal: 2), color: Colors.black),
          const SizedBox(width: 4),
          Container(width: 20, height: 24, color: const Color(0xFFFF6B35)),
        ],
      ),
    );
  }
}

// ── ICON LAYOUTS ───────────────────────────────────────────────────────────

class _IconFlatLayout extends StatelessWidget {
  const _IconFlatLayout();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade900,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(width: 30, height: 30, decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(8))),
            const Icon(Icons.bolt_rounded, color: Colors.white, size: 32),
          ],
        ),
      ),
    );
  }
}

class _IconGradientLayout extends StatelessWidget {
  const _IconGradientLayout();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey.shade800, Colors.grey.shade900],
        ),
      ),
      child: Center(
        child: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}

class _IconGlyphLayout extends StatelessWidget {
  const _IconGlyphLayout();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      child: Center(
        child: Icon(Icons.layers_outlined, color: Colors.grey.shade900, size: 48),
      ),
    );
  }
}

class _IconGlassLayout extends StatelessWidget {
  const _IconGlassLayout();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFF6B35).withOpacity(0.1),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(10))),
            Container(width: 25, height: 25, decoration: BoxDecoration(color: const Color(0xFFFF6B35).withOpacity(0.4), borderRadius: BorderRadius.circular(6))),
          ],
        ),
      ),
    );
  }
}

class _IconIsometricLayout extends StatelessWidget {
  const _IconIsometricLayout();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(-0.5)
          ..rotateY(0.5),
        alignment: FractionalOffset.center,
        child: Container(width: 40, height: 40, color: Colors.grey.shade800),
      ),
    );
  }
}

class _DefaultAbstractLayout extends StatelessWidget {
  const _DefaultAbstractLayout({required this.type});
  final DocumentType type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 20, height: 4, color: Colors.grey.shade300),
          const SizedBox(height: 8),
          for (int i = 0; i < 4; i++)
            Container(
              width: double.infinity,
              height: 2,
              margin: const EdgeInsets.only(bottom: 3),
              color: Colors.grey.shade100,
            ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(width: 15, height: 2, color: Colors.grey.shade200),
            ],
          )
        ],
      ),
    );
  }
}
