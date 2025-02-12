class DestroyPlateform extends Event {
    Arena arena;
    Platform platform;
    int timer = 90; // Temps avant destruction (~1.5 sec)
    boolean warning = true;

    DestroyPlateform(Arena arena, Platform platform) {
        this.arena = arena;
        this.platform = platform;
    }

    void update() {
        timer--;
        if (timer <= 0) {
            destroy();
            finished = true;
        }
    }

    void display() {
        if (warning && frameCount % 10 < 5) {
            fill(255, 0, 0, 150);
            rect(platform.x, platform.y, platform.w, platform.h);
        }
    }

    void destroy() {
        arena.platforms.remove(platform);
    }
}
