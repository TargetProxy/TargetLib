# targetlib

Flutter-facing TargetLib runtime package. The generated TargetLib gRPC API and the cross-platform executable/service
manager live here so applications share one implementation. Filesystem locations continue to come from
`path_provider`; platform-specific process details remain isolated inside the manager rather than being duplicated in
each Flutter runner.

The public Dart exports include `TargetLibClient`, the generated TargetLib messages, `TargetLibServiceManager`, and
`TargetLibLog`.

A new Flutter plugin project.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/to/develop-plugins), a specialized package that includes platform-specific
implementation code for Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev), which offers tutorials, samples, guidance on mobile development, and a
full API reference.

