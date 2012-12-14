(*
This file is part of MXE.
See index.html for further information.
*)

open GlGtk

let destroy () = GMain.Main.quit ()

let _ =
  let _ = GtkMain.Main.init () in
  let window = GWindow.window () in
  let _ = window#connect#destroy ~callback:destroy in
  window#show ();
  GMain.Main.main ()
