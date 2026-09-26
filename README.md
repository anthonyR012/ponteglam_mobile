# ponte_glam
Ponte Glam
Effortless Elegance (Elegancia sin esfuerzo).
El nombre "PonteGlam" sugiere una combinación de sofisticación urbana y una calidad radiante o resplandeciente. Aquí hay un desglose:

Ponte: la palabra "Ponte" es una forma del verbo "poner", que significa "poner" o "colocar" en inglés. Específicamente, "Ponte" es la segunda persona del singular del imperativo, a menudo utilizada como orden o sugerencia. Puede traducirse como “ponerse” o “vestir” cuando se hace referencia a prendas o complementos.
Glam: es una forma abreviada de "glamuroso". A menudo se utiliza como adjetivo para describir cosas que son elegantes, modernas, atractivas o llenas de glamour. El término se asocia con la sofisticación, la elegancia y la sensación de lujo.

Paleta de colores:
- [Pallete]https://drive.google.com/file/d/12Bkrj_b4VIw1so2LzfuzZHSdPnJWR5GB/view?usp=sharing
Typography:
Title: Montserrat. (bold)
Subtitle: Lora. (Oblique)
Paragraph: Hind madurai. (300)
Ejemplo: 
-[Typography]https://drive.google.com/file/d/1RbOgnXi-O-EA74I8zullEMeO7achAyL3/view?usp=sharing



# usages
## SQLite
For this application, a DAO structure has been implemented using the packages floor and sqflite.
To correctly utilize these packages, you need to declare which models will be created locally for offline use.
After declaring the models, ensure that you have built the app_database.g.dart files by executing the following command:

```bash
flutter packages pub run build_runner build
```
If you are constantly making changes to the model files during development, you should instead use the command:
```bash
flutter packages pub run build_runner watch
```

## Intl
To ensure that we are using the user's preferred language, we must set up the language correctly according to the user's device.
You simply need to create an arb file with the desired language in the l10n folder, translate an existing file, and finally run the following command to build the necessary files:

```bash
flutter gen-l10n
```

