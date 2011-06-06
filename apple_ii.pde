
char val;
int count = 0;
void setup() {
  //attachInterrupt(0, strobe_falling, FALLING);
  attachInterrupt(0, strobe, RISING);
  pinMode(PIN_D0, INPUT);
  pinMode(PIN_D1, INPUT);
  pinMode(PIN_D2, INPUT);
  pinMode(PIN_D3, INPUT);
  pinMode(PIN_D4, INPUT);
  pinMode(PIN_D5, INPUT);
  pinMode(PIN_D6, INPUT);
  pinMode(PIN_D7, INPUT);
}

void loop() {
}

void strobe() {
  val = 0;
  val = digitalRead(PIN_D1) * 1 + val;
  val = digitalRead(PIN_D2) * 2 + val;
  val = digitalRead(PIN_D3) * 4 + val;
  val = digitalRead(PIN_D4) * 8 + val;
  val = digitalRead(PIN_D5) * 16 + val;
  val = digitalRead(PIN_D6) * 32 + val;
  val = digitalRead(PIN_D7) * 64 + val;
  if (val >= 32) {
    Keyboard.print(val);
  } else if (val == 8) {
    press(KEY_BACKSPACE, 0);
  } else if (val == 13) {
    press(KEY_ENTER, 0);
  } else if (val == 27) {
    press(KEY_ESC, 0);
  } else if (val == 21) {
    press(KEY_TAB, 0);
  } else {
    //Keyboard.print('<');
    //Keyboard.print((int) val);
    //Keyboard.print('>');
    press((int) val + 3, MODIFIERKEY_GUI);
  }
}

void press(int key, int modifier) {
  Keyboard.set_key1(key);
  Keyboard.set_modifier(modifier);
  Keyboard.send_now();
  Keyboard.set_key1(0);
  Keyboard.set_modifier(0);
  Keyboard.send_now();
}

