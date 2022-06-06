
String ID = "XX";

/*** テスト用 ***/

import ddf.minim.*;
/*
import processing.serial.*;
import ddf.minim.signals.*;
import gazetrack.*;
import cc.arduino.*;
*/

// 音楽再生ライブラリより．
Minim minim;
AudioSample song1;
AudioSample song2;

// TobiiEyeXを接続する場合
// GazeTrack gazeTrack;
// float latestEyeX, latestEyeY;

// Serialクラスのオブジェクト port 
// Serial port;

// csvファイル書き出し用
PrintWriter writer;

// int w = 960;
// int h = 660;
float[] ball = new float[4];
String gameStatus = "start";
float ballR = 60;
float ballSpeed = 6; // ボールの速さ
int now;
int start;
int playTime = 55*60; // 1ゲームのフレーム数
int countMax = 3000;
int countStart = 0;
int turnCount;
int[] turnTiming = new int[5];
int blinkTimingStamp = 0;
boolean collision, ChangedDirection;
boolean BlinkDetectionFlag; // 古いやつ
boolean isBlinking;
int blinkCount = 0;
int sensor;
int[] data = new int[3]; // データ受け取り&処理用
int fcnt; // フレームカウント
int trialID;
int turnTimingNum;
String foldername; 
String filename;

void setup(){
  trialID = 0;
  frameRate(60);
  
  //保存するCSVファイルを生成
  foldername = ("subject_" + ID + "\\");
  filename = (nf(year(),4) + nf(month(),2) + nf(day(),2) + nf(hour(),2) + nf(minute(),2) + nf(second(),2));
  writer = createWriter(foldername + filename + ".csv");
  writer.println("frame" + "," + "Time" + "," + "ballX" + "," + "ballY" + "," + "mouseX" + "," + "mouseY" + "," + "ChangeDirection" + "," + "Blinking");
  
  //シリアルポートの設定: オブジェクトの定義
  //println(Serial.list()[0]);
  //port = new Serial(this, Serial.list()[0], 9600); // 第2引数は適宜変更する．
  
  // gazeTrack = new GazeTrack(this);
  
  fullScreen();
  textAlign(CENTER);
  ball[0] = width/2;
  ball[1] = height/2;
  ball[2] = random(-ballSpeed, ballSpeed);
  ball[3] = -sqrt(ballSpeed * ballSpeed - ball[2] * ball[2]);
  for (int i=0; i<4; i++){
    turnTiming[i] = 120 + i * 30;
  }
  turnTiming[4] = 150; // turnTiming = [120, 150, 180, 210, 240, 150]
  // デバッグ用 //////////////
  for (int i=0; i<5; i++){
    println("turnTiming[" + i + "] = " + turnTiming[i]);
  }
  //////////////////////////
  minim = new Minim(this);
  song1 = minim.loadSample("_mp3_files/button04a.mp3");
  song2 = minim.loadSample("_mp3_files/button01b.mp3");
  song1.setGain(-8);
  song2.setGain(-8);
  // surface.setLocation(0,0);
}

void draw(){
  common();
  if(gameStatus == "start"){
    start_scene();
  } else if(gameStatus == "count"){
    count_scene();
  } else if(gameStatus == "play"){
    play_scene();
  } else {
    end_scene();
  }
}

void common(){
  background(48);
  fill(255);
  textSize(24);
  /* 
  if (gazeTrack.gazePresent()){
    latestEyeX = gazeTrack.getGazeX();
    latestEyeY = gazeTrack.getGazeY();
    
    println("Latest gaze data at: " + gazeTrack.getTimestamp());
  }
  */
  now = millis(); // 基準時間[ms]
}

void start_scene(){
  text("Trial Number: " + (trialID+1), width/2, height/2);
  text("Click to Start", width/2, height/2+60);
  countStart = now;
  turnTimingNum = trialID;
  turnCount = turnTiming[turnTimingNum];
}

void count_scene(){
  text("Place the mouse cursor at the center of the object.", width/2, height/2+60);
  // ボールの描画
  ellipse(ball[0], ball[1], ballR, ballR);
  if((mouseX < ball[0] - 5 || ball[0] + 5 < mouseX) || (mouseY < ball[1] - 5 || ball[1] + 5 < mouseY)){
    countStart = now;
  } else {
    int countText = countStart + countMax - now;
    textSize(48);
    text(countText/1000 + 1, width/2, height/3);
    if(countText <= 0){
      gameStatus = "play";
    }
    start = now;
    fcnt = 0;
  }
}

void play_scene(){
  // ボールの描画
  ellipse(ball[0], ball[1], ballR, ballR);
  // ボールの移動
  ball[0] += ball[2];
  ball[1] += ball[3];
  
  // 方向転換
  ChangedDirection = false;
  if (fcnt == turnCount){
    // 次の方向転換のタイミングを決める
    turnTimingNum = (turnTimingNum + 3) % 5;
    turnCount = fcnt + turnTiming[turnTimingNum];
    ChangedDirection = true;
    
    // 鋭く方向転換するようにする (-90°以上 +90°以下)
    boolean xIsPlus, yIsPlus;
    if (ball[2] > 0) xIsPlus = true;
    else xIsPlus = false;
    if (ball[3] > 0) yIsPlus = true;
    else yIsPlus = false;
    ball[3] = (ball[3] + random(ballSpeed, ballSpeed*2)) % ballSpeed;
    ball[2] = sqrt(ballSpeed * ballSpeed - ball[3] * ball[3]);
    if (xIsPlus) ball[2] = -ball[2];
    if (yIsPlus) ball[3] = -ball[3];
  }
  // 方向転換したときには壁衝突判定をしない
  if (!ChangedDirection) checkCollision();
  
  // 音再生
  // 修正版．ちょっと早めに鳴らす．
  if(fcnt%120 == 119){
    song2.trigger();
  } else if(fcnt%30 == 29){
    song1.trigger();
  }
  // 瞬きのタイミング
  isBlinking = false;
  if(fcnt%120 == 0){
    isBlinking = true;
  }
  
  /*
  // 修正前
  isBlinking = false;
  if(fcnt%120 == 0){
    blinkTimingStamp = now;
    isBlinking = true;
    song2.trigger();
  } else if(fcnt%30 == 0){
    song1.trigger();
  }

  sensor = data[0]*256 + data[1];
  BlinkDetectionFlag = boolean(data[2]);
  if (BlinkDetectionFlag) {
    print("Blink Detected!: ");
    blinkCount++;
    println(blinkCount);
  }
  */
  writer.println(fcnt + "," + (now-start) + "," + ball[0] + "," + ball[1] + "," + mouseX + "," + mouseY + "," + ChangedDirection + "," + isBlinking);
  ckeckGameStatus();
  // フレームカウント
  fcnt++;
}

// シリアル通信
/*
void serialEvent(Serial port){
  if (port.available() >= 5){
    if(port.read() == 254){
      if(port.read() == 255){
        data[0] = port.read();
        data[1] = port.read();
        data[2] = port.read();
      }
    }
  }        
}
*/

void end_scene(){
  noLoop();
  text("END", width/2, height/2);
  text("Thank You for Playing", width/2, height/2+60);
  text("Press [Esc] to exit", width/2, height/2+120);
  writer.flush();
  writer.close();
}

void ckeckGameStatus(){
  if(fcnt > playTime){
    trialID++;
    if(trialID > 4){
      gameStatus = "end";
    } else {
      gameStatus = "start";
      ball[0] = width/2;
      ball[1] = height/2;
      ball[2] = random(-ballSpeed, ballSpeed);
      ball[3] = -sqrt(ballSpeed * ballSpeed - ball[2] * ball[2]);
      // csvファイルを保存して閉じる
      writer.flush();
      writer.close();
      // 新規のファイルを作る
      filename = (nf(year(),4) + nf(month(),2) + nf(day(),2) + nf(hour(),2) + nf(minute(),2) + nf(second(),2));
      writer = createWriter(foldername + filename + ".csv");
      writer.println("frame" + "," + "Time" + "," + "ballX" + "," + "ballY" + "," + "mouseX" + "," + "mouseY" + "," + "ChangeDirection" + "," + "Blinking");
    }
  }
}

void mousePressed(){
  if(gameStatus == "start"){
    gameStatus = "count";
  }
}

void stop()
{
  song1.close();
  song2.close();
  minim.stop();
  super.stop();
}

void checkCollision(){
  if(ball[0] < ballR/2 || ball[0] > width - ballR/2 || ball[1] < ballR/2 || ball[1] > height - ballR/2){
    checkCollisionWall();
    collision = true;
  } else {
    collision = false;
  }
}

void checkCollisionWall(){
  if(ball[0] < ballR/2 || ball[0] > width - ballR/2){
    reverseX();
  }else{ // ball[1] < ballR
    reverseY();
  }
}

void reverseX(){
  ball[0] = ball[0] - ball[2];
  ball[2] = -ball[2];
}

void reverseY(){
  ball[1] = ball[1] - ball[3];
  ball[3] = -ball[3];
}
