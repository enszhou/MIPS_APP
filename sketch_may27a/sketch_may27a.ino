int LED = 13;

void setup() {
  // put your setup code here, to run once:
  pinMode(LED, OUTPUT); // 定义13为输出引脚
  Serial.begin(9600,SERIAL_8N1);//模块上电灯快闪，arduino发送指令时需要按住模块上的按键
  //Serial.begin(38400);//按住按键再给模块上电，此时模块灯慢闪后即可松开按键
}

void sendcmd() {
  Serial.println("AT");//send cmd AT\r\n
  while (Serial.available())
  {
    char ch;
    ch = Serial.read();
    Serial.print(ch);
  } // Get response: OK\r\n
  delay(1000); // wait for printing

}

void loop() {
  while (Serial.available())
  {
    char ch;
    ch = Serial.read();
    Serial.print(ch);
  } // Get response

}
