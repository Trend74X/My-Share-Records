abstract class AppDataState{}

class AppDataLoadingState extends AppDataState{}

class AppDataLoadedState extends AppDataState{}

class AppDataErrorState extends AppDataState{
  final String error;
  AppDataErrorState(this.error);
}

class CompanyListLoadedState extends AppDataState{
  final List companyListData;
  CompanyListLoadedState(this.companyListData);
}

class CompanyListErrorState extends AppDataState{
  final String error;
  CompanyListErrorState(this.error);
}