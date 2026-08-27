#include <jni.h>

#include <cstdint>
extern "C" {
struct targetlib_init_options {
  const char* base_path;
  const char* working_path;
  const char* temp_path;
  const char* locale;
  int32_t log_max_lines;
  bool debug;
  bool oom_killer;
};

int32_t targetlib_start(const targetlib_init_options*, char**);
int32_t targetlib_set_tun_fd(int32_t);
int32_t targetlib_stop(char**);
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
Java_top_loafman_targetlib_TargetlibNative_start(
    JNIEnv* env, jclass, jstring base_path, jstring working_path,
    jstring temp_path, jstring locale, jint log_max_lines, jboolean debug,
    jboolean oom_killer) {
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
      static_cast<bool>(oom_killer)};
  char* error = nullptr;
  const int32_t status = targetlib_start(&options, &error);
  env->ReleaseStringUTFChars(base_path, base);
  env->ReleaseStringUTFChars(working_path, working);
  env->ReleaseStringUTFChars(temp_path, temp);
  env->ReleaseStringUTFChars(locale, language);
  check(env, status, error);
}

extern "C" JNIEXPORT void JNICALL
Java_top_loafman_targetlib_TargetlibNative_setTunFd(JNIEnv* env, jclass,
                                                    jint fd) {
  check(env, targetlib_set_tun_fd(static_cast<int32_t>(fd)), nullptr);
}

extern "C" JNIEXPORT void JNICALL
Java_top_loafman_targetlib_TargetlibNative_stop(JNIEnv* env, jclass) {
  char* error = nullptr;
  const int32_t status = targetlib_stop(&error);
  check(env, status, error);
}
