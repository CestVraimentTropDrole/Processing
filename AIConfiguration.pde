/**
* AIConfiguration - Configuration de l'IA
*
* Constantes de configuration pour l'IA
**/
class AIConfiguration {
    // Temps de réaction et prise de décision
    float decisionInterval;                 // Temps entre les décisions plus élevé = réaction plus lente
    float reactionDelay;                    // Délai artificiel avant de réagir aux dangers

    // Précision et combat
    float accuracy;                         // Probabilité de tirer quand l'occasion se présente
    float dodgeProbability;                 // Probabilité d'esquiver les projectiles
    float shieldUseProbability;             // Probabilité d'utiliser le bouclier correctement
    float reloadThreshold;                  // Pourcentage de munitions restantes avant rechargement

    // Mouvement et positionnement
    float positioningAccuracy;              // Précision pour maintenir la distance optimale
    float jumpRandomness;                   // Probabilité de sauts aléatoires
    float weaponPickupPriority;             // Priorité donnée à la récupération d'armes

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur avec paramètres par défaut
    */
    AIConfiguration()
    {
        setDefaultValues();
    }

    /**
    * Configuration pour une IA de niveau facile
    */
    void setEasyDifficulty()
    {
        decisionInterval = 60;              // Réaction plus lente
        reactionDelay = 0.4;                // Délai notable avant de réagir
        accuracy = 0.3;                     // Précision faible (prototype, marche moyennement)
        dodgeProbability = 0.4;             // Esquive peu souvent
        shieldUseProbability = 0.3;         // Utilise rarement le bouclier
        positioningAccuracy = 0.0;          // Mauvais positionnement (prototype, marche pas)
        jumpRandomness = 0.0;               // Sauts plus aléatoires (prototype, marche pas)
        reloadThreshold = 0.9;              // Recharge tout le temps
    }

    /**
    * Configuration pour une IA de niveau moyen
    */
    void setMediumDifficulty()
    {
        decisionInterval = 45;              // Réaction moyenne
        reactionDelay = 0.3;                // Délai modéré
        accuracy = 0.6;                     // Précision moyenne (prototype, marche moyennement)
        dodgeProbability = 0.6;             // Esquive moyennement
        shieldUseProbability = 0.5;         // Utilisation moyenne du bouclier
        positioningAccuracy = 0.0;          // Positionnement correct (prototype, marche pas)
        jumpRandomness = 0.0;               // Sauts plus contrôlés (prototype, marche pas)
        reloadThreshold = 0.5;              // Recharge de manière équilibrée
    }

    /**
    * Configuration pour une IA de niveau difficile
    */
    void setHardDifficulty()
    {
        decisionInterval = 20;              // Réaction rapide
        reactionDelay = 0.1;                // Réaction presque immédiate
        accuracy = 0.85;                    // Très précis (prototype, marche moyennement)
        dodgeProbability = 0.9;             // Esquive souvent
        shieldUseProbability = 0.7;         // Utilise bien le bouclier
        positioningAccuracy = 0.0;          // Excellent positionnement (prototype, marche pas)
        jumpRandomness = 0.0;               // Sauts très contrôlés (prototype, marche pas)
        reloadThreshold = 0.1;              // Recharge au dernier moment
    }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement par les méthodes de cette classe
    **/
    private void setDefaultValues()
    {
        setMediumDifficulty();
    }
}