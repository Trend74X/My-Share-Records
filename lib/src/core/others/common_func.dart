import 'package:html/parser.dart' as htmlparser;
import 'package:intl/intl.dart';

class CommonFunction {

  // Add comma at the end of the row to indicate a column change
  String addCommaAtEndOfRow(String csvString) {
    // Split the CSV string into rows
    List<String> rows = csvString.split('\n');

    // Add a comma at the end of each row
    for (int i = 0; i < rows.length; i++) {
      if (i < rows.length - 1) {
        // Add a comma if it's not the last row
        rows[i] = '${rows[i]},';
      }
    }

    // Join the modified rows back into a CSV string
    String modifiedCsvString = rows.join('\n');

    return modifiedCsvString;
  }

  List<List<dynamic>> breakIntoSeven(rowsAsListOfValues) {
    // Ignore the first seven elements
    List<dynamic> remainingData = rowsAsListOfValues[0].sublist(7);

    // Break the remaining elements into lists of 7
    List<List<dynamic>> resultList = [];
    for (int i = 0; i < remainingData.length - 1; i += 7) {
      resultList.add(remainingData.sublist(i, i + 7));
    }
    return resultList;
  }

  List<String> getOptionsFromHtml(String htmlContent) {
    List<String> options = [];

    // Parse the HTML content
    var document = htmlparser.parse(htmlContent);

    // Find the select element by its ID or class or any other attribute
    var selectElement = document.querySelector('select#singlee');

    // Check if the select element is found
    if (selectElement != null) {
      // Iterate through the option elements and extract their text
      selectElement.querySelectorAll('option').forEach((optionElement) {
        options.add(optionElement.text.trim());
      });
    }

    return options;
  }

  bool isMarketOpenNow(String dateToCheck) {
    DateTime apiDate = DateFormat("yyyy/MM/dd HH:mm:ss").parse(dateToCheck);
    DateTime today = DateTime.now();
    bool isToday = apiDate.year == today.year && apiDate.month == today.month && apiDate.day == today.day;
    bool marketOpen = isToday ? today.isBefore(DateTime(today.year, today.month, today.day, 15, 0, 0)) : false;
    return marketOpen;
  }

  bool wasMarketOpenToday(String dateToCheck) {
    DateTime apiDate = DateFormat("yyyy/MM/dd HH:mm:ss").parse(dateToCheck);
    DateTime today = DateTime.now();
    bool isToday = apiDate.year == today.year && apiDate.month == today.month && apiDate.day == today.day;
    return isToday;
  }

}