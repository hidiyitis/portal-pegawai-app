import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_pegawai_app/common/constants/routes/routes_name.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/domain/entities/cuti_entity.dart';
import 'package:portal_pegawai_app/domain/entities/kuota_cuti_entity.dart';
import 'package:portal_pegawai_app/presentation/cuti/bloc/cuti_cubit.dart';
import 'package:portal_pegawai_app/presentation/cuti/bloc/cuti_state.dart';
import 'package:portal_pegawai_app/presentation/cuti/widgets/cuti_item_widget.dart';
import 'package:portal_pegawai_app/presentation/cuti/widgets/kuota_cuti_card_widget.dart';
import 'package:portal_pegawai_app/presentation/cuti/widgets/status_filter_widget.dart';
import 'package:portal_pegawai_app/core/configs/inject_dependency.dart';

// Halaman pengajuan cuti yang dioptimasi untuk scrolling experience yang superior
// Seperti seorang interior designer yang merancang ruang agar setiap area memiliki fungsi
// dan proporsi yang tepat, kita akan mengatur layout agar setiap komponen memiliki
// space yang optimal dan user dapat navigate dengan mudah
class PengajuanCutiPage extends StatefulWidget {
  const PengajuanCutiPage({super.key});

  @override
  _PengajuanCutiPageState createState() => _PengajuanCutiPageState();
}

class _PengajuanCutiPageState extends State<PengajuanCutiPage> {
  String _currentFilter = 'semua';
  late CutiCubit _cutiCubit;
  KuotaCutiEntity? _kuotaCuti;
  List<CutiEntity>? _daftarCuti;
  bool _isLoading = false;

  // ScrollController untuk memberikan kontrol yang lebih granular terhadap scrolling behavior
  // Ini seperti memiliki remote control untuk TV - kita bisa mengatur channel, volume,
  // dan berbagai aspek viewing experience dengan lebih presisi
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentFilter = 'semua';
    _cutiCubit = CutiCubit(cutiRepository: getIt());
    _loadData();
  }

  @override
  void dispose() {
    // Cleanup ScrollController untuk mencegah memory leaks
    // Ini penting karena ScrollController mendengarkan scroll events
    _scrollController.dispose();
    super.dispose();
  }

  void _loadData() {
    setState(() {
      _isLoading = true;
    });
    _cutiCubit.loadAllData(filter: _currentFilter).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background color yang consistent untuk seamless experience
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        // Shadow yang subtle untuk depth tanpa mengganggu visual flow
        shadowColor: Colors.black.withOpacity(0.1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Pengajuan Cuti',
          style: TextStyle(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: AppTextSize.headingSmall,
          ),
        ),
      ),
      body: BlocBuilder<CutiCubit, CutiState>(
        bloc: _cutiCubit,
        builder: (context, state) {
          if (state is CutiDataLoaded) {
            _kuotaCuti = state.kuotaCuti;
            _daftarCuti = state.daftarCuti;
          }

          return _buildOptimizedLayout();
        },
      ),
    );
  }

  // Method untuk membangun layout yang dioptimasi dengan scrolling behavior yang superior
  // Layout ini menggunakan prinsip "progressive disclosure" dimana informasi penting
  // ditampilkan di atas, dan detail ditampilkan dengan scrolling yang smooth
  Widget _buildOptimizedLayout() {
    return RefreshIndicator(
      onRefresh: () async {
        _loadData();
        await Future.delayed(Duration(milliseconds: 500));
      },
      color: AppColors.primary,
      backgroundColor: Colors.white,
      child: CustomScrollView(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          // Kuota cuti card - tidak ada perubahan
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child:
                  _kuotaCuti != null
                      ? KuotaCutiCardWidget(
                        kuotaTotal: _kuotaCuti!.total,
                        dalamPengajuan: _kuotaCuti!.dalamPengajuan,
                        ditolak: _kuotaCuti!.ditolak,
                        disetujui: _kuotaCuti!.disetujui,
                        onAjukanPressed: () {
                          Navigator.of(
                            context,
                          ).pushNamed(RoutesName.formCuti).then((_) {
                            _loadData();
                          });
                        },
                      )
                      : _buildKuotaCardSkeleton(),
            ),
          ),

          // PERBAIKAN UTAMA: Ganti SliverPersistentHeader dengan SliverToBoxAdapter
          // SliverToBoxAdapter akan selalu rebuild ketika parent widget rebuild
          SliverToBoxAdapter(
            child: Container(
              color: Colors.grey[50],
              padding: EdgeInsets.symmetric(vertical: 8),
              child: StatusFilterWidget(
                currentFilter:
                    _currentFilter, // Pastikan menggunakan state yang tepat
                onFilterChanged: (filter) {
                  // PENTING: setState untuk memastikan UI rebuild
                  setState(() {
                    _currentFilter = filter;
                  });

                  // Load data dengan filter baru
                  _loadData();

                  // Smooth scroll to top untuk better UX
                  _scrollController.animateTo(
                    0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          ),

          // Spacing antara filter dan list
          SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Main content area
          _buildCutiListSliver(),

          // Bottom padding
          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  // Method untuk membangun list cuti dalam format sliver untuk optimal performance
  // SliverList memberikan performance yang superior untuk large datasets karena
  // menggunakan lazy loading dan viewport-based rendering
  Widget _buildCutiListSliver() {
    if (_isLoading) {
      return SliverToBoxAdapter(
        child: Container(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: 16),
                Text(
                  'Memuat data pengajuan...',
                  style: TextStyle(
                    color: AppColors.onSecondary,
                    fontSize: AppTextSize.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_daftarCuti == null || _daftarCuti!.isEmpty) {
      return SliverToBoxAdapter(child: _buildEmptyState());
    }

    // SliverList dengan delegate yang optimal untuk performance
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final cuti = _daftarCuti![index];
          return Container(
            // Margin yang calculated untuk spacing yang optimal antara cards
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: CutiItemWidget(
              cuti: cuti,
              onTap: () {
                // Implementasi onTap jika diperlukan
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Detail untuk cuti: ${cuti.kegiatan}'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
          );
        },
        childCount: _daftarCuti!.length,
        // Performance optimization: specify semanticIndexCallback untuk better accessibility
        semanticIndexCallback: (widget, localIndex) => localIndex,
      ),
    );
  }

  // Widget untuk empty state yang engaging dan informative
  // Empty state bukan hanya placeholder, tetapi opportunity untuk guide user ke action
  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon yang ekspresif untuk empty state
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_available,
              size: 64,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 24),

          Text(
            'Belum Ada Pengajuan Cuti',
            style: TextStyle(
              color: AppColors.onPrimary,
              fontSize: AppTextSize.headingMedium,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),

          Text(
            _getEmptyStateMessage(),
            style: TextStyle(
              color: AppColors.onSecondary,
              fontSize: AppTextSize.bodyMedium,
              height: 1.5, // Line height untuk readability yang better
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),

          // Action button yang encourage user untuk take action
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed(RoutesName.formCuti).then((_) {
                _loadData();
              });
            },
            icon: Icon(Icons.add_circle_outline),
            label: Text('Ajukan Cuti Pertama'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method untuk mendapatkan pesan empty state yang contextual berdasarkan filter
  String _getEmptyStateMessage() {
    switch (_currentFilter) {
      case 'dalam_pengajuan':
        return 'Tidak ada pengajuan yang sedang dalam proses. Pengajuan baru akan muncul di sini.';
      case 'disetujui':
        return 'Belum ada pengajuan yang disetujui. Setelah manager menyetujui, akan muncul di sini.';
      case 'ditolak':
        return 'Tidak ada pengajuan yang ditolak. Semoga pengajuan Anda selalu disetujui!';
      default:
        return 'Mulai ajukan cuti pertama Anda dengan menekan tombol di bawah ini.';
    }
  }

  // Skeleton loading untuk kuota card yang memberikan perceived performance yang better
  // Skeleton loading membuat user merasa aplikasi lebih responsive karena ada visual feedback
  Widget _buildKuotaCardSkeleton() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skeleton untuk header
          Container(
            height: 20,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 16),

          // Skeleton untuk kuota number
          Container(
            height: 32,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 24),

          // Skeleton untuk status items
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Skeleton untuk button
          Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom delegate untuk persistent header yang memberikan kontrol granular terhadap behavior
// Seperti seorang stage manager yang mengatur kapan backdrop naik dan turun,
// delegate ini mengatur kapan filter header muncul dan hilang
class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _FilterHeaderDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 80; // Height maximum untuk header

  @override
  double get minExtent => 80; // Height minimum untuk header

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false; // Rebuild hanya jika diperlukan untuk performance
  }
}
