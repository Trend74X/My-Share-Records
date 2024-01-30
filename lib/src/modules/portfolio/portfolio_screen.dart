import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_records/src/core/constants/styles.dart';
import 'package:share_records/src/modules/portfolio/portfolio_cubit.dart';
import 'package:share_records/src/modules/portfolio/portfolio_state.dart';
import 'package:share_records/src/shared/widget/appbar.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  @override
  Widget build(BuildContext context) {
    Widget refresh = TextButton.icon(
      label: const Text('Refresh', style: TextStyle(color: white)), 
      icon: const Icon(Icons.refresh, color: white),
      onPressed: () => context.read<PortfolioCubit>().refresh(),
    );
    return Scaffold(
      appBar: appBar(
        context, 
        'Portfolio',
        refresh
      ),
      body: BlocBuilder<PortfolioCubit, PortfolioState>(
        builder: (context, state) {
          if (state is PortfolioLoadedState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: bodyView(context, state.myShareData),
              ),
            );
          }

          if (state is PortfolioErrorState) {
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

  bodyView(BuildContext context, mySharesData) {
    var cubit = context.read<PortfolioCubit>();
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
      : Column(
        children: [
          isMarketOpenWidget(cubit),
          marketSummarized(cubit),
          const SizedBox(height: 8.0),
          portfolioList(cubit, mySharesData)
        ],
      );
  }

  isMarketOpenWidget(cubit) {
    Widget row = Padding(
      padding: const EdgeInsets.only(right: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            cubit.isMarketOpen == true ? 'Market Open' : 'Market Closed',
            style: tileSubtitle(),
          ),
          const SizedBox(width: 8.0),
          CircleAvatar(
            backgroundColor: cubit.isMarketOpen == true ? Colors.green : Colors.red,
            radius: 12.0,
          ),
        ]
      ),
    );
    return row;
  }

  marketSummarized(cubit) {
    // ignore: unused_local_variable
    String totalPcp = cubit.totalClosingAmount.toStringAsFixed(2);
    String totalLtp = cubit.totalLtpAmount.toStringAsFixed(2);
    Widget widget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Current Share Value', style: tileHeader()),
          Row(
            children: [
              Text('Rs. $totalLtp'),
              const Spacer(),
              getTodaysDifference(cubit, totalPcp, totalLtp)
            ],
          )
        ],
      ),
    );
    return widget;
  }

  portfolioList(cubit, mySharesData) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: mySharesData.length,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int index){
        return mySharesTile(cubit, mySharesData[index]);
      }
    );
  }

  mySharesTile(cubit, myShare) {
    return ExpansionTile(
      iconColor: Colors.white,
      textColor: Colors.white,
      title: Column(
        children: [
          Row(
            children: [
              Text(myShare.scrip, style: tileHeader()),
              const Spacer(),
              Text('Rs. ${myShare.ltpValue}', style: tileHeader()),
            ],
          ),
          Row(
            children: [
              Text("${myShare.balanceAfterTransaction} Shares,", style: tileSubtitle()),
              const SizedBox(width: 8.0),
              Text("LTP: ${myShare.ltp}", style: tileSubtitle()),
              const Spacer(),
              getTodaysDifference(cubit, myShare.pcpValue, myShare.ltpValue)
            ],
          )
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Name'),
                  Flexible(child: Text(myShare.name, textAlign: TextAlign.end))
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Scrip'),
                  Text(myShare.scrip)
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Shares'),
                  Text(myShare.balanceAfterTransaction)
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Previous Closing Price'),
                  Text(myShare.pcp)
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Value as of Previous Closing Price'),
                  Text(myShare.pcpValue)
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Last Transaction Price'),
                  Text(myShare.ltp)
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Value as of Last Transaction Price'),
                  Text(myShare.ltpValue)
                ],
              ),
              const SizedBox(height: 8.0)
            ],
          )
        )
      ],
    );
  }

  getTodaysDifference(var cubit, String pcpValue, String ltpValue) {
    bool getData = cubit.isMarketOpen || cubit.wasMarketOpenToday ? true : false;
    double difference = getData ? double.parse(pcpValue) - double.parse(ltpValue) : 0.0;
    String status = getData ? difference > 0.0 ? 'inc' : difference < 0.0 ? 'dec' : 'brk' : 'close';
    Color color = status == 'inc' ? Colors.green : status == 'dec' ? Colors.red : Colors.grey;
    Widget row = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          status == 'inc'
            ? Icons.arrow_circle_up_rounded
            : status == 'dec'
              ? Icons.arrow_circle_down_rounded
              : Icons.compare_arrows, 
          color: color,
          size: 18.0,
        ),
        const SizedBox(width: 2.0),
        Text(
          "Rs. ${difference.toStringAsFixed(2).replaceAll('-', '')}",
          style: TextStyle(
            fontSize: 14.0, 
            fontWeight: FontWeight.w500,
            color: color
          ),
        )
      ],
    );
    return row;
  }

}