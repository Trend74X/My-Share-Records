abstract class HistoryState{}

class HistoryLoadingState extends HistoryState{}

class HistoryLoadedState extends HistoryState{
  final List historyData;
  HistoryLoadedState(this.historyData);
}

class HistoryErrorState extends HistoryState{
  final String error;
  HistoryErrorState(this.error);
}

class HistoryImportClickState extends HistoryState{}

class HistoryImportingState extends HistoryState{}

class HistoryImportedState extends HistoryState{}