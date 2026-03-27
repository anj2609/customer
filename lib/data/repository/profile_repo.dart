

import 'package:evfual/config/utils/constants.dart';
import 'package:get/get.dart';
import 'package:evfual/config/utils/apis/api_client.dart';

class ProfiileRepo extends GetxService {
  final ApiClient apiClient;

  ProfiileRepo({required this.apiClient});
   Future<Response> profileRepoApi() async {
  
    return apiClient.getDataApi(ApiConstants.getUserProfileUrl
    
    );
  }
}
