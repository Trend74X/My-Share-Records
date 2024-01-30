abstract class PortfolioState{}

class PortfolioLoadingState extends PortfolioState{}

class PortfolioLoadedState extends PortfolioState{
  final List myShareData;
  PortfolioLoadedState(this.myShareData);
}

class PortfolioErrorState extends PortfolioState{
  final String error;
  PortfolioErrorState(this.error);
}