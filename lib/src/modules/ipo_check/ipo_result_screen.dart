import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_records/src/modules/ipo_check/ipo_result_cubit.dart';
import 'package:share_records/src/modules/ipo_check/ipo_result_state.dart';
import 'package:share_records/src/shared/widget/appbar.dart';

class IpoResultScreen extends StatefulWidget {
  const IpoResultScreen({super.key});

  @override
  State<IpoResultScreen> createState() => _IpoResultScreenState();
}

class _IpoResultScreenState extends State<IpoResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context, 
        'Ipo Result',
        IconButton(
          onPressed: () {}, // => BlocProvider.of<HistoryCubit>(context).importAndReadCsv(),
          icon: const Icon(Icons.person_add)
        )
      ),
      body: BlocBuilder<IpoResultCubit, IpoResultState>(
        builder: (context, state) {
          if (state is IpoResultLoadedState) {
            return const SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('asdb') //odyView(state.IpoResultData),
              ),
            );
          }

          if (state is IpoResultErrorState) {
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

  // bodyView(historyData) {
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     itemCount: historyData.length,
  //     physics: const ClampingScrollPhysics(),
  //     itemBuilder: (BuildContext context, int index){
  //       return historyTitle(historyData[index]);
  //     }
  //   );
  // }

  // historyTitle(historyItem) {
  //   return ListTile(
  //     title: SizedBox(
  //       width: 70.0,
  //       child: Text(historyItem.scrip)
  //     ),
  //     subtitle: Row(
  //       children: [
  //         Text(historyItem.transactionDate),
  //         const SizedBox(width: 16.0),
  //         Text(
  //           historyItem.historyDescription.contains('ON-CR')
  //             ? '[Secondary Buy]'
  //             : historyItem.historyDescription.contains('ON-DR')
  //               ? '[Secondary Sell]'
  //               : historyItem.historyDescription.contains('CA-Rearrangement')
  //                 ? '[SIP]'
  //                 : historyItem.historyDescription.contains('INITIAL PUBLIC OFFERING')
  //                   ? '[IPO]'
  //                   : historyItem.historyDescription.contains('CA-Bonus')
  //                     ? '[Bonus Share]'
  //                     : '[Cannot get appropriate data]'
  //         ),
  //       ],
  //     ),
  //     trailing: Column(
  //       crossAxisAlignment: CrossAxisAlignment.end,
  //       children: [
  //         Text(
  //           historyItem.historyDescription.contains('ON-DR') == true 
  //             ? '- ${historyItem.debitQnty} shares' 
  //             : '+ ${historyItem.creditQnty} shares',
  //           style: TextStyle(
  //             color: historyItem.historyDescription.contains('ON-DR') == true ? Colors.red : Colors.green
  //           ),
  //         ),
  //         Text('Total Shares : ${historyItem.balanceAfterTransaction}')
  //       ],
  //     ),
  //     isThreeLine: true,
  //   );
  // }

}