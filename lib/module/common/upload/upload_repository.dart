abstract class UploadRepository<T, V> {
  Future<V> upload(T data);
}
