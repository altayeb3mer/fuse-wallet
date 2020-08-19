import 'package:straitsx/models/community/community.dart';
import 'package:straitsx/models/jobs/base.dart';
import 'package:straitsx/models/transactions/transaction.dart';
import 'package:straitsx/models/transactions/transactions.dart';
import 'package:straitsx/models/transactions/transfer.dart';
import 'package:straitsx/redux/actions/cash_wallet_actions.dart';
import 'package:straitsx/redux/actions/user_actions.dart';
import 'package:straitsx/models/cash_wallet_state.dart';
import 'package:redux/redux.dart';

final cashWalletReducers = combineReducers<CashWalletState>([
  TypedReducer<CashWalletState, SetDefaultCommunity>(_setDefaultCommunity),
  TypedReducer<CashWalletState, InitWeb3Success>(_initWeb3Success),
  TypedReducer<CashWalletState, GetTokenBalanceSuccess>(
      _getTokenBalanceSuccess),
  TypedReducer<CashWalletState, FetchCommunityMetadataSuccess>(
      _fetchCommunityMetadataSuccess),
  TypedReducer<CashWalletState, AlreadyJoinedCommunity>(
      _alreadyJoinedCommunity),
  TypedReducer<CashWalletState, SwitchCommunitySuccess>(
      _switchCommunitySuccess),
  TypedReducer<CashWalletState, SwitchCommunityFailed>(_switchCommunityFailed),
  TypedReducer<CashWalletState, GetBusinessListSuccess>(
      _getBusinessListSuccess),
  TypedReducer<CashWalletState, GetTokenTransfersListSuccess>(
      _getTokenTransfersListSuccess),
  TypedReducer<CashWalletState, SwitchCommunityRequested>(
      _switchCommunityRequest),
  TypedReducer<CashWalletState, SwitchToNewCommunity>(_switchToNewCommunity),
  TypedReducer<CashWalletState, BranchListening>(_branchListening),
  TypedReducer<CashWalletState, BranchListeningStopped>(
      _branchListeningStopped),
  TypedReducer<CashWalletState, BranchDataReceived>(_branchDataReceived),
  TypedReducer<CashWalletState, BranchCommunityUpdate>(_branchCommunityUpdate),
  TypedReducer<CashWalletState, BranchCommunityToUpdate>(
      _branchCommunityToUpdate),
  TypedReducer<CashWalletState, SetIsTransfersFetching>(
      _setIsTransfersFetching),
  TypedReducer<CashWalletState, InviteSendSuccess>(_inviteSendSuccess),
  TypedReducer<CashWalletState, CreateLocalAccountSuccess>(
      _createNewWalletSuccess),
  TypedReducer<CashWalletState, ReplaceTransaction>(_replaceTransfer),
  TypedReducer<CashWalletState, AddTransaction>(_addTransaction),
  TypedReducer<CashWalletState, StartFetchingBusinessList>(
      _startFetchingBusinessList),
  TypedReducer<CashWalletState, FetchingBusinessListSuccess>(
      _fetchingBusinessListSuccess),
  TypedReducer<CashWalletState, FetchingBusinessListFailed>(
      _fetchingBusinessListFailed),
  TypedReducer<CashWalletState, AddJob>(_addJob),
  TypedReducer<CashWalletState, JobDone>(_jobDone),
  TypedReducer<CashWalletState, SetIsJobProcessing>(_jobProcessingStarted)
]);

CashWalletState _fetchCommunityMetadataSuccess(
    CashWalletState state, FetchCommunityMetadataSuccess action) {
  Community current = state.communities[action.communityAddress] ??
      Community.initial().copyWith(address: action.communityAddress);
  Community newCommunity = current?.copyWith(metadata: action.metadata);
  Map<String, Community> newOne =
      Map<String, Community>.from(state.communities);
  newOne[action.communityAddress] = newCommunity;
  return state.copyWith(communities: newOne);
}

CashWalletState _setDefaultCommunity(
    CashWalletState state, SetDefaultCommunity action) {
  Community current = new Community.initial();
  Community defaultCom = current.copyWith(address: action.defaultCommunity);
  Map<String, Community> newOne =
      Map<String, Community>.from(state.communities);
  newOne[action.defaultCommunity] = defaultCom;
  return state.copyWith(
      communityAddress: action.defaultCommunity, communities: newOne);
}

CashWalletState _initWeb3Success(
    CashWalletState state, InitWeb3Success action) {
  return state.copyWith(web3: action.web3);
}

CashWalletState _getTokenBalanceSuccess(
    CashWalletState state, GetTokenBalanceSuccess action) {
  final String communityAddress = action.communityAddress;
  Community current = state.communities[communityAddress];
  Community newCommunity = current.copyWith(
      token: current.token.copyWith(amount: action.tokenBalance));
  Map<String, Community> newOne =
      Map<String, Community>.from(state.communities);
  newOne[communityAddress] = newCommunity;
  return state.copyWith(communities: newOne);
}

CashWalletState _alreadyJoinedCommunity(
    CashWalletState state, AlreadyJoinedCommunity action) {
  String communityAddress = action.communityAddress.toLowerCase();
  Community current = state.communities[communityAddress] ??
      Community.initial().copyWith(address: communityAddress);
  if (state.communities.containsKey(communityAddress) && !current.isMember) {
    Community newCommunity = current?.copyWith(isMember: true);
    Map<String, Community> newOne =
        Map<String, Community>.from(state.communities);
    newOne[communityAddress] = newCommunity;
    return state.copyWith(communities: newOne);
  } else {
    return state;
  }
}

CashWalletState _switchCommunitySuccess(
    CashWalletState state, SwitchCommunitySuccess action) {
  String communityAddress = action.communityAddress.toLowerCase();
  Community current = state.communities[communityAddress] ??
      Community.initial().copyWith(address: communityAddress);
  Community newCommunity = current?.copyWith(
      metadata: action.metadata,
      plugins: action.plugins,
      token: action.token,
      name: action.communityName,
      isClosed: action.isClosed,
      homeBridgeAddress: action.homeBridgeAddress,
      foreignBridgeAddress: action.foreignBridgeAddress,
      webUrl: action.webUrl);
  Map<String, Community> newOne =
      Map<String, Community>.from(state.communities);
  newOne[communityAddress] = newCommunity;
  return state.copyWith(
      isCommunityLoading: false,
      isCommunityFetched: true,
      communities: newOne,
      communityAddress: communityAddress);
}

CashWalletState _switchCommunityFailed(
    CashWalletState state, SwitchCommunityFailed action) {
  Map<String, Community> newOne = Map<String, Community>.from(
      state.communities..remove(action.communityAddress.toLowerCase()));
  return state.copyWith(isCommunityLoading: false, communities: newOne);
}

CashWalletState _startFetchingBusinessList(
    CashWalletState state, StartFetchingBusinessList action) {
  return state.copyWith(isCommunityBusinessesFetched: true);
}

CashWalletState _getBusinessListSuccess(
    CashWalletState state, GetBusinessListSuccess action) {
  final String communityAddress = action.communityAddress;
  Community current = state.communities[communityAddress] ??
      Community.initial().copyWith(address: action.communityAddress);
  Community newCommunity = current?.copyWith(businesses: action?.businessList);
  Map<String, Community> newOne =
      Map<String, Community>.from(state.communities);
  newOne[communityAddress] = newCommunity;
  return state.copyWith(communities: newOne);
}

CashWalletState _fetchingBusinessListSuccess(
    CashWalletState state, FetchingBusinessListSuccess action) {
  return state.copyWith(isCommunityBusinessesFetched: false);
}

CashWalletState _fetchingBusinessListFailed(
    CashWalletState state, FetchingBusinessListFailed action) {
  return state.copyWith(isCommunityBusinessesFetched: false);
}

CashWalletState _getTokenTransfersListSuccess(
    CashWalletState state, GetTokenTransfersListSuccess action) {
  final String communityAddress = action.communityAddress;
  if (action.tokenTransfers.length > 0) {
    dynamic maxBlockNumber = action.tokenTransfers.fold<int>(
            0, (max, e) => e.blockNumber > max ? e.blockNumber : max) +
        1;
    Community current = state.communities[communityAddress];
    for (Transfer tx in action.tokenTransfers.reversed) {
      Transfer saved = current.token.transactions.list
          .firstWhere((t) => t.txHash == tx.txHash, orElse: () => null);
      if (saved != null) {
        if (saved.isPending()) {
          saved = saved.copyWith(status: 'CONFIRMED');
        }
      } else {
        current.token.transactions.list.add(tx);
      }
    }
    Community newCommunity = current.copyWith(
        token: current.token.copyWith(
            transactions: current.token.transactions.copyWith(
                list: current.token.transactions.list,
                blockNumber: maxBlockNumber)));
    Map<String, Community> newOne =
        Map<String, Community>.from(state.communities);
    newOne[communityAddress] = newCommunity;
    return state.copyWith(communities: newOne);
  } else {
    return state;
  }
}

CashWalletState _switchCommunityRequest(
    CashWalletState state, SwitchCommunityRequested action) {
  return state.copyWith(
      isCommunityLoading: true,
      communityAddress: action.communityAddress.toLowerCase(),
      branchAddress: "");
}

CashWalletState _switchToNewCommunity(
    CashWalletState state, SwitchToNewCommunity action) {
  String communityAddress = action.communityAddress.toLowerCase();
  Community newCommunity =
      new Community.initial().copyWith(address: communityAddress);
  Map<String, Community> newOne =
      Map<String, Community>.from(state.communities);
  newOne[communityAddress] = newCommunity;
  return state.copyWith(
      branchAddress: "", isCommunityLoading: true, communities: newOne);
}

CashWalletState _branchCommunityUpdate(
    CashWalletState state, BranchCommunityUpdate action) {
  return state.copyWith(
      isCommunityLoading: false,
      isCommunityFetched: false,
      branchAddress: "",
      communityAddress: state.branchAddress);
}

CashWalletState _branchCommunityToUpdate(
    CashWalletState state, BranchCommunityToUpdate action) {
  return state.copyWith(branchAddress: action.communityAddress);
}

CashWalletState _branchListening(
    CashWalletState state, BranchListening action) {
  return state.copyWith(isListeningToBranch: true);
}

CashWalletState _branchListeningStopped(
    CashWalletState state, BranchListeningStopped action) {
  return state.copyWith(isListeningToBranch: false);
}

CashWalletState _branchDataReceived(
    CashWalletState state, BranchDataReceived action) {
  return state.copyWith(isBranchDataReceived: true);
}

CashWalletState _setIsTransfersFetching(
    CashWalletState state, SetIsTransfersFetching action) {
  return state.copyWith(isTransfersFetchingStarted: action.isFetching);
}

CashWalletState _addTransaction(CashWalletState state, AddTransaction action) {
  final String communityAddress = action.communityAddress;
  Community current = state.communities[communityAddress] ??
      Community.initial().copyWith(address: communityAddress);

  Transaction saved = current?.token?.transactions?.list?.firstWhere(
      (tx) => tx.jobId != null && tx.jobId == action.transaction.jobId,
      orElse: () => null);
  Transactions transactions;
  if (saved == null) {
    transactions = current?.token?.transactions?.copyWith(
        list: current.token.transactions.list..add(action.transaction));
  } else {
    if (action.transaction.isPending()) {
      return state;
    }
    int index = current.token.transactions.list.indexOf(saved);
    transactions = current.token.transactions.copyWith();
    transactions.list[index] = action.transaction;
  }
  Community newCommunity = current?.copyWith(
      token: current?.token?.copyWith(transactions: transactions));
  Map<String, Community> newOne =
      Map<String, Community>.from(state.communities);
  newOne[communityAddress] = newCommunity;
  return state.copyWith(communities: newOne);
}

CashWalletState _inviteSendSuccess(
    CashWalletState state, InviteSendSuccess action) {
  Community current = state.communities[action.communityAddress];
  dynamic invites = Map.from(current.token.transactions.invites);
  invites[action.invite.jobId] = action.invite;
  Community newCommunity = current.copyWith(
      token: current.token.copyWith(
          transactions: current.token.transactions.copyWith(
              invites: invites,
              list: List.from(current.token.transactions.list)
                ..add(action.invite))));
  Map<String, Community> newOne =
      Map<String, Community>.from(state.communities);
  newOne[action.communityAddress] = newCommunity;
  return state.copyWith(communities: newOne);
}

CashWalletState _createNewWalletSuccess(
    CashWalletState state, CreateLocalAccountSuccess action) {
  return CashWalletState.initial()
      .copyWith(isBranchDataReceived: state.isBranchDataReceived);
}

CashWalletState _replaceTransfer(
    CashWalletState state, ReplaceTransaction action) {
  final String communityAddress = action.communityAddress;
  Community current = state.communities[communityAddress];
  List<Transaction> oldTxs = List<Transaction>.from(
      current.token.transactions.list.where((tx) =>
          (tx.jobId != null && tx.jobId == action.transaction.jobId) ||
          (tx.txHash != null && tx.txHash == action.transaction.txHash) ||
          (tx.jobId != null && tx.jobId == action.transactionToReplace.jobId) ||
          (tx.txHash != null &&
              tx.txHash == action.transactionToReplace.txHash)));
  if (oldTxs.isEmpty) {
    return state;
  }
  int index = current.token.transactions.list.indexOf(oldTxs[0]);
  current.token.transactions.list[index] = action.transactionToReplace;
  oldTxs.removeAt(0);
  current.token.transactions.list.removeWhere((tx) => oldTxs.contains(tx));
  Community newCommunity = current.copyWith(
      token: current.token.copyWith(
          transactions: current.token.transactions
              .copyWith(list: current.token.transactions.list)));
  Map<String, Community> newOne =
      Map<String, Community>.from(state.communities);
  newOne[communityAddress] = newCommunity;
  return state.copyWith(communities: newOne);
}

CashWalletState _addJob(CashWalletState state, AddJob action) {
  final String communityAddress = action.communityAddress;
  Community current = state.communities[communityAddress];
  Community newCommunity = current.copyWith(
      token: current.token.copyWith(
          jobs: List<Job>.from(current.token.jobs ?? [])..add(action.job)));
  Map<String, Community> newOne =
      Map<String, Community>.from(state.communities);
  newOne[communityAddress] = newCommunity;
  return state.copyWith(communities: newOne);
}

CashWalletState _jobDone(CashWalletState state, JobDone action) {
  final String communityAddress = action.communityAddress;
  Community current = state.communities[communityAddress];
  Community newCommunity = current.copyWith(
      token: current.token.copyWith(
          jobs: List<Job>.from(current.token.jobs ?? [])..remove(action.job)));
  Map<String, Community> newOne =
      Map<String, Community>.from(state.communities);
  newOne[communityAddress] = newCommunity;
  return state.copyWith(communities: newOne);
}

CashWalletState _jobProcessingStarted(
    CashWalletState state, SetIsJobProcessing action) {
  return state.copyWith(isJobProcessingStarted: action.isFetching);
}
