.PHONY: all
all: test lint

.PHONY: test
test:
	flutter test

.PHONY: lint
lint:
	dart analyze

.PHONY: demo-web
demo-web:
	cd example; flutter -d chrome run -t lib/web.dart

.PHONY: demo-android
demo-android:
	# For android, connect your device, enable dev options,
	# and allow file transfer over USB.
	# See `flutter devices` for possible `-d` arguments.
	cd example; flutter -d pixel run

.PHONY: monopole.github.io
monopole.github.io:
	# Replacing ../monopole.github.io !!!
	cd example; flutter build web --web-renderer canvaskit -t lib/web.dart --release
	rm -rf ../monopole.github.io/*
	cp -r example/build/web/* ../monopole.github.io
