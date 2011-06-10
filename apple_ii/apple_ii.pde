// Control key behavior setting
// Control + <letter> on the Apple II keyboard sends an ASCII control code, 0x1a 
// MODIFIERKEY_GUI sends "Command" on a Mac
// const int ctrlKey = MODIFIERKEY_CTRL;
const int ctrlKey = MODIFIERKEY_GUI;

// This maps the Apple II keyboard socket pins to Teensy pins
// See http://apple2.info/wiki/index.php?title=Pinouts#Apple_II.2FII.2B_Keyboard_Socket
const int kb0Pin = PIN_C2;
const int kb1Pin = PIN_D2;
const int kb2Pin = PIN_D3;
const int kb3Pin = PIN_D4;
const int kb4Pin = PIN_D5;
const int kb5Pin = PIN_SS;
const int kb6Pin = PIN_C4;
const int strobePin = PIN_D0;
const int resetPin = PIN_D1;

char val;
int count = 0;
int shift = 0;

void setup() {
  attachInterrupt(0, strobe, RISING);
  attachInterrupt(1, caps, FALLING);
  pinMode(kb0Pin, INPUT);
  pinMode(kb1Pin, INPUT);
  pinMode(kb2Pin, INPUT);
  pinMode(kb3Pin, INPUT);
  pinMode(kb4Pin, INPUT);
  pinMode(kb5Pin, INPUT);
  pinMode(kb6Pin, INPUT);
  pinMode(strobePin, INPUT);
  pinMode(resetPin, INPUT);
}

void loop() {
}

void caps() {
  shift = shift ^ 1;
}

void strobe() {
  val = 0;
  val = digitalRead(kb0Pin) * 1 + val;
  val = digitalRead(kb1Pin) * 2 + val;
  val = digitalRead(kb2Pin) * 4 + val;
  val = digitalRead(kb3Pin) * 8 + val;
  val = digitalRead(kb4Pin) * 16 + val;
  val = digitalRead(kb5Pin) * 32 + val;
  val = digitalRead(kb6Pin) * 64 + val;
  if (val >= 0x20) {
    if (val >= 0x41 && val <= 0x5a && shift) val += 0x20;
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
    // Teensy's key symbols start at 4 for KEY_A
    press((int) val + 3, ctrlKey);
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

