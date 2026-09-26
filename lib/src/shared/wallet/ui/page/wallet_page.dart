import 'package:flutter/material.dart';
import 'package:ponte_glam/src/shared/wallet/ui/cubit/wallet_cubit.dart';
import 'package:ponte_glam/src/shared/wallet/ui/cubit/wallet_state.dart';
import 'package:ponte_glam/src/shared/wallet/data/model/wallet_model.dart';
import 'package:ponte_glam/shared/widgets/snack_bar_simple_widget.dart';
import 'package:intl/intl.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:ponte_glam/di/shared_imports.dart';

class WalletPage extends StatefulWidget {
  static const routeName = 'wallet';
  final FancyDrawerController? controllerMenu;
  const WalletPage({super.key, this.controllerMenu});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconAnimationController;
  late Animation<double> _animation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_iconAnimationController);
    context.read<WalletCubit>().loadWallet();
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (_isOpen) {
      _iconAnimationController.reverse();
      widget.controllerMenu?.close();
    } else {
      _iconAnimationController.forward();
      widget.controllerMenu?.toggle();
    }
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Billetera'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colors.onSurface,
        leading: widget.controllerMenu != null
            ? IconButton(
                icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_arrow,
                  progress: _animation,
                  color: colors.onSurface,
                ),
                onPressed: _toggleMenu,
              )
            : null,
      ),
      body: BlocConsumer<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state.status == WalletStatus.failure) {
            PonteSnackBar.show(
              context,
              message: state.errorMessage ?? 'Error al cargar billetera',
              type: TypeAlert.error,
            );
          }
        },
        builder: (context, state) {
          if (state.status == WalletStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final wallet = state.wallet;
          if (wallet == null) {
            return const Center(
                child: Text('No se pudo cargar la información'));
          }

          return RefreshIndicator(
            onRefresh: () => context.read<WalletCubit>().loadWallet(),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _BalanceCard(balance: wallet.balance),
                      if (wallet.balanceDouble < 0) ...[
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _PendingDebtNotice(
                            balance: wallet.balanceDouble,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Historial de movimientos',
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (wallet.transactions.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: Text(
                          'No hay movimientos registrados aún',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final tx = wallet.transactions[index];
                        return _TransactionItem(transaction: tx);
                      },
                      childCount: wallet.transactions.length,
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PendingDebtNotice extends StatelessWidget {
  final double balance;

  const _PendingDebtNotice({required this.balance});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final formattedDebt = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    ).format(balance.abs());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.error.withValues(alpha: 0.5)),
      ),
      child: Text(
        'Tienes una deuda pendiente de $formattedDebt. Acércate al local para saldarla.',
        style: TextStyle(
          color: colors.onErrorContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final String balance;
  const _BalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isNegative = balance.startsWith('-');

    // Simple currency formatting for display
    final formattedBalance = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
      locale: 'es_CO',
    ).format(double.tryParse(balance) ?? 0);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isNegative
              ? [Colors.red.shade700, Colors.red.shade400]
              : [colors.primary, colors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isNegative ? Colors.red : colors.primary).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Saldo disponible',
                style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
              const Icon(Icons.account_balance_wallet, color: Colors.white54),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            formattedBalance,
            style: textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isNegative)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Tienes una deuda pendiente',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final WalletTransactionModel transaction;
  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    IconData icon;
    Color iconColor;
    String prefix = '';

    if (transaction.isDeposit) {
      icon = Icons.add_circle_outline;
      iconColor = Colors.green;
      prefix = '+';
    } else if (transaction.isDebt) {
      icon = Icons.remove_circle_outline;
      iconColor = Colors.red;
      prefix = '-';
    } else {
      icon = Icons.payment;
      iconColor = Colors.blue;
      prefix = '-';
    }

    final formattedAmount = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
      locale: 'es_CO',
    ).format(double.tryParse(transaction.amount)?.abs() ?? 0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.typeLabel,
                  style: textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.description,
                  style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.createdAt,
                  style: textTheme.labelSmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            '$prefix $formattedAmount',
            style: textTheme.bodyLarge?.copyWith(
              color: iconColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
