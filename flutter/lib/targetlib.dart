
import 'targetlib_platform_interface.dart';
export 'src/generated/api/TargetLib/targetlib.pb.dart';
export 'src/generated/api/TargetLib/targetlib.pbgrpc.dart';
export 'src/runtime/target_lib_service_manager.dart';
export 'src/runtime/target_lib_connection.dart';
export 'src/runtime/target_lib_runtime.dart';
export 'src/runtime/target_lib_service_controller.dart';
export 'src/targetlib_logger.dart';

class Targetlib {
  Future<String?> getPlatformVersion() {
    return TargetlibPlatform.instance.getPlatformVersion();
  }
}
