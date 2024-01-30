abstract class IpoResultState{}

class IpoResultLoadingState extends IpoResultState{}

class IpoResultLoadedState extends IpoResultState{
  final List familyData;
  IpoResultLoadedState(this.familyData);
}

class IpoResultErrorState extends IpoResultState{
  final String error;
  IpoResultErrorState(this.error);
}

class IpoResultImportClickState extends IpoResultState{}

class IpoResultImportingState extends IpoResultState{}

class IpoResultImportedState extends IpoResultState{}