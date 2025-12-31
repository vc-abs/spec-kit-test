# This requires bash to work (sh doesn't support sources)
cd $(dirname $0)

if [ -z "$GDM_TGT_ENV" ]; then
	export GDM_TGT_ENV=dev
fi

# Config
parentPath=$(realpath -s ..)
configPath=$(realpath -s .)
configFileName="config.json"
devJSONPath="$configPath/.dev.json"
distPath="$configPath/dist"
buildPath="./build"
hooksPath="./.githooks"
godotPath="$parentPath/gd-math-godot"
godotAssetsPath="$godotPath/assets"

rebuildConfig() {
	bash ./build.sh 1
}

updateConfig() {
	cp -f "$distPath"/* "$godotAssetsPath/"
}

syncConfig() {
	cd "$godotPath"
	GDM_BUILD_MODE=quick ./sync.sh
	cd "$configPath"
}

buildAndUpdateConfig() {
	rebuildConfig
	updateConfig
	syncConfig
}

runGame() {
	cd "$godotPath"
	godot
	cd "$configPath"
}

setupDevModules() {
	find "./dev" -maxdepth 1 -type f | while read -r f; do
		cp -n "$f" "./.$(basename "$f")"
	done
}

echoToSTDERR() {
	printf "%s\n" "$*" >&2;
}
