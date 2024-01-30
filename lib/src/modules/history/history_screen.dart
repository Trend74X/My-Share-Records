import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_records/src/modules/history/history_cubit.dart';
import 'package:share_records/src/modules/history/history_state.dart';
import 'package:share_records/src/shared/widget/appbar.dart';
import 'package:share_records/src/shared/widget/custom_button.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    Widget uploadButton = IconButton(
      onPressed: () => BlocProvider.of<HistoryCubit>(context).importAndReadCsv(),
      icon: const Icon(Icons.upload_file)
    );
    return Scaffold(
      appBar: appBar(context, 'History', uploadButton),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoadedState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: bodyView(state.historyData),
              ),
            );
          }

          if (state is HistoryErrorState) {
            return Text(state.error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red)
            );
          }

          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orangeAccent,
            )
          );
        }
      )
    );
  }

  bodyView(historyData) {
    return historyData.isEmpty
      ? SizedBox(
        height: MediaQuery.of(context).size.height - 100.0,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'There is no history to display right now. \nPlease import the csv data from button below.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            CustomButton(
              text: 'Import Csv', 
              onPressed: () => BlocProvider.of<HistoryCubit>(context).importAndReadCsv()
            ),
            const SizedBox(height: 16.0),
            const Text(
              '*NOTE* \nIn case the file is not selectable for import, \nplease rename the file so that there is no space, \nor any special characters.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red
              ),
            ),
          ],
        ),
      )
      : ListView.builder(
        shrinkWrap: true,
        itemCount: historyData.length,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (BuildContext context, int index){
          return historyTitle(historyData[index]);
        }
      );
  }

  historyTitle(historyItem) {
    return ListTile(
      title: SizedBox(
        width: 70.0,
        child: Text('${historyItem.name} [${historyItem.scrip}]')
      ),
      subtitle: Row(
        children: [
          Text(historyItem.transactionDate),
          const SizedBox(width: 16.0),
          Text(
            historyItem.historyDescription.contains('ON-CR')
              ? '[Secondary Buy]'
              : historyItem.historyDescription.contains('ON-DR')
                ? '[Secondary Sell]'
                : historyItem.historyDescription.contains('CA-Rearrangement')
                  ? '[SIP]'
                  : historyItem.historyDescription.contains('INITIAL PUBLIC OFFERING')
                    ? '[IPO]'
                    : historyItem.historyDescription.contains('CA-Bonus')
                      ? '[Bonus Share]'
                      : '[Cannot get appropriate data]'
          ),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            historyItem.historyDescription.contains('ON-DR') == true 
              ? '- ${historyItem.debitQnty} shares' 
              : '+ ${historyItem.creditQnty} shares',
            style: TextStyle(
              color: historyItem.historyDescription.contains('ON-DR') == true ? Colors.red : Colors.green
            ),
          ),
          Text('Total Shares : ${historyItem.balanceAfterTransaction}')
        ],
      ),
      isThreeLine: true,
    );
  }

}