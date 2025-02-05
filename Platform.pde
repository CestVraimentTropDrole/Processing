class Platform {
    float x, y, w, h;
    boolean isMain; // Permet de savoir si c'est la Main Platform ou non
  
    Platform(float x, float y, float w, float h, boolean isMain)
    {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.isMain = isMain;
    }
  
    void draw()
    {
        fill(isMain ? #8B4513 : #A0522D); // Couleur de la Main Platform (tu peux changer poto, j'ai mis au pif)
        rect(x, y, w, h);
    }
  
    boolean isOnPlatform(float px, float py, float ph, float vy)
    {
        // Collision horizontale
        boolean horizontalCollision = px + 50 > x && px < x + w;
        // Collision verticale (seulement si on descend)
        boolean verticalCollision = py + ph > y && py + ph < y + h && vy >= 0;

        return horizontalCollision && verticalCollision;
    }
}