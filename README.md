# Gestor de Patrimonio — save

Aplicación Flutter simple para llevar el control de patrimonio personal y activos. Permite añadir, listar y eliminar activos, distinguir entre activos líquidos y no líquidos, y ver totales preformateados.

Características principales
- Añadir activos con nombre, monto y tipo (Líquido / Activo).
- Listado de activos con interfaz tipo tarjeta (glassmorphism).
- Cálculo de totales (Total, Líquido, Activos).
- Eliminación con gesto (swipe) y opción de deshacer.
- Persistencia local con `shared_preferences`.
- Optimización de rendimiento: guardados debounced, RepaintBoundary, reducción del blur en lista.

Capturas
- Pantalla principal con el total y la lista de activos.
- Diálogo para añadir un activo.
Instalación y ejecución
1. Clonar el repositorio y abrir la carpeta del proyecto.
2. Obtener dependencias:
# Save — Personal Asset Manager

Simple Flutter app to manage personal assets. You can add, list, and remove assets, mark them as liquid or non-liquid, and view preformatted totals.

Key features
- Add assets with a name, amount and type (Liquid / Asset).
- Assets list displayed as cards (glassmorphism UI).
- Totals calculation (Total, Liquid, Assets).
- Swipe to delete with Undo action.
- Local persistence using `shared_preferences`.
- Performance optimizations: debounced saves, RepaintBoundary to reduce repaints, minimized blur for list items.

Screenshots
- Main screen showing totals and list of assets.
- Bottom sheet dialog for adding an asset.

Install & Run
1. Clone/open the repository and change to the project directory.
2. Get dependencies:
```bash
flutter pub get
```
3. Run the app on an emulator or device:
```bash
flutter run
```
4. (Optional) Run on Windows:
```bash
flutter run -d windows
```

Relevant dependencies
- `shared_preferences`: local storage for the assets list.
- `intl`: numeric formatting for amounts and date handling.

Project structure
- `lib/main.dart` — App entry point and main UI (asset management, theme, custom widgets).
- `assets/` — Static assets (if any).
- `test/` — Project tests.

How it works
- Assets are modeled with `AssetEntry` (name, amount, type, date) in [lib/main.dart](lib/main.dart#L1).
- They are saved to `SharedPreferences` as JSON under the key `asset_entries`.
- To improve UX, disk writes are debounced so quick successive changes don’t trigger many writes.

Performance & UX notes
- Debounced saves: avoids excessive `SharedPreferences` writes and improves responsiveness when users add assets quickly.
- RepaintBoundary: added around glassmorphism cards to reduce unnecessary repaints for complex UI elements.
- Minimized blur: the summary card uses a moderate blur, while list items use `blurSigma: 0.0` to avoid costly backdrop filters per item.
- Incremental totals calculation: instead of recalculating totals over the whole list every change, the code increments or decrements totals when assets are added or removed.

Testing & verification
- Analyze the project:
```bash
flutter analyze
```
- Run tests (if present):
```bash
flutter test
```

Development & contribution
- If you’re planning to add features, open an issue first to discuss API or UX changes.
- Keep UI consistent and prefer reusing `GlassmorphicCard` and `ThemeData`.

Privacy & storage
- All data is stored locally on the device using `SharedPreferences`.
- For encryption or cloud sync, consider `secure_storage` or a backend sync solution.

Suggested improvements
- Cross-device sync (e.g., Firebase or a custom API).
- Authentication and encrypted storage for better privacy.
- UI and integration tests to ensure predictable behavior.

Contact
- This is a personal project — open an issue for suggestions or fixes.

License
- Add your preferred license or use the repository’s default license.

Thanks for using `save` — Personal Asset Manager.
