import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../exports.dart';

class PdfUtil {
  static pw.Padding getPlayers(
      List<MapEntry<String, List<int>>> players_entries) {
    return pw.Padding(
        padding: pw.EdgeInsets.symmetric(vertical: 5),
        child: pw.Table(columnWidths: const <int, pw.TableColumnWidth>{
          0: pw.FlexColumnWidth(4),
          1: pw.FlexColumnWidth(1),
        },children: [
          pw.TableRow(
            children: [
              _buildHeaderCell('Match Points',
                  fontSize: 13,
                  padding: const pw.EdgeInsets.fromLTRB(10, 10, 0, 10)),
              _buildHeaderCell('MVP : ${players_entries[0].key}',
                  padding: const pw.EdgeInsets.fromLTRB(0, 10, 0, 10)),
            ]
          ),
          pw.TableRow(
              decoration: pw.BoxDecoration(
                color: PdfColors.blueGrey50,
                border: pw.Border.all(color: PdfColors.grey),
              ),
              children: <pw.Widget>[
                _buildHeaderCell('Name',
                    fontSize: 13,
                    padding: const pw.EdgeInsets.fromLTRB(10, 10, 0, 10)),
                _buildHeaderCell('Total',
                    padding: const pw.EdgeInsets.fromLTRB(0, 10, 0, 10)),
              ])
        ] + players_entries.map((e) =>
            pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.green50,
                ),
                children: <pw.Widget>[
                  _buildCell(pw.Text(e.key),
                      padding: const pw.EdgeInsets.fromLTRB(10, 5, 0, 5)),
                  _buildCell(pw.Text(getTotal(e.value).toString()),
                      padding: const pw.EdgeInsets.fromLTRB(0, 5, 0, 5)),
                ])
        ).toList()));
  }

  static pw.Padding getBatter(List<Batter> batters) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(horizontal: 0.9),
      child: pw.Table(
        columnWidths: const <int, pw.TableColumnWidth>{
          0: pw.FlexColumnWidth(4),
          1: pw.FlexColumnWidth(1),
          2: pw.FlexColumnWidth(1),
          3: pw.FlexColumnWidth(1),
          4: pw.FlexColumnWidth(1),
          5: pw.FlexColumnWidth(1),
        },
        children: [
              pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blueGrey50,
                    border: pw.Border.all(color: PdfColors.grey),
                  ),
                  children: <pw.Widget>[
                    _buildHeaderCell('BATSMAN',
                        fontSize: 13,
                        padding: const pw.EdgeInsets.fromLTRB(10, 10, 0, 10)),
                    _buildHeaderCell('R',
                        padding: const pw.EdgeInsets.fromLTRB(0, 10, 0, 10)),
                    _buildHeaderCell('B',
                        padding: const pw.EdgeInsets.fromLTRB(0, 10, 0, 10)),
                    _buildHeaderCell('4s',
                        padding: const pw.EdgeInsets.fromLTRB(0, 10, 0, 10)),
                    _buildHeaderCell('6s',
                        padding: const pw.EdgeInsets.fromLTRB(0, 10, 0, 10)),
                    _buildHeaderCell('RN',
                        padding: const pw.EdgeInsets.fromLTRB(0, 10, 0, 10)),
                  ])
            ] +
            batters.map((batter) {
              return pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.green50,
                  ),
                  children: <pw.Widget>[
                    _buildCell(
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(batter.name,
                                style: const pw.TextStyle(fontSize: 13)),
                            pw.Text(batter.outBy,
                                style: const pw.TextStyle(fontSize: 11)),
                          ],
                        ),
                        padding: const pw.EdgeInsets.fromLTRB(10, 5, 0, 5)),
                    _buildCell(pw.Text(batter.runs.toString()),
                        padding: const pw.EdgeInsets.fromLTRB(0, 5, 0, 5)),
                    _buildCell(pw.Text(batter.balls.toString()),
                        padding: const pw.EdgeInsets.fromLTRB(0, 5, 0, 5)),
                    _buildCell(pw.Text(batter.fours.toString()),
                        padding: const pw.EdgeInsets.fromLTRB(0, 5, 0, 5)),
                    _buildCell(pw.Text(batter.sixes.toString()),
                        padding: const pw.EdgeInsets.fromLTRB(0, 5, 0, 5)),
                    _buildCell(
                        pw.Text(batter.strikeRate.toStringAsFixed(2),
                            style: const pw.TextStyle(fontSize: 10)),
                        padding: const pw.EdgeInsets.fromLTRB(0, 5, 0, 5)),
                  ]);
            }).toList(),
      ),
    );
  }

  static pw.Padding getBowlers(List<Bowler> bowlers) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(horizontal: 0.9),
      child: pw.Table(
        columnWidths: const <int, pw.TableColumnWidth>{
          0: pw.FlexColumnWidth(4),
          1: pw.FlexColumnWidth(1),
          2: pw.FlexColumnWidth(1),
          3: pw.FlexColumnWidth(1),
          4: pw.FlexColumnWidth(1),
          5: pw.FlexColumnWidth(1),
        },
        children: [
              pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blueGrey50,
                    border: pw.Border.all(color: PdfColors.grey),
                  ),
                  children: <pw.Widget>[
                    _buildHeaderCell('Bowler',
                        fontSize: 13,
                        padding: const pw.EdgeInsets.fromLTRB(10, 10, 0, 10)),
                    _buildHeaderCell('O',
                        padding: const pw.EdgeInsets.fromLTRB(0, 10, 0, 10)),
                    _buildHeaderCell('M',
                        padding: const pw.EdgeInsets.fromLTRB(0, 10, 0, 10)),
                    _buildHeaderCell('W',
                        padding: const pw.EdgeInsets.fromLTRB(0, 10, 0, 10)),
                    _buildHeaderCell('R',
                        padding: const pw.EdgeInsets.fromLTRB(0, 10, 0, 10)),
                    _buildHeaderCell('Eco',
                        padding: const pw.EdgeInsets.fromLTRB(0, 10, 0, 10)),
                  ])
            ] +
            bowlers.map((bowler) {
              return pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColors.green50,
                  ),
                  children: <pw.Widget>[
                    _buildCell(
                        pw.Text(bowler.name,
                            style: const pw.TextStyle(fontSize: 13)),
                        padding: const pw.EdgeInsets.fromLTRB(10, 5, 0, 5)),
                    _buildCell(pw.Text(bowler.overs.toStringAsFixed(1)),
                        padding: const pw.EdgeInsets.fromLTRB(0, 5, 0, 5)),
                    _buildCell(pw.Text(bowler.maidens.toString()),
                        padding: const pw.EdgeInsets.fromLTRB(0, 5, 0, 5)),
                    _buildCell(pw.Text(bowler.wickets.toString()),
                        padding: const pw.EdgeInsets.fromLTRB(0, 5, 0, 5)),
                    _buildCell(pw.Text(bowler.runs.toString()),
                        padding: const pw.EdgeInsets.fromLTRB(0, 5, 0, 5)),
                    _buildCell(pw.Text(bowler.economy.toStringAsFixed(2)),
                        padding: const pw.EdgeInsets.fromLTRB(0, 5, 0, 5)),
                  ]);
            }).toList(),
      ),
    );
  }

  static pw.Padding _buildCell(pw.Widget child,
      {required pw.EdgeInsets padding}) {
    return pw.Padding(
      padding: padding ?? pw.EdgeInsets.all(5),
      child: child,
    );
  }

  static pw.Padding _buildHeaderCell(String text,
      {double fontSize = 12, required pw.EdgeInsets padding}) {
    return pw.Padding(
      padding: padding ?? const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: fontSize),
      ),
    );
  }
}
