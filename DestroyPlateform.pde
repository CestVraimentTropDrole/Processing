class DestroyPlateform extends Event {
    Arena arena;
    Platform platform;
    int timer = 90; // Temps avant destruction (~1.5 sec)
    boolean warning = true;
    boolean destroyed = false;
    int respawnerTime = 0; // Timer pour le respawn
    final int respawnDelay = 300; // Délai de respawn (5 secondes à 60 FPS)

    DestroyPlateform(Arena arena, Platform platform) {
        this.arena = arena;
        this.platform = platform;
    }

    void update() {
        if (!destroyed) {
            // Temps avant destruction de la plateforme
            timer--;
            if (timer <= 0) {
                destroy();
            }
        } else {
            // Gestion du respawn après la destruction
            respawnerTime++;
            if (respawnerTime >= respawnDelay) {
                respawn();
            }
        }
    }

    void display() {
        if (warning && frameCount % 10 < 5) {
            fill(255, 0, 0, 150); // Couleur pour l'avertissement
            rect(platform.x, platform.y, platform.w, platform.h); // Affichage de la plateforme
        }
    }

    void destroy() {
        arena.platforms.remove(platform); // Supprimer la plateforme de l'arène
        destroyed = true; // Marquer la plateforme comme détruite
        respawnerTime = 0; // Réinitialiser le timer de respawn
        warning = false;
    }

    void respawn() {
        println("Respawn de la plateforme !"); // Pour vérifier
        // Créer une nouvelle plateforme avec les mêmes caractéristiques
        Platform respawnedPlatform = new Platform(platform.x, platform.y, platform.w, platform.h, platform.isMain);
        arena.platforms.add(respawnedPlatform); // Ajouter la plateforme à l'arène
        destroyed = false; // Marquer la plateforme comme réapparue
        respawnerTime = 0; // Réinitialiser le timer de respawn
    }
}
