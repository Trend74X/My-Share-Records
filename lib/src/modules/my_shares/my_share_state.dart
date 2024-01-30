abstract class MyShareState{}

class MyShareLoadingState extends MyShareState{}

class MyShareLoadedState extends MyShareState{
  final List myShareData;
  MyShareLoadedState(this.myShareData);
}

class MyShareErrorState extends MyShareState{
  final String error;
  MyShareErrorState(this.error);
}