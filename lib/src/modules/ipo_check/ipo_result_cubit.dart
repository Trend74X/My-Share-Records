import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_records/src/modules/ipo_check/ipo_result_state.dart';

class IpoResultCubit extends Cubit<IpoResultState> {

  IpoResultCubit() : super(IpoResultLoadingState()) {
    // getNecessaryData();
  }

  getNecessaryData() async {
    await getStocksDropdown();
  }

  // not working
  getStocksDropdown() async {
  //   var headers = {
  //     'Accept': 'application/json, text/plain, */*',
  //     'Accept-Encoding': 'gzip, deflate, br',
  //     'Accept-Language': 'en-US,en;q=0.9',
  //     'Referer': 'https://iporesult.cdsc.com.np/',
  //     'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36' 
  //   };

  //   Dio dioReq = Dio();
  //   dioReq.options.headers = headers;
  //   try {
  //     // final dioReq = Dio(
  //     //   BaseOptions(
  //     //     headers: headers,
  //     //     receiveDataWhenStatusError: true
  //     //   )
  //     // );
  //     // var response = await dioReq.get('https://iporesult.cdsc.com.np/result/companyShares/fileUploaded');
  //     // Response response = await dioReq.get('https://iporesult.cdsc.com.np/result/companyShares/fileUploaded');

  //     // if (response.statusCode! >= 200 && response.statusCode! < 300) {
  //     //   print(response.data);
  //     // } else {
  //     //   print(response.statusMessage);
  //     // }
  //     // print(response);
  //     // print('response');
  //   } catch(e, stackTrace) {
  //     emit(IpoResultErrorState(e.toString()));
  //     log('Failed to get stocks dropdown: $e\n$stackTrace');
  //   }
  }

}