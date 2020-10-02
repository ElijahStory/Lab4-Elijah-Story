//NMD211 Lab4A
//Elijah Story
//10-2-2020

float userX = 400, userY = 600;

void setup(){
    size(800,800);
}

void draw(){
    background(0);

    if(keyPressed){
        if(key == 'a'){
            userX -= speed;
        }

        if(key == 'd'){
            userX += speed;
        }
    }
}