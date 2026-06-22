# Guide de Déploiement Pro Informatique

## Option 1 : Déploiement sur Vercel (Recommandé)

1.  **Poussez votre code sur GitHub** : Créez un nouveau dépôt et envoyez-y le contenu du dossier `pro_informatique_app`.
2.  **Connectez-vous à Vercel** : Allez sur [vercel.com](https://vercel.com).
3.  **Importez le projet** : Sélectionnez votre dépôt GitHub.
4.  **Configuration du Build** :
    *   **Framework Preset** : Other
    *   **Build Command** : `flutter/bin/flutter build web --release` (Si vous utilisez leur environnement, sinon compilez localement et uploadez le dossier `build/web`).
    *   **Output Directory** : `build/web`
5.  **Déployez** : Vercel gérera le reste. Le fichier `vercel.json` inclus s'occupera du routage.

## Option 2 : Déploiement sur Render

1.  Créez un "Static Site" sur Render.
2.  Connectez votre dépôt GitHub.
3.  **Build Command** : `flutter/bin/flutter build web --release`
4.  **Publish Directory** : `build/web`

## Développement Local

Pour tester localement :
```bash
flutter run -d chrome
```
