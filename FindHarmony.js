
//
// This is ECMAScript code (ECMA-262 aka "Java Script")
//


//---------------------------------------------------------
// init
// this function will be called on startup of mscore
//---------------------------------------------------------

function init()
{
   // print("Find harmonies plugin");
}

//-------------------------------------------------------------------
// run
// this function will be called when activating the plugin menu entry
//
// global Variables:
// pluginPath - contains the plugin path; file separator is "/"
//-------------------------------------------------------------------

function run()
{
   // no score open (MuseScore 2.0+, can't happen earlier)
   if (typeof curScore === 'undefined')
      return;
	
   var recognized = 0;
   var cursor = new Cursor(curScore);
   for (var staff = 0; staff < curScore.staves; ++staff) {
      cursor.staff = staff;
      cursor.voice = 0;
      cursor.rewind(); // set cursor to first chord/rest
      while (!cursor.eos()) {
         if (cursor.isChord()) {
            var chord = cursor.chord();
            if (chord.notes == 3) {
               var base=chord.note(0).pitch;
               var diff1 = chord.note(1).pitch-base;
               var diff2 = chord.note(2).pitch-base;
               if ((diff1 == 4) && (diff2 == 7)) {
                  //Major-chord
                  ++recognized;
                  var text  = new Text(curScore);
                  text.text = tone(base%12);
                  text.yOffset = -5;
                  cursor.putStaffText(text);
               }
               else if ((diff1 == 5) && (diff2 == 9)) {
                  //Major-chord 1. inversion
                  ++recognized;
                  var text  = new Text(curScore);
                  text.text = tone((base+5)%12) + "¹";
                  text.yOffset = -5;
                  cursor.putStaffText(text);
               }
               else if ((diff1 == 3) && (diff2 == 8)) {
                  //Major-chord 2. inversion
                  ++recognized;
                  var text  = new Text(curScore);
                  text.text = tone((base+8)%12) + "²";
                  text.yOffset = -5;
                  cursor.putStaffText(text);
               }
               else if ((diff1 == 3) && (diff2 == 7)) {
                  //Minor-chord
                  ++recognized;
                  var text  = new Text(curScore);
                  text.text = tone(base%12) + "m";
                  text.yOffset = -5;
                  cursor.putStaffText(text);
               }
               else if ((diff1 == 5) && (diff2 == 8)) {
                  //Minor-chord 1. inversion
                  ++recognized;
                  var text  = new Text(curScore);
                  text.text = tone((base+5)%12) + "m¹";
                  text.yOffset = -5;
                  cursor.putStaffText(text);
               }
               else if ((diff1 == 4) && (diff2 == 9)) {
                  //Minor-chord 2. inversion
                  ++recognized;
                  var text  = new Text(curScore);
                  text.text = tone((base+9)%12) + "m²";
                  text.yOffset = -5;
                  cursor.putStaffText(text);
               }
            }
            else if (chord.notes == 4) {
               var base = chord.note(0).pitch;
               var diff1 = chord.note(1).pitch-base;
               var diff2 = chord.note(2).pitch-base;
               var diff3 = chord.note(3).pitch-base;
               if ((diff1 == 4) && (diff2 == 7) && (diff3 == 10)) {
                  //Septime-chord
                  ++recognized;
                  var text  = new Text(curScore);
                  text.text = tone(base%12) + "7";
                  text.yOffset = -5;
                  cursor.putStaffText(text);
               }
               else if ((diff1 == 2) && (diff2 == 6) && (diff3 == 9)) {
                  //Septime-chord 1. inversion
                  ++recognized;
                  var text  = new Text(curScore);
                  text.text = tone((base+2)%12) + "7¹";
                  text.yOffset = -5;
                  cursor.putStaffText(text);
               }
               else if ((diff1 == 3) && (diff2 == 5) && (diff3 == 9)) {
                  //Septime-chord 2. inversion
                  ++recognized;
                  var text  = new Text(curScore);
                  text.text = tone((base+5)%12) + "7²";
                  text.yOffset = -5;
                  cursor.putStaffText(text);
               }
               else if ((diff1 == 3) && (diff2 == 6) && (diff3 == 8)) {
                  //Septime-chord 3. inversion
                  ++recognized;
                  var text  = new Text(curScore);
                  text.text = tone((base+8)%12) + "7³";
                  text.yOffset = -5;
                  cursor.putStaffText(text);
               }
            }
         }
         cursor.next();
      }
   } //Next staff
   mb = new QMessageBox();
   mb.setWindowTitle("MuseScore: Harmony Names");
   if (recognized = 1)
      mb.text = recognized + " harmony found";
   else
      mb.text = recognized + " harmonies found";
   mb.exec();
}


function tone(semitone) {
   switch (semitone) {
      case 0: return "C";
      case 1: return "Db";
      case 2: return "D";
      case 3: return "Eb";
      case 4: return "E";
      case 5: return "F";
      case 6: return "Gb";
      case 7: return "G";
      case 8: return "Ab";
      case 9: return "A";
      case 10: return "Bb";
      case 11: return "B";
      default: return "?";
   }
}



//---------------------------------------------------------
// menu: defines were the function will be placed
// in the MuseScore menu structure
//---------------------------------------------------------

var mscorePlugin = {
         menu: 'Plugins.Find harmonies',
         init: init,
         run:  run
         };

mscorePlugin;
