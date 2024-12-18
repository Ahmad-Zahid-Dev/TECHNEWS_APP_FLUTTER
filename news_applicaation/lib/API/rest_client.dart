import 'package:dio/dio.dart';
import 'package:news_applicaation/MODALS/Getnewslistmodal.dart';
import 'package:retrofit/retrofit.dart';
part 'rest_client.g.dart';

// flutter pub run build_runner build

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio,{String baseUrl}) = _RestClient;

// It is a DUMMY API

  @GET('https://newsapi.org/v2/everything?q=technology&apiKey=d51716e83d75487bb066ff1b1144152f')
  Future<GetNewsListModal> getlistapimethod();
}