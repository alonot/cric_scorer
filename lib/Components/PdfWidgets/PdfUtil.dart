
import 'package:cric_scorer/models/Batter.dart';
import 'package:cric_scorer/models/Bowler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
class PdfUtil {

  static final List<pw.TableRow> _batterHeader = [
    pw.TableRow(
        decoration: pw.BoxDecoration(
          color: PdfColors.blueGrey50,
          border: pw.Border.all(color: PdfColors.grey),
        ),
        children: <pw.Widget>[
          pw.Padding(
            padding: pw.EdgeInsets.fromLTRB(10, 10.0, 0, 10.0),
            child: pw.Text(
              'BATSMAN',
              style: pw.TextStyle(fontSize: 13),
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: pw.Text(
              'R',
              style: pw.TextStyle(),
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: pw.Text(
              'B',
              style: pw.TextStyle(),
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: pw.Text(
              '4s',
              style: pw.TextStyle(),
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: pw.Text(
              '6s',
              style: pw.TextStyle(),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: pw.Text(
              'RN',
              style: const pw.TextStyle(),
            ),
          ),
        ])
  ];

  static final List<pw.TableRow> _bowlerHeader = [
    pw.TableRow(
        decoration: pw.BoxDecoration(
          color: PdfColors.blueGrey50,
          border: pw.Border.all(color: PdfColors.grey),
        ),
        children: <pw.Widget>[
          pw.Padding(
            padding: const pw.EdgeInsets.fromLTRB(10, 10.0, 0, 10.0),
            child: pw.Text(
              'Bowler',
              style: pw.TextStyle(fontSize: 13),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: pw.Text(
              'O',
              style: pw.TextStyle(),
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: pw.Text(
              'M',
              style: pw.TextStyle(),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: pw.Text(
              'W',
              style: pw.TextStyle(),
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: pw.Text(
              'R',
              style: pw.TextStyle(),
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: pw.Text(
              'Eco',
              style: pw.TextStyle(),
            ),
          ),
        ])
  ];


  static pw.Padding getBatter(List<Batter> batters){
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
          }, children: _batterHeader +
          batters.map((batter) {
            return pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.green50,
                ),
                children: <pw.Widget>[
                  pw.Padding(
                    padding: const pw.EdgeInsets.fromLTRB(10, 5.0, 0, 5.0),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          batter.name,
                          style: const pw.TextStyle(fontSize: 13),
                        ),
                        pw.Text(
                          batter.outBy,
                          style: const pw.TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: pw.Text(
                      batter.runs.toString(),
                      style: const pw.TextStyle(),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: pw.Text(
                      batter.balls.toString(),
                      style: const pw.TextStyle(),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: pw.Text(
                      batter.fours.toString(),
                      style: const pw.TextStyle(),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: pw.Text(
                      batter.sixes.toString(),
                      style: const pw.TextStyle(),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: pw.Text(
                      batter.strikeRate.toStringAsFixed(2),
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                ]);
          }).toList())
    );
  }


  static pw.Padding getBowlers(List<Bowler> bowlers){
    return pw.Padding(
      child: pw.Table(
          columnWidths: const <int, pw.TableColumnWidth>{
            0: pw.FlexColumnWidth(4),
            1: pw.FlexColumnWidth(1),
            2: pw.FlexColumnWidth(1),
            3: pw.FlexColumnWidth(1),
            4: pw.FlexColumnWidth(1),
            5: pw.FlexColumnWidth(1),
          },
          children: _bowlerHeader +
              bowlers
                  .map((bowler) => pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColors.green50,
                  ),
                  children: <pw.Widget>[
                    pw.Padding(
                      padding: const pw
                          .EdgeInsets.fromLTRB(
                          10, 5.0, 0, 5.0),
                      child: pw.Text(
                        bowler.name,
                        style: const pw.TextStyle(
                            fontSize: 13),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw
                          .EdgeInsets.fromLTRB(
                          0, 5, 0, 5),
                      child: pw.Text(
                        bowler.overs
                            .toStringAsFixed(1),
                        style: const pw.TextStyle(),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw
                          .EdgeInsets.fromLTRB(
                          0, 5, 0, 5),
                      child: pw.Text(
                        bowler.maidens.toString(),
                        style: const pw.TextStyle(),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw
                          .EdgeInsets.fromLTRB(
                          0, 5, 0, 5),
                      child: pw.Text(
                        bowler.wickets.toString(),
                        style: const pw.TextStyle(),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw
                          .EdgeInsets.fromLTRB(
                          0, 5, 0, 5),
                      child: pw.Text(
                        bowler.runs.toString(),
                        style: const pw.TextStyle(),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw
                          .EdgeInsets.fromLTRB(
                          0, 5, 0, 5),
                      child: pw.Text(
                        bowler.economy
                            .toStringAsFixed(2),
                        style: const pw.TextStyle(),
                      ),
                    ),
                  ]))
                  .toList()),
      padding: pw.EdgeInsets.symmetric(horizontal: 0.9)
    );
  }



}
