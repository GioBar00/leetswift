.PHONY: build install uninstall clean

build:
	swift build -c release

install: build
	mkdir -p /usr/local/bin
	mv .build/release/leetswift /usr/local/bin/leetswift
	@echo "✅ Installed leetswift globally to /usr/local/bin/leetswift!"
	@echo "You can now run 'leetswift' from any folder on your machine!"

uninstall:
	rm -f /usr/local/bin/leetswift
	@echo "🗑️ Uninstalled leetswift globally."

clean:
	rm -rf .build
