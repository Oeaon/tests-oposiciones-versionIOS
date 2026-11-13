import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String formatEuros(double eur, String locale) => NumberFormat.currency(locale: locale, symbol: '€', decimalDigits: 2).format(eur);

String formatPercent(double percent, String locale) => '${NumberFormat('0.00', locale).format(percent)} %';

/// Texto de un campo numérico → número. La coma es decimal ("1500,50"); el punto se toma como
/// separador de miles salvo que vaya seguido de una o dos cifras al final ("1500.5").
double? parseAmount(String text) {
  final String normalized;
  if (text.contains(',')) {
    normalized = text.replaceAll('.', '').replaceAll(',', '.');
  } else if (RegExp(r'\.\d{1,2}$').hasMatch(text) && '.'.allMatches(text).length == 1) {
    normalized = text;
  } else {
    normalized = text.replaceAll('.', '');
  }
  return double.tryParse(normalized);
}

class AmountField extends StatefulWidget {
  const AmountField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.suffix = '€',
    this.decimals = true,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String label;
  final String suffix;
  final bool decimals;

  @override
  State<AmountField> createState() => _AmountFieldState();
}

class _AmountFieldState extends State<AmountField> {
  late final TextEditingController _controller = TextEditingController(text: widget.value);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(labelText: widget.label, suffixText: widget.suffix, border: const OutlineInputBorder()),
      keyboardType: TextInputType.numberWithOptions(decimal: widget.decimals),
      inputFormatters: [
        FilteringTextInputFormatter.allow(widget.decimals ? RegExp(r'[0-9.,]') : RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(12),
      ],
      // En iOS el teclado numérico no tiene "Hecho": se cierra al tocar fuera.
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
    );
  }
}

class Choice<T> extends StatelessWidget {
  const Choice({super.key, required this.options, required this.selected, required this.onSelect});

  final List<(T, String)> options;
  final T selected;
  final ValueChanged<T> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<T>(
        segments: [for (final (value, label) in options) ButtonSegment(value: value, label: Text(label))],
        selected: {selected},
        showSelectedIcon: false,
        onSelectionChanged: (s) => onSelect(s.first),
      ),
    );
  }
}

/// Contador de 0 a [max] con botones − y +.
class CountStepper extends StatelessWidget {
  const CountStepper({super.key, required this.label, required this.value, required this.onChanged, this.max = 10});

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Text(label)),
      IconButton.filledTonal(onPressed: value > 0 ? () => onChanged(value - 1) : null, icon: const Icon(Icons.remove)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text('$value', style: Theme.of(context).textTheme.titleMedium),
      ),
      IconButton.filledTonal(onPressed: value < max ? () => onChanged(value + 1) : null, icon: const Icon(Icons.add)),
    ]);
  }
}

class ResultCard extends StatelessWidget {
  const ResultCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 6, children: children),
      ),
    );
  }
}

class ResultRow extends StatelessWidget {
  const ResultRow({super.key, required this.label, required this.value, this.color, this.bold = false});

  final String label;
  final String value;
  final Color? color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge;
    return Row(children: [
      if (color != null) ...[
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
      ],
      Expanded(child: Text(label, style: style)),
      Text(value, style: style?.copyWith(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
    ]);
  }
}

/// Barra horizontal con el reparto del bruto.
class StackedBar extends StatelessWidget {
  const StackedBar({super.key, required this.parts});

  final List<(double, Color)> parts;

  @override
  Widget build(BuildContext context) {
    final visible = parts.where((p) => p.$1 > 0).toList();
    if (visible.isEmpty) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: SizedBox(
        height: 14,
        child: Row(children: [
          for (final (value, color) in visible) Expanded(flex: (value * 100).round(), child: ColoredBox(color: color, child: const SizedBox.expand())),
        ]),
      ),
    );
  }
}

class Note extends StatelessWidget {
  const Note(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(text, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant));
  }
}

/// Columna con desplazamiento y separación estándar para cada calculadora.
class FormColumn extends StatelessWidget {
  const FormColumn({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: 12, children: children),
    );
  }
}
