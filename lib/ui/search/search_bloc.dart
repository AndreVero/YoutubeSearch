import 'package:bloc/bloc.dart';
import 'package:youtubesearch/data/model/search/model_search.dart';
import 'package:youtubesearch/repository/YoutubeRepository.dart';
import 'package:youtubesearch/ui/search/search.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  
  final YoutubeRepository _youtubeRepository;

  SearchBloc(this._youtubeRepository) : super();


  void onSearchInitiated(String query) {
    dispatch(SearchInitiated((b) => b..query = query));
  }

  void fetchNextResultPage() {
    dispatch(FetchNextResultPage());
  }

  @override
  SearchState get initialState => SearchState.initial();

  @override
  Stream<SearchState> mapEventToState(
    SearchState currentState, SearchEvent event,
  ) async* {
    if (event is SearchInitiated) {
     yield* mapSearchInitiated(event);
    } else if (event is FetchNextResultPage) {
      yield* mapFetchNextResultPage();
    }
  }

  Stream<SearchState> mapSearchInitiated(SearchInitiated event) async* {
     if (event.query.isEmpty) {
        yield SearchState.initial();
      } else {
        yield SearchState.loading();

        try {
          final searchResult = await _youtubeRepository.searchVideos(event.query);
          yield SearchState.success(searchResult);
        } on YoutubeSearchError catch (e) {
          yield SearchState.failure(e.message);
        } on NoSearchResultException catch (e) {
          yield SearchState.failure(e.message);
        }
      }
  }

  Stream<SearchState> mapFetchNextResultPage() async* {
    try {
        final nextPageResult = await _youtubeRepository.fetchNextResultPage();
        yield SearchState.success(currentState.searchResults + nextPageResult);
      } on NoNextPageTokenException catch (_) { 
        yield currentState.rebuild((b) => b..hasReachedEndOfResults = true);
      }
      on SearchNotInitiatedException catch (e) {
        yield SearchState.failure(e.message);
      }
      on YoutubeSearchError catch (e) {
        yield SearchState.failure(e.message);
      }
  }
}