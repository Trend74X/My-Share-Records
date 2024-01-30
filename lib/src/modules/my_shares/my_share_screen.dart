import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_records/src/modules/my_shares/my_share_cubit.dart';
import 'package:share_records/src/modules/my_shares/my_share_state.dart';
import 'package:share_records/src/shared/widget/appbar.dart';

class MySharesScreen extends StatefulWidget {
  const MySharesScreen({super.key});

  @override
  State<MySharesScreen> createState() => _MySharesScreenState();
}

class _MySharesScreenState extends State<MySharesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context, 
        'My Shares',
      ),
      body: BlocBuilder<MySharesCubit, MyShareState>(
        builder: (context, state) {
          if (state is MyShareLoadedState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: bodyView(state.myShareData),
              ),
            );
          }

          if (state is MyShareErrorState) {
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

  bodyView(mySharesData) {
    return mySharesData.isEmpty
      ? SizedBox(
        height: MediaQuery.of(context).size.height - 100.0,
        width: double.infinity,
        child: const Center(
          child: Text(
            'There is no data to display right now. \nPlease import the csv data in history section.',
            textAlign: TextAlign.center,
          ),
        ),
      )
      : ListView.builder(
        shrinkWrap: true,
        itemCount: mySharesData.length,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (BuildContext context, int index){
          return mySharesTile(mySharesData[index]);
        }
      );
  }

  mySharesTile(myShare) {
    return ListTile(
      title: Text("[${myShare.scrip}]   ${myShare.name}"),
      subtitle: Row(
        children: [
          Text('Total Shares : ${myShare.balanceAfterTransaction}'),
          const SizedBox(width: 16.0),
        ],
      ),
    );
  }

}