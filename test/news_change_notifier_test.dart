import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing/article.dart';
import 'package:flutter_testing/news_change_notifier.dart';
import 'package:flutter_testing/news_service.dart';
import 'package:mocktail/mocktail.dart';


class MockNewsService extends Mock implements NewsService{}

void main(){
  late MockNewsService mockNewsService;
  late NewsChangeNotifier sut;

  setUp(() {
    mockNewsService = MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);
  });

  test(
      "initial values are correct",
          () {
        expect(sut.articles, []);
        expect(sut.isLoading, false);
      }
  );

  group("getArticles", () {
    final articlesFromService = [
      Article(title: 'Test 1', content: 'Test 1 content'),
      Article(title: 'Test 2', content: 'Test 2 content'),
      Article(title: 'Test 3', content: 'Test 3 content'),
    ];
    void arrangeNewsServiceReturns3Articles(){
      when(() => mockNewsService.getArticles()).thenAnswer(
            (_) async    => articlesFromService,
      );
    }

    test("gets Articles using the NewsService", ()async{
      arrangeNewsServiceReturns3Articles();
      await sut.getArticles();
      verify(() =>mockNewsService.getArticles()).called(1);
    });

    test(
        """
        indicates loading of data,
        sets articles to the ones from the service,
        indicates thst data is not been loaded anymore
        """, () async{
      arrangeNewsServiceReturns3Articles();
      final future  = sut.getArticles();
      expect(sut.isLoading, true);
      await future;
      expect(sut.articles, articlesFromService );
      expect(sut.isLoading, false);
    });
  });
 }


// //************ Basic snipet Scaffold for testing *********
//  import 'package:flutter_test/flutter_test.dart';
//
//  void main(){
//   late ClassName sut;
//
//   setUp(() {
//     sut = ClassName();
//   });
//
//   group('', () { })
//  }


