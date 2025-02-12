/**
 * DestroyPlateform - Gestion d'un événement de destruction et de respawn d'une plateforme.
 * Cette classe gère l'avertissement , la destruction et le respawn des plateformes dans l'arène.
 *
 * Variables d'état et méthodes de gestion de l'événement de destruction de plateforme.
 */
class DestroyPlateform extends Event {
    /** Références à l'arène et à la plateforme */
    Arena arena;                // L'arène où se trouve la plateforme à détruire
    Platform platform;          // La plateforme à détruire

    /** Timers et états de gestion de la destruction et du respawn */
    int timer = 90;             // Temps avant la destruction de la plateforme (~1.5 sec)
    boolean warning = true;     // Phase d'avertissement avant la destruction
    boolean destroyed = false;  // Statut de la plateforme (détruite ou non)
    int respawnerTime = 0;      // Timer pour le respawn de la plateforme
    final int respawnDelay = 300; // Délai avant le respawn de la plateforme (5 secondes à 60 FPS)

    /**
     * Constructeur de l'événement de destruction de plateforme
     * @param arena L'arène où se trouve la plateforme
     * @param platform La plateforme à détruire
     */
    DestroyPlateform(Arena arena, Platform platform) {
        this.arena = arena;
        this.platform = platform;
    }

    /**
     * Met à jour l'état de l'événement de destruction.
     * Gère la phase d'avertissement, la destruction et le respawn de la plateforme.
     */
    void update() {
        // Gestion de la phase de destruction
        if (!destroyed) {
            timer--;  // Décrémenter le timer avant la destruction
            if (timer <= 0) {
                destroy();  // Détruire la plateforme si le timer atteint zéro
            }
        } else {
            // Gestion du respawn de la plateforme après sa destruction
            respawnerTime++;  // Incrémenter le timer de respawn
            if (respawnerTime >= respawnDelay) {
                respawn();  // Respawn de la plateforme après le délai
            }
        }
    }

    /**
     * Affiche l'événement à l'écran.
     * Affiche un avertissement visuel avant la destruction de la plateforme.
     */
    void display() {
        if (warning && frameCount % 10 < 5) {
            fill(255, 0, 0, 150);  // Couleur de l'avertissement (rouge transparent)
            rect(platform.x, platform.y, platform.w, platform.h);  // Affichage de la plateforme en avertissement
        }
    }

    /**
     * Détruit la plateforme en la supprimant de l'arène.
     * Marque la plateforme comme détruite et cache l'avertissement.
     */
    void destroy() {
        arena.platforms.remove(platform);  // Retirer la plateforme de l'arène
        destroyed = true;  // Marquer la plateforme comme détruite
        respawnerTime = 0;  // Réinitialiser le timer de respawn
        warning = false;    // Cacher l'avertissement une fois la plateforme détruite
    }

    /**
     * Réapparaît la plateforme après un délai.
     * Crée une nouvelle plateforme avec les mêmes caractéristiques que l'originale.
     */
    void respawn() {
        // Créer une nouvelle plateforme avec les mêmes caractéristiques (position, taille, etc.)
        Platform respawnedPlatform = new Platform(platform.x, platform.y, platform.w, platform.h, platform.isMain);
        arena.platforms.add(respawnedPlatform);  // Ajouter la plateforme réapparue à l'arène
        destroyed = false;  // Marquer la plateforme comme réapparue
        respawnerTime = 0;  // Réinitialiser le timer de respawn
    }
}
