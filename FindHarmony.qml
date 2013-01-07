import QtQuick 1.0
import MuseScore 1.0


MuseScore {
   version: "1.0"
   description: "This plugin scans every chord and writes the harmony name next to it if one of the 3 types (Major, minor, Septime) is identified. A number indicates the inversion."
   menuPath: 'Plugins.Find harmonies'
   onRun: {
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

      if (typeof curScore === 'undefined')
         Qt.quit();
	
      var recognized = 0;
      var cursor = curScore.newCursor();
      for (var staff = 0; staff < curScore.nstaves; ++staff) {
         cursor.staffIdx = staff;
         cursor.voice = 0;
         cursor.rewind(0); // set cursor to first chord/rest
         while (cursor.segment) {
            if (cursor.element && cursor.element.type == Element.CHORD) {
               var chord = cursor.element;
               if (chord.notes.length == 3) {
                  var base  = chord.notes[0].pitch;
                  var diff1 = chord.notes[1].pitch - base;
                  var diff2 = chord.notes[2].pitch - base;
                  if ((diff1 == 4) && (diff2 == 7)) {
                     //Major-chord
                     ++recognized;
                     var text  = newElement(Element.STAFF_TEXT);
                     text.text = tone(base % 12);
                     text.pos.y = 1;
                     cursor.add(text);
                  }
                  else if ((diff1 == 5) && (diff2 == 9)) {
                     //Major-chord 1. inversion
                     ++recognized;
                     var text  = newElement(Element.STAFF_TEXT);
                     text.text = tone((base + 5) % 12) + "1"; // 1 superscript
                     text.pos.y = 1;
                     cursor.add(text);
                  }
                  else if ((diff1 == 3) && (diff2 == 8)) {
                     //Major-chord 2. inversion
                     ++recognized;
                     var text  = newElement(Element.STAFF_TEXT);
                     text.text = tone((base + 8) % 12) + "2"; // 2 superscript
                     text.pos.y = 1;
                     cursor.add(text);
                  }
                  else if ((diff1 == 3) && (diff2 == 7)) {
                     //Minor-chord
                     ++recognized;
                     var text  = newElement(Element.STAFF_TEXT);
                     text.text = tone(base % 12) + "m";
                     text.pos.y = 1;
                     cursor.add(text);
                  }
                  else if ((diff1 == 5) && (diff2 == 8)) {
                     //Minor-chord 1. inversion
                     ++recognized;
                     var text  = newElement(Element.STAFF_TEXT);
                     text.text = tone((base + 5) % 12) + "m1"; // 1 superscript
                     text.pos.y = 1;
                     cursor.add(text);
                  }
                  else if ((diff1 == 4) && (diff2 == 9)) {
                     //Minor-chord 2. inversion
                     ++recognized;
                     var text  = newElement(Element.STAFF_TEXT);
                     text.text = tone((base + 9) % 12) + "m2"; // 2 superscript
                     text.pos.y = 1;
                     cursor.add(text);
                  }
               }
               else if (chord.notes.length == 4) {
                  var base  = chord.notes[0].pitch;
                  var diff1 = chord.notes[1].pitch - base;
                  var diff2 = chord.notes[2].pitch - base;
                  var diff3 = chord.notes[3].pitch - base;
                  if ((diff1 == 4) && (diff2 == 7) && (diff3 == 10)) {
                     //Septime-chord
                     ++recognized;
                     var text  = newElement(Element.STAFF_TEXT);
                     text.text = tone(base % 12) + "7";
                     text.pos.y = 1;
                     cursor.add(text);
                  }
                  else if ((diff1 == 2) && (diff2 == 6) && (diff3 == 9)) {
                     //Septime-chord 1. inversion
                     ++recognized;
                     var text  = newElement(Element.STAFF_TEXT);
                     text.text = tone((base + 2) % 12) + "71"; // 1 superscript
                     text.pos.y = 1;
                     cursor.add(text);
                  }
                  else if ((diff1 == 3) && (diff2 == 5) && (diff3 == 9)) {
                     //Septime-chord 2. inversion
                     ++recognized;
                     var text  = newElement(Element.STAFF_TEXT);
                     text.text = tone((base + 5) % 12) + "72"; // 2 superscript
                     text.pos.y = 1;
                     cursor.add(text);
                  }
                  else if ((diff1 == 3) && (diff2 == 6) && (diff3 == 8)) {
                     //Septime-chord 3. inversion
                     ++recognized;
                     var text  = newElement(Element.STAFF_TEXT);
                     text.text = tone((base + 8) % 12) + "73"; // 3 superscript
                     text.pos.y = 1;
                     cursor.add(text);
                  }
               }
            }
            cursor.next();
         }
      } //Next staff

      //mb = new QMessageBox();
      //mb.setWindowTitle("MuseScore: Harmony Names");
      if (recognized == 1) {
         //mb.text = recognized + " harmony found";
         console.log(recognized + " harmony found");
      }
      else {
         //mb.text = recognized + " harmonies found";
         console.log(recognized + " harmonies found");
      }
      //mb.exec();
      Qt.quit();
   }
}
