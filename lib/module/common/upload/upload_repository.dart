import 'package:dio/dio.dart';
import 'package:pollution_source/http/http_api.dart';
import 'package:pollution_source/util/compat_utils.dart';

/// 所有上报界面存储库的基类
///
/// 在[upload]方法中已经实现了网络请求相关业务
/// 子类只需规定泛型和重写[createApi]，[checkData]，[createFormData]三个抽象方法即可
/// [checkData]检查某些必须用户输入的参数是否为空
/// [createFormData]用来根据实体类创建对应的表单数据
/// 泛型[T]为[upload]方法传入的实体类类型，泛型[V]为返回的数据类型
abstract class UploadRepository<T, V> {
  Future<V> upload({T data, CancelToken cancelToken}) async {
    checkData(data);
    Response response = await CompatUtils.getDio().post(
        CompatUtils.getApi(createApi()),
        cancelToken: cancelToken,
        data: await createFormData(data));
    return CompatUtils.getResponseMessage(response);
  }

  HttpApi createApi();

  checkData(T data);

  Future<FormData> createFormData(T data);
}
