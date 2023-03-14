import 'package:sheet_demo/pages/state_management/state_management_page/provider_api_pages/provider_api.dart';
import 'package:sheet_demo/pages/state_management/state_management_page/provider_api_pages/provider_api_page_demo.dart';
import 'package:sheet_demo/pages/state_management/state_management_page/provider_api_pages/provider_response.dart';

class ProviderViewModel {
  ProviderApiDemoState providerApiDemoState;
  List<ProviderResponse> providerData;
  ProviderViewModel(this.providerApiDemoState) {
    providerApi();
  }
  providerApi() async {
    List<ProviderResponse> data = await ProviderPageApi().providerApi();
    if (data != null) {
      print('Data --> ${data.length}');
      providerData = data;
      // ignore: invalid_use_of_protected_member
      providerApiDemoState.setState(() {});
    } else {
      print('Data null');
    }
  }
}
