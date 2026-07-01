import '../models/product.dart';
import '../models/service.dart';
import 'local_cache_service_stub.dart'
    if (dart.library.io) 'local_cache_service_io.dart';

abstract class LocalCacheService {
  Future<void> syncServices(List<Service> services);
  Future<void> syncProducts(List<Product> products);
}

LocalCacheService createLocalCacheService() => createLocalCacheServiceImpl();
