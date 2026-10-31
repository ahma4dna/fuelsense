import 'package:flutter/material.dart';
import 'package:fuelsense/core/application/resource/app_colors.dart';
import 'package:fuelsense/core/application/resource/app_context.dart';
import 'package:fuelsense/core/application/resource/app_size.dart';
import 'package:fuelsense/core/application/resource/app_styles.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appContext = AppContext.of(context);
    final localText = appContext.localText;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: AppSize.s28,
            color: const Color(0xFF11201F),
          ),
        ),
        title: Text(
          localText.terms_of_use,
          style: AppStyles.getExtraBold(
            context: context,
            fontSize: AppSize.s18,
            color: const Color(0xFF11201F),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSize.s20,
            AppSize.s8,
            AppSize.s20,
            AppSize.s28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Container(
                padding: EdgeInsets.all(AppSize.s20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A3832),
                  borderRadius: BorderRadius.circular(AppSize.s20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.gavel_rounded,
                      color: const Color(0xFF4DB6AC),
                      size: AppSize.s34,
                    ),
                    Gap(AppSize.s14),
                    Expanded(
                      child: Text(
                        localText.fuelsense_terms_agreement,
                        style: AppStyles.getExtraBold(
                          context: context,
                          fontSize: AppSize.s16,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Gap(AppSize.s18),

              _PolicySectionCard(
                number: '1',
                title: localText.terms_section_1_title,
                content: localText.terms_section_1_content,
              ),

              _PolicySectionCard(
                number: '2',
                title: localText.terms_section_2_title,
                content: localText.terms_section_2_content,
              ),

              _PolicySectionCard(
                number: '3',
                title: localText.terms_section_3_title,
                content: localText.terms_section_3_content,
              ),

              _PolicySectionCard(
                number: '4',
                title: localText.terms_section_4_title,
                content: localText.terms_section_4_content,
              ),

              _PolicySectionCard(
                number: '5',
                title: localText.terms_section_5_title,
                content: localText.terms_section_5_content,
              ),

              Gap(AppSize.s10),
            ],
          ),
        ),
      ),
    );
  }
}

class _PolicySectionCard extends StatelessWidget {
  final String number;
  final String title;
  final String content;

  const _PolicySectionCard({
    required this.number,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSize.s14),
      padding: EdgeInsets.all(AppSize.s18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSize.s18),
        border: Border.all(
          color: const Color(0xFFE6E2D9),
          width: AppSize.s1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppSize.s28,
                height: AppSize.s28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF9F7),
                  borderRadius: BorderRadius.circular(AppSize.s8),
                ),
                child: Text(
                  number,
                  style: AppStyles.getExtraBold(
                    context: context,
                    fontSize: AppSize.s14,
                    color: const Color(0xFF0F6E67),
                  ),
                ),
              ),
              Gap(AppSize.s10),
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.getExtraBold(
                    context: context,
                    fontSize: AppSize.s15,
                    color: const Color(0xFF11201F),
                  ),
                ),
              ),
            ],
          ),
          Gap(AppSize.s10),
          Text(
            content,
            style: AppStyles.getMeduim(
              context: context,
              fontSize: AppSize.s14,
              color: const Color(0xFF4A5957),
            ).copyWith(height: 1.65),
          ),
        ],
      ),
    );
  }
}
