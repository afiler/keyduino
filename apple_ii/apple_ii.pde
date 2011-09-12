// Control key behavior setting
// Control + <letter> on the Apple II keyboard sends an ASCII control code, 0x1a 
// MODIFIERKEY_GUI sends "Command" on a Mac
// const int ctrlKey = MODIFIERKEY_CTRL;
#define ctrlKey MODIFIERKEY_GUI

// This maps the Apple II keyboard socket pins to Teensy pins
// See http://apple2.info/wiki/index.php?title=Pinouts#Apple_II.2FII.2B_Keyboard_Socket
#define kb0Pin PIN_C2
#define kb1Pin PIN_D2
#define kb2Pin PIN_D3
#define kb3Pin PIN_D4
#define kb4Pin PIN_D5
#define kb5Pin PIN_SS
#define kb6Pin PIN_C4
#define strobePin PIN_D0
#define resetPin PIN_D1

#define ledPin PIN_D6

#define shiftPin PIN_B4
#define ctrlPin PIN_B5

#define CTRL_HACK
#define SHIFT_HACK
//#define RESET_FN reset_pressed
// #DEFINE RESET_FN caps
#define ARROW_HACK

char val;
int count = 0;
int shift = 0;
int ctrl = 0;

int cmd_tab = 0;

void setup() {
  attachInterrupt(0, strobe, RISING);

  attachInterrupt(1, reset_pressed, FALLING);

  pinMode(kb0Pin, INPUT);
  pinMode(kb1Pin, INPUT);
  pinMode(kb2Pin, INPUT);
  pinMode(kb3Pin, INPUT);
  pinMode(kb4Pin, INPUT);
  pinMode(kb5Pin, INPUT);
  pinMode(kb6Pin, INPUT);
  pinMode(strobePin, INPUT);
  pinMode(resetPin, INPUT);
  
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, 1);
}

void loop() {
  if (cmd_tab) {
    while (ctrl = !digitalRead(ctrlPin));
    Keyboard.set_key1(0);
    Keyboard.set_modifier(0);
    Keyboard.send_now();
    digitalWrite(ledPin, 1);
  }
}

void caps() {
  shift = shift ^ 1;
}

void reset_pressed() {
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
  
#ifdef SHIFT_HACK
  shift = !digitalRead(shiftPin);
#endif
#ifdef CTRL_HACK
  ctrl = !digitalRead(ctrlPin);
#endif
  
  if (val >= 0x20) {
    if (val == '^' && shift && !ctrl) val = 'N';
    if (val == ']' && shift && !ctrl) val = 'M';
    if (val == '@' && shift && !ctrl) val = 'P';
    if (val >= 0x41 && val <= 0x5a && !shift) val += 0x20;
    Keyboard.print(val);
  } else if (val == 8 && !ctrl) {
    press(KEY_BACKSPACE);
  } else if (val == 13 && !ctrl) {
    press(KEY_ENTER);
  } else if (val == 27 && !ctrl) {
    press(KEY_ESC);
#ifdef ARROW_HACK 
  } else if (val == 8 && ctrl) {
    tab(MODIFIERKEY_SHIFT);
  } else if (val == 21 && ctrl) {
    tab(0);
#endif
  } else if (val == 21 && !ctrl) {
    press(KEY_TAB);
  } else {
    // Teensy's key symbols start at 4 for KEY_A
    press((int) val + 3, ctrlKey);
  }
}

void tab(int modifier) {
  digitalWrite(ledPin, 0);
  Keyboard.set_key1(KEY_TAB);
  Keyboard.set_modifier(ctrlKey | modifier);
  Keyboard.send_now();
  Keyboard.set_key1(0);
  Keyboard.send_now();
  cmd_tab = 1;
}

void press(int key) { press(key, 0); }
void press(int key, int modifier) {
  Keyboard.set_key1(key);
  Keyboard.set_modifier(modifier);
  Keyboard.send_now();
  Keyboard.set_key1(0);
  if (!cmd_tab) Keyboard.set_modifier(0);
  Keyboard.send_now();
}

