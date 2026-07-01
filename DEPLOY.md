# Guide de Déploiement Pro Informatique

## Option 1 : Déploiement sur Vercel (Recommandé)

### Méthode A : Déploiement avec Build Local (Recommandé)

1.  **Compilez l'application localement** :
    ```bash
    flutter clean
    flutter build web --release
    ```

2.  **Poussez votre code sur GitHub** : Créez un nouveau dépôt et envoyez-y tout le contenu du dossier `pro_informatique_app`.

3.  **Connectez-vous à Vercel** : Allez sur [vercel.com](https://vercel.com).

4.  **Importez le projet** : Sélectionnez votre dépôt GitHub.

5.  **Configuration du Build** :
    *   **Framework Preset** : Other
    *   **Build Command** : Laisser vide (nous avons déjà compilé localement)
    *   **Output Directory** : `build/web`

6.  **Variables d'Environnement** :
    *   Ajoutez toutes les variables du fichier `.env` dans les paramètres du projet Vercel.

7.  **Déployez** : Cliquez sur "Deploy" et attendez la fin du déploiement.

### Méthode B : Déploiement avec Build sur Vercel

Si vous préférez que Vercel compile l'application pour vous :

1.  **Ajoutez un script d'installation Flutter** : Créez un fichier `install_flutter.sh` à la racine :
    ```bash
    #!/bin/bash
    set -e
    FLUTTER_VERSION="3.44.3"
    git clone https://github.com/flutter/flutter.git -b stable
    cd flutter
    git checkout $FLUTTER_VERSION
    ./bin/flutter --version
    ./bin/flutter config --no-analytics
    ```

2.  **Mettez à jour vercel.json** :
    ```json
    {
      "version": 2,
      "buildCommand": "./install_flutter.sh && ./flutter/bin/flutter build web --release",
      "outputDirectory": "build/web",
      "cleanUrls": true,
      "trailingSlash": false,
      "rewrites": [
        {
          "source": "/(.*)",
          "destination": "/index.html"
        }
      ]
    }
    ```

3.  **Rendez le script exécutable** :
    ```bash
    chmod +x install_flutter.sh
    ```

4.  **Poussez et déployez** comme dans la méthode A.

## Option 2 : Déploiement sur Render

1.  Créez un "Static Site" sur Render.
2.  Connectez votre dépôt GitHub.
3.  **Build Command** : `flutter build web --release`
4.  **Publish Directory** : `build/web`

## Développement Local

Pour tester localement :
```bash
flutter run -d chrome
```

## Fichiers Importants

- `vercel.json` : Configuration pour Vercel (routage et build)
- `.env` : Variables d'environnement (Firebase)
- `.env.example` : Modèle de variables d'environnement
- `build/web/` : Dossier de sortie du build web (généré automatiquement)
