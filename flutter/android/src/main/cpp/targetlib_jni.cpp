#include <jni.h>

#include <cstdint>
extern "C" {
typedef uint64_t targetlib_handle;
struct targetlib_init_options {
  const char* base_path;
  const char* working_path;
  const char* temp_path;
  const char* locale;
  int32_t log_max_lines;
  bool debug;
  bool oom_killer_enabled;
  bool oom_killer_disabled;
  int64_t oom_memory_limit;
};

int32_t targetlib_init(const targetlib_init_options*, char**);
int32_t targetlib_start(const char*, targetlib_handle*, char**);
int32_t targetlib_serve(targetlib_handle*, char**);
int32_t targetlib_set_tun_fd(int32_t);
int32_t targetlib_stop(targetlib_handle, char**);
int32_t targetlib_free_handle(targetlib_handle);
void targetlib_free_string(char*);
}

namespace {
void check(JNIEnv* env, int32_t status, char* error) {
  if (status == 0) return;
  const char* message = error == nullptr ? "TargetLib JNI call failed" : error;
  env->ThrowNew(env->FindClass("java/lang/IllegalStateException"), message);
  if (error != nullptr) targetlib_free_string(error);
}
}  // namespace

extern "C" JNIEXPORT void JNICALL
Java_top_loafman_targetlib_TargetlibNative_init(
    JNIEnv* env, jclass, jstring base_path, jstring working_path,
    jstring temp_path, jstring locale, jint log_max_lines, jboolean debug,
    jboolean oom_killer_enabled, jboolean oom_killer_disabled) {
  const char* base = env->GetStringUTFChars(base_path, nullptr);
  const char* working = env->GetStringUTFChars(working_path, nullptr);
  const char* temp = env->GetStringUTFChars(temp_path, nullptr);
  const char* language = env->GetStringUTFChars(locale, nullptr);
  targetlib_init_options options{
      base,
      working,
      temp,
      language,
      log_max_lines,
      static_cast<bool>(debug),
      static_cast<bool>(oom_killer_enabled),
      static_cast<bool>(oom_killer_disabled),
      0};
  char* error = nullptr;
  const int32_t status = targetlib_init(&options, &error);
  env->ReleaseStringUTFChars(base_path, base);
  env->ReleaseStringUTFChars(working_path, working);
  env->ReleaseStringUTFChars(temp_path, temp);
  env->ReleaseStringUTFChars(locale, language);
  check(env, status, error);
}

extern "C" JNIEXPORT jlong JNICALL
Java_top_loafman_targetlib_TargetlibNative_start(JNIEnv* env, jclass,
                                                  jstring config_json) {
  const char* config = env->GetStringUTFChars(config_json, nullptr);
  targetlib_handle handle = 0;
  char* error = nullptr;
  const int32_t status = targetlib_start(config, &handle, &error);
  env->ReleaseStringUTFChars(config_json, config);
  check(env, status, error);
  return static_cast<jlong>(handle);
}

extern "C" JNIEXPORT jlong JNICALL
Java_top_loafman_targetlib_TargetlibNative_serve(JNIEnv* env, jclass) {
  targetlib_handle handle = 0;
  char* error = nullptr;
  check(env, targetlib_serve(&handle, &error), error);
  return static_cast<jlong>(handle);
}

extern "C" JNIEXPORT void JNICALL
Java_top_loafman_targetlib_TargetlibNative_setTunFd(JNIEnv* env, jclass,
                                                    jint fd) {
  check(env, targetlib_set_tun_fd(static_cast<int32_t>(fd)), nullptr);
}

extern "C" JNIEXPORT void JNICALL
Java_top_loafman_targetlib_TargetlibNative_stop(JNIEnv* env, jclass,
                                                 jlong handle) {
  char* error = nullptr;
  check(env, targetlib_stop(static_cast<targetlib_handle>(handle), &error),
        error);
}

extern "C" JNIEXPORT void JNICALL
Java_top_loafman_targetlib_TargetlibNative_freeHandle(JNIEnv* env, jclass,
                                                      jlong handle) {
  const int32_t status =
      targetlib_free_handle(static_cast<targetlib_handle>(handle));
  check(env, status, nullptr);
}
