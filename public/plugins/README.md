# Plugin auto-update manifest

`manifest.json` lists JAR versions served at `https://rootmc.net/plugins/` for the in-game RootMC heartbeat updater.

JAR files are **not** stored in this repo (too large; built from the Minecraft plugin Gradle project). When merging UI changes back to production, sync this folder from the monorepo after `publishPlugins generatePluginManifest`.
