/**
* WeaponSpawner - Gestion de l'apparition des armes
*
* Constantes de configuration du spawner
**/
class WeaponSpawner {
    static final int SPAWN_DELAY = 100;          // Délai entre chaque spawn d'arme
    static final int WEAPON_LIFETIME = 5000;     // Durée de vie d'une arme au sol
    static final float PLATFORM_MARGIN = 30.0f;  // Marge par rapport aux bords des plateformes
    static final float WEAPON_HEIGHT = 60.0f;    // Hauteur de spawn au-dessus de la plateforme
    static final float GUN_CHANCE = 0.25f;       // Probabilité de spawn d'un Gun
    static final float PISTOL_CHANCE = 0.50f;    // Probabilité de spawn d'un Pistol
    static final float BLASTER_CHANCE = 0.75f;   // Probabilité de spawn d'un Blaster

    /**
    * Variables d'état internes
    * @private Accessibles uniquement dans cette classe
    **/
    private int spawnTimer;                     // Compteur pour le prochain spawn
    private ArrayList<Weapon> weapons;          // Liste des armes en jeu
    private AssetManager assets;                // Gestionnaire des ressources
    private ArrayList<Platform> platforms;       // Liste des plateformes

    /**
    * Méthodes publiques - Interface externe
    **/

    /**
    * Constructeur du WeaponSpawner
    * @param weapons Liste des armes à gérer
    * @param assets Gestionnaire des ressources graphiques
    * @param platforms Liste des plateformes de spawn
    **/
    WeaponSpawner(ArrayList<Weapon> weapons, AssetManager assets, ArrayList<Platform> platforms)
    {
        if (weapons == null || assets == null || platforms == null) {
            throw new IllegalArgumentException("WeaponSpawner: paramètres ne peuvent pas être null");
        }

        this.weapons = weapons;
        this.assets = assets;
        this.platforms = platforms;
        this.spawnTimer = 0;
    }

    void update()
    {
        if (platforms.isEmpty())
            return;
        spawnTimer++;
        if (spawnTimer >= SPAWN_DELAY) {
            spawnRandomWeapon();
            spawnTimer = 0;
        }
        updateWeapons();
    }

    /**
    * Méthodes privées - Logique interne
    * @private Utilisées uniquement par les méthodes de cette classe
    **/
    private void spawnRandomWeapon()
    {
        Platform platform = getRandomPlatform();
        float weaponX = getRandomWeaponX(platform);
        float weaponY = platform.y - WEAPON_HEIGHT;
        Weapon newWeapon = createRandomWeapon(weaponX, weaponY);

        if (newWeapon != null) {
            newWeapon.spawnTime = millis();
            weapons.add(newWeapon);
        }
    }

    private Platform getRandomPlatform()
    {
        return platforms.get((int)random(platforms.size()));
    }

    private float getRandomWeaponX(Platform platform)
    {
        return random(platform.x + PLATFORM_MARGIN, platform.x + platform.w - PLATFORM_MARGIN);
    }

    private Weapon createRandomWeapon(float x, float y)
    {
        float rand = random(1);

        if (rand < GUN_CHANCE) {
            return new Gun(x, y, assets.getGunSprite(), assets.getBulletLong());
        } else if (rand < PISTOL_CHANCE) {
            return new Pistol(x, y, assets.getPistolSprite(), assets.getBulletSimple());
        } else if (rand < BLASTER_CHANCE) {
            return new Blaster(x, y, assets.getBlasterSprite(), assets.getBulletLaser());
        } else {
            return new Bow(x, y, assets.getBowSprite(), assets.getBulletArrow());
        }
    }

    private void updateWeapons()
    {
        for (int i = weapons.size() - 1; i >= 0; i--) {
            Weapon weapon = weapons.get(i);
            if (!weapon.isPickedUp && shouldRemoveWeapon(weapon)) {
                handleWeaponRemoval(weapon, i);
            }
        }
    }

    private boolean shouldRemoveWeapon(Weapon weapon)
    {
        return millis() - weapon.spawnTime > WEAPON_LIFETIME;
    }

    private void handleWeaponRemoval(Weapon weapon, int index)
    {
        weapon.fadeOut();
        if (weapon.getRenderer().getAlpha() <= 0) {
            weapons.remove(index);
        }
    }
}